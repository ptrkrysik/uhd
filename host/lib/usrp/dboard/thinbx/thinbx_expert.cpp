//
// Copyright 2020 Ettus Research, a National Instruments Brand
// Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later
//

#include "uhd/types/time_spec.hpp"
#include <uhd/utils/assert_has.hpp>
#include <uhd/utils/log.hpp>
#include <uhd/utils/math.hpp>
#include <uhdlib/usrp/dboard/thinbx/thinbx_expert.hpp>
#include <uhdlib/utils/interpolation.hpp>
#include <uhdlib/utils/narrow.hpp>
#include <algorithm>
#include <array>

using namespace uhd;

namespace uhd { namespace usrp { namespace thinbx {

namespace {

/*********************************************************************
 *   Misc/calculative helper functions
 **********************************************************************/
bool _is_band_highband(const tune_map_item_t tune_setting)
{
    // Lowband frequency paths do not utilize an RF filter
    return tune_setting.rf_fir == 0;
}

tune_map_item_t _get_tune_settings(const double freq, const uhd::direction_t trx)
{
    auto tune_setting = trx == RX_DIRECTION ? rx_tune_map.begin() : tx_tune_map.begin();

    auto tune_settings_end = trx == RX_DIRECTION ? rx_tune_map.end() : tx_tune_map.end();

    for (; tune_setting != tune_settings_end; ++tune_setting) {
        if (tune_setting->max_band_freq >= freq) {
            return *tune_setting;
        }
    }
    // Didn't find a tune setting.  This frequency should have been clipped, this is an
    // internal error.
    UHD_THROW_INVALID_CODE_PATH();
}

bool _is_band_inverted(
    const uhd::direction_t trx, const double if2_freq, const double rfdc_rate)
// const tune_map_item_t tune_setting)
{
    const bool is_if2_nyquist2 = if2_freq > (rfdc_rate / 2);

    // We count the number of inversions introduced by the signal chain, starting
    // at the RFDC
    const int num_inversions =
        // If we're in the second Nyquist zone, we're inverted
        int(is_if2_nyquist2); // +

    // In the RX direction, an extra inversion is needed
    // TODO: We don't know where this is coming from
    const bool num_inversions_is_odd = num_inversions % 2 != 0;
    if (trx == RX_DIRECTION) {
        return !num_inversions_is_odd;
    } else {
        return num_inversions_is_odd;
    }
}

double _calc_lo2_freq(
    const double if1_freq, const double if2_freq, const int mix2_m, const int mix2_n)
{
    return (if2_freq - (mix2_m * if1_freq)) / mix2_n;
}

double _calc_if2_freq(
    const double if1_freq, const double lo2_freq, const int mix2_m, const int mix2_n)
{
    return mix2_n * lo2_freq + mix2_m * if1_freq;
}

std::string _get_trx_string(const direction_t dir)
{
    if (dir == RX_DIRECTION) {
        return "rx";
    } else if (dir == TX_DIRECTION) {
        return "tx";
    } else {
        UHD_THROW_INVALID_CODE_PATH();
    }
}

// For various RF performance considerations (such as spur reduction), different bands
// vary between using fixed IF1 and/or IF2 or using variable IF1 and/or IF2. Bands with a
// fixed IF1/IF2 have ifX_freq_min == IFX_freq_max, and _calc_ifX_freq() will return that
// single value. Bands with variable IF1/IF2 will shift the IFX based on where in the RF
// band we are tuning by using linear interpolation. (if1 calculation takes place only if
// tune frequency is lowband)
double _calc_if1_freq(const double tune_freq, const tune_map_item_t tune_setting)
{
    if (tune_setting.if1_freq_min == tune_setting.if1_freq_max) {
        return tune_setting.if1_freq_min;
    }

    return uhd::math::linear_interp(tune_freq,
        tune_setting.min_band_freq,
        tune_setting.if1_freq_min,
        tune_setting.max_band_freq,
        tune_setting.if1_freq_max);
}

double _calc_ideal_if2_freq(const double tune_freq, const tune_map_item_t tune_setting)
{
    // linear_interp() wants to interpolate and will throw if these are identical:
    if (tune_setting.if2_freq_min == tune_setting.if2_freq_max) {
        return tune_setting.if2_freq_min;
    }

    return uhd::math::linear_interp(tune_freq,
        tune_setting.min_band_freq,
        tune_setting.if2_freq_min,
        tune_setting.max_band_freq,
        tune_setting.if2_freq_max);
}

} // namespace

/*!---------------------------------------------------------
 * EXPERT RESOLVE FUNCTIONS
 *
 * This sections contains all expert resolve functions.
 * These methods are triggered by any of the bound accessors becoming "dirty",
 * or changing value
 * --------------------------------------------------------
 */
void thinbx_scheduling_expert::resolve()
{
    // We currently have no fancy scheduling, but here is where we'd add it if
    // we need to do that (e.g., plan out SYNC pulse timing vs. NCO timing etc.)
    _frontend_time = _command_time;
}

void thinbx_freq_fe_expert::resolve()
{
    const double tune_freq = ZBX_FREQ_RANGE.clip(_desired_frequency);
    _rfdc_freq_desired     = tune_freq;
    _band_inverted         = _is_band_inverted(_trx, _rfdc_freq_desired, _rfdc_rate);
}


void thinbx_freq_be_expert::resolve()
{
    _coerced_frequency = _rfdc_freq_coerced;

    // Users may change individual settings (LO frequencies, if2 frequencies) and throw
    // the output frequency out of range. We have to stop here so that the gain API
    // doesn't panic (Clipping here would have no effect on the actual output signal)
    using namespace uhd::math::fp_compare;
    if (fp_compare_delta<double>(_coerced_frequency.get()) < ZBX_MIN_FREQ
        || fp_compare_delta<double>(_coerced_frequency.get()) > ZBX_MAX_FREQ) {
        UHD_LOG_WARNING(get_name(),
            "Resulting coerced frequency " << _coerced_frequency.get()
                                           << " is out of range!");
    }
}

void thinbx_gain_coercer_expert::resolve()
{
    _gain_coerced = _valid_range.clip(_gain_desired, true);
}

void thinbx_tx_gain_expert::resolve()
{
    if (_profile != ZBX_GAIN_PROFILE_DEFAULT) {
        return;
    }

    // If a user passes in a gain value, we have to set the Power API tracking mode
    if (_gain_in.is_dirty()) {
        _power_mgr->set_tracking_mode(uhd::usrp::pwr_cal_mgr::tracking_mode::TRACK_GAIN);
    }

    // Now we do the overall gain setting
    // Look up DSA values by gain
    _gain_out             = ZBX_TX_GAIN_RANGE.clip(_gain_in, true);
    const size_t gain_idx = _gain_out / TX_GAIN_STEP;
    // Clip _frequency to valid ZBX range to avoid errors in the scenario when user
    // manually configures LO frequencies and causes an illegal overall frequency
    auto dsa_settings =
        _dsa_cal->get_dsa_setting(ZBX_FREQ_RANGE.clip(_frequency), gain_idx);
    // Now write to downstream nodes, converting attenuations to gains:
    _dsa1 = static_cast<double>(ZBX_TX_DSA_MAX_ATT - dsa_settings[0]);
    _dsa2 = static_cast<double>(ZBX_TX_DSA_MAX_ATT - dsa_settings[1]);
    // Convert amp index to gain
    _amp_gain = ZBX_TX_AMP_GAIN_MAP.at(static_cast<tx_amp>(dsa_settings[2]));
}

void thinbx_rx_gain_expert::resolve()
{
    if (_profile != ZBX_GAIN_PROFILE_DEFAULT) {
        return;
    }

    // If a user passes in a gain value, we have to set the Power API tracking mode
    if (_gain_in.is_dirty()) {
        _power_mgr->set_tracking_mode(uhd::usrp::pwr_cal_mgr::tracking_mode::TRACK_GAIN);
    }

    // Now we do the overall gain setting
    if (_frequency.get() <= RX_LOW_FREQ_MAX_GAIN_CUTOFF) {
        _gain_out = ZBX_RX_LOW_FREQ_GAIN_RANGE.clip(_gain_in, true);
    } else {
        _gain_out = ZBX_RX_GAIN_RANGE.clip(_gain_in, true);
    }
    // Now we do the overall gain setting
    // Look up DSA values by gain
    const size_t gain_idx = _gain_out / RX_GAIN_STEP;
    // Clip _frequency to valid ZBX range to avoid errors in the scenario when user
    // manually configures LO frequencies and causes an illegal overall frequency
    auto dsa_settings =
        _dsa_cal->get_dsa_setting(ZBX_FREQ_RANGE.clip(_frequency), gain_idx);
    // Now write to downstream nodes, converting attenuation to gains:
    _dsa1  = ZBX_RX_DSA_MAX_ATT - dsa_settings[0];
    _dsa2  = ZBX_RX_DSA_MAX_ATT - dsa_settings[1];
    _dsa3a = ZBX_RX_DSA_MAX_ATT - dsa_settings[2];
    _dsa3b = ZBX_RX_DSA_MAX_ATT - dsa_settings[3];
}

void thinbx_band_inversion_expert::resolve()
{
    _rpcc->enable_iq_swap(_is_band_inverted.get(), _get_trx_string(_trx), _chan);
}

void thinbx_rfdc_freq_expert::resolve()
{
    _rfdc_freq_coerced = _rpcc->rfdc_set_nco_freq(
        _get_trx_string(_trx), _db_idx, _chan, _rfdc_freq_desired);
}

void thinbx_sync_expert::resolve()
{
    // Some local helper consts
    constexpr std::array<std::array<rfdc_control::rfdc_type, 2>, 2> ncos{
        {{rfdc_control::rfdc_type::RX0, rfdc_control::rfdc_type::TX0},
            {rfdc_control::rfdc_type::RX1, rfdc_control::rfdc_type::TX1}}};
    // clang-format on

    // Now do some timing checks
    const std::vector<bool> chan_needs_sync = {_fe_time.at(0) != uhd::time_spec_t::ASAP,
        _fe_time.at(1) != uhd::time_spec_t::ASAP};
    // If there's no command time, no need to synchronize anything
    if (!chan_needs_sync[0] && !chan_needs_sync[1]) {
        UHD_LOG_TRACE(get_name(), "No command time: Skipping phase sync.");
        return;
    }
    const bool times_match = _fe_time.at(0) == _fe_time.at(1);

    // ** Find NCOs to synchronize ********************************************
    // Same rules apply as for LOs.
    std::set<rfdc_control::rfdc_type> ncos_to_sync;
    for (const size_t chan : ZBX_CHANNELS) {
        if (chan_needs_sync[chan]) {
            for (const auto& nco_idx : ncos[chan]) {
                if (_nco_freqs.at(nco_idx).is_dirty()) {
                    ncos_to_sync.insert(nco_idx);
                }
            }
        }
    }

    // ** Find ADC/DAC gearboxes to synchronize *******************************
    // Gearboxes are special, because they only need to be synchronized once
    // per session, assuming the command time has been set. Unfortunately we
    // have no way here to know if the timekeeper time was updated, but it is
    // well documented that in order to synchronize devices, one first has to
    // make sure the timekeepers are running in sync (by calling
    // set_time_next_pps() accordingly).
    // The logic we use here is that we will always have to update the NCO when
    // doing a synced tune, so we update all the gearboxes for the NCOs -- but
    // only if they have not yet been synchronized.
    std::set<rfdc_control::rfdc_type> gearboxes_to_sync;
    if (!_adcs_synced) {
        for (const auto rfdc :
            {rfdc_control::rfdc_type::RX0, rfdc_control::rfdc_type::RX1}) {
            if (ncos_to_sync.count(rfdc)) {
                gearboxes_to_sync.insert(rfdc);
                // Technically, they're not synced yet but this saves us from
                // having to look up which RFDCs map to RX again later
                _adcs_synced = true;
            }
        }
    }
    if (!_dacs_synced) {
        for (const auto rfdc :
            {rfdc_control::rfdc_type::TX0, rfdc_control::rfdc_type::TX1}) {
            if (ncos_to_sync.count(rfdc)) {
                gearboxes_to_sync.insert(rfdc);
                // Technically, they're not synced yet but this saves us from
                // having to look up which RFDCs map to TX again later
                _dacs_synced = true;
            }
        }
    }

    // ** Do synchronization **************************************************
    // This is where we orchestrate the sync commands. If sync commands happen
    // at different times, we make sure to send out the earlier one first.
    // If we need to schedule things a bit differently, e.g., we need to
    // manually calculate offsets from the command time so that LO and NCO sync
    // pulses line up, it most likely makes sense to use the scheduling expert
    // for that, and calculate different times for different events there.
    if (times_match) {
        UHD_LOG_TRACE(get_name(),
            "Syncing all channels: " //<< los_to_sync.size() << " LO(s), "
                << ncos_to_sync.size() << " NCO(s), and " << gearboxes_to_sync.size()
                << " gearbox(es).")
        if (!gearboxes_to_sync.empty()) {
            _rfdcc->reset_gearboxes(
                std::vector<rfdc_control::rfdc_type>(
                    gearboxes_to_sync.cbegin(), gearboxes_to_sync.cend()),
                _fe_time.at(0).get());
        }
        if (!ncos_to_sync.empty()) {
            _rfdcc->reset_ncos(std::vector<rfdc_control::rfdc_type>(
                                   ncos_to_sync.cbegin(), ncos_to_sync.cend()),
                _fe_time.at(0).get());
        }
    } else {
        // If the command times differ, we need to manually reorder the commands
        // such that the channel with the earlier time gets precedence
        const size_t first_sync_chan =
            (times_match || (_fe_time.at(0) <= _fe_time.at(1))) ? 0 : 1;
        const auto sync_order = (first_sync_chan == 0) ? std::vector<size_t>{0, 1}
                                                       : std::vector<size_t>{1, 0};
        for (const size_t chan : sync_order) {
            std::vector<thinbx_lo_t> this_chan_los;

            std::vector<rfdc_control::rfdc_type> this_chan_ncos;
            for (const auto nco_idx : ncos[chan]) {
                if (ncos_to_sync.count(nco_idx)) {
                    this_chan_ncos.push_back(nco_idx);
                }
            }
            std::vector<rfdc_control::rfdc_type> this_chan_gearboxes;
            for (const auto gb_idx : ncos[chan]) {
                if (gearboxes_to_sync.count(gb_idx)) {
                    this_chan_gearboxes.push_back(gb_idx);
                }
            }
            UHD_LOG_TRACE(get_name(),
                "Syncing channel " << chan << ": " << this_chan_los.size()
                                   << " LO(s) and " << this_chan_ncos.size()
                                   << " NCO(s).");
            if (!this_chan_gearboxes.empty()) {
                UHD_LOG_TRACE(get_name(),
                    "Resetting " << this_chan_gearboxes.size() << " gearboxes.");
                _rfdcc->reset_gearboxes(this_chan_gearboxes, _fe_time.at(chan).get());
            }
            if (!this_chan_ncos.empty()) {
                _rfdcc->reset_ncos(this_chan_ncos, _fe_time.at(chan).get());
            }
        }
    }
} // thinbx_sync_expert::resolve()

// End expert resolve sections

}}} // namespace uhd::usrp::thinbx
