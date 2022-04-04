//
// Copyright 2020 Ettus Research, a National Instruments Brand
// Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later
//

#include <uhd/types/direction.hpp>
#include <uhd/types/eeprom.hpp>
#include <uhd/utils/algorithm.hpp>
#include <uhd/utils/assert_has.hpp>
#include <uhd/utils/log.hpp>
#include <uhd/utils/math.hpp>
#include <uhdlib/usrp/dboard/thinbx/thinbx_dboard.hpp>
#include <uhdlib/utils/narrow.hpp>
#include <cstdlib>
#include <sstream>

namespace uhd { namespace usrp { namespace thinbx {

/******************************************************************************
 * Structors
 *****************************************************************************/
thinbx_dboard_impl::thinbx_dboard_impl(register_iface& reg_iface,
    const size_t reg_base_address,
    time_accessor_fn_type&& time_accessor,
    const size_t db_idx,
    const std::string& radio_slot,
    const std::string& rpc_prefix,
    const std::string& unique_id,
    uhd::usrp::x400_rpc_iface::sptr mb_rpcc,
    uhd::usrp::zbx_rpc_iface::sptr rpcc,
    uhd::rfnoc::x400::rfdc_control::sptr rfdcc,
    uhd::property_tree::sptr tree)
    : _unique_id(unique_id)
    , _regs(reg_iface)
    , _reg_base_address(reg_base_address)
    , _time_accessor(time_accessor)
    , _radio_slot(radio_slot)
    , _db_idx(db_idx)
    , _rpc_prefix(rpc_prefix)
    , _mb_rpcc(mb_rpcc)
    , _rpcc(rpcc)
    , _rfdcc(rfdcc)
    , _tree(tree)
    , _rfdc_rate(_rpcc->get_dboard_sample_rate())
    , _prc_rate(_rpcc->get_dboard_prc_rate())
{
    RFNOC_LOG_TRACE("Entering thinbx_dboard_impl ctor...");
    RFNOC_LOG_TRACE("Radio slot: " << _radio_slot);

    _expert_container =
        uhd::experts::expert_factory::create_container("thinbx_radio_" + _radio_slot);
    // Prop tree requires the initialization of certain peripherals
    _init_prop_tree();
    _expert_container->resolve_all();

    // _expert_container->debug_audit();
}

thinbx_dboard_impl::~thinbx_dboard_impl()
{
    RFNOC_LOG_TRACE("thinbx_dboard::dtor() ");
}

void thinbx_dboard_impl::deinit()
{
    _wb_ifaces.clear();
}

void thinbx_dboard_impl::set_command_time(uhd::time_spec_t time, const size_t chan)
{
    // When the command time gets updated, import it into the expert graph
    get_tree()
        ->access<time_spec_t>(fs_path("dboard") / "rx_frontends" / chan / "time/cmd")
        .set(time);
}

std::string thinbx_dboard_impl::get_unique_id() const
{
    return _unique_id;
}


/******************************************************************************
 * API Calls
 *****************************************************************************/
void thinbx_dboard_impl::set_tx_antenna(const std::string& ant, const size_t chan)
{
    RFNOC_LOG_TRACE("Setting TX antenna to " << ant << " for chan " << chan);
    if (!TX_ANTENNA_NAME_COMPAT_MAP.count(ant)) {
        assert_has(TX_ANTENNAS, ant, "tx antenna");
    }
    const fs_path fe_path = _get_frontend_path(TX_DIRECTION, chan);

    _tree->access<std::string>(fe_path / "antenna" / "value").set(ant);
}

void thinbx_dboard_impl::set_rx_antenna(const std::string& ant, const size_t chan)
{
    RFNOC_LOG_TRACE("Setting RX antenna to " << ant << " for chan " << chan);
    if (!RX_ANTENNA_NAME_COMPAT_MAP.count(ant)) {
        assert_has(RX_ANTENNAS, ant, "rx antenna");
    }

    const fs_path fe_path = _get_frontend_path(RX_DIRECTION, chan);

    _tree->access<std::string>(fe_path / "antenna" / "value").set(ant);
}

double thinbx_dboard_impl::set_tx_frequency(const double req_freq, const size_t chan)
{
    const fs_path fe_path = _get_frontend_path(TX_DIRECTION, chan);

    _tree->access<double>(fe_path / "freq").set(req_freq);

    // Our power manager sets a new gain value via the API, based on its new calculations.
    // Since the expert nodes are protected by a mutex, it will hang if we try to call
    // update_power() from inside the expert resolve methods (resolve() -> update_power()
    // -> set_tx_gain -> resolve())
    // _tx_pwr_mgr.at(chan)->update_power();

    return _tree->access<double>(fe_path / "freq").get();
}

double thinbx_dboard_impl::set_rx_frequency(const double req_freq, const size_t chan)
{
    const fs_path fe_path = _get_frontend_path(RX_DIRECTION, chan);

    _tree->access<double>(fe_path / "freq").set(req_freq);

    // Our power manager sets a new gain value via the API, based on its new calculations.
    // Since the expert nodes are protected by a mutex, it will hang if we try to call
    // update_power() from inside the expert resolve methods (resolve() -> update_power()
    // -> set_rx_gain -> resolve())
    // _rx_pwr_mgr.at(chan)->update_power();
    return _tree->access<double>(fe_path / "freq").get();
}

double thinbx_dboard_impl::set_tx_bandwidth(const double bandwidth, const size_t chan)
{
    const double bw = get_tx_bandwidth(chan);
    if (!uhd::math::frequencies_are_equal(bandwidth, bw)) {
        RFNOC_LOG_WARNING("Invalid analog bandwidth: " << (bandwidth / 1e6) << " MHz.");
    }
    return bw;
}

double thinbx_dboard_impl::get_tx_bandwidth(size_t chan)
{
    return _tree
        ->access<double>(_get_frontend_path(TX_DIRECTION, chan) / "bandwidth/value")
        .get();
}

double thinbx_dboard_impl::set_rx_bandwidth(const double bandwidth, const size_t chan)
{
    const double bw = get_rx_bandwidth(chan);
    if (!uhd::math::frequencies_are_equal(bandwidth, bw)) {
        RFNOC_LOG_WARNING("Invalid analog bandwidth: " << (bandwidth / 1e6) << " MHz.");
    }
    return bw;
}

double thinbx_dboard_impl::get_rx_bandwidth(size_t chan)
{
    return _tree
        ->access<double>(_get_frontend_path(RX_DIRECTION, chan) / "bandwidth/value")
        .get();
}

double thinbx_dboard_impl::set_tx_gain(
    const double gain, const std::string& name_, const size_t chan)
{
    return 0;
}

double thinbx_dboard_impl::set_rx_gain(
    const double gain, const std::string& name_, const size_t chan)
{
    return 0;
}

double thinbx_dboard_impl::set_tx_gain(const double gain, const size_t chan)
{
    return 0;
}

double thinbx_dboard_impl::set_rx_gain(const double gain, const size_t chan)
{
    return 0;
}

double thinbx_dboard_impl::get_tx_gain(const size_t chan)
{
    return 0;
}

double thinbx_dboard_impl::get_rx_gain(const size_t chan)
{
    return 0;
}

double thinbx_dboard_impl::get_tx_gain(const std::string& name_, const size_t chan)
{
    return 0;
}

double thinbx_dboard_impl::get_rx_gain(const std::string& name_, const size_t chan)
{
    return 0;
}

std::vector<std::string> thinbx_dboard_impl::get_tx_gain_names(const size_t chan) const
{
    return {""};
}

std::vector<std::string> thinbx_dboard_impl::get_rx_gain_names(const size_t chan) const
{
    return {""};
}

const std::string thinbx_dboard_impl::get_tx_lo_source(
    const std::string& name, const size_t chan)
{
    return "";
}

const std::string thinbx_dboard_impl::get_rx_lo_source(
    const std::string& name, const size_t chan)
{
    return "";
}

void thinbx_dboard_impl::set_rx_lo_source(
    const std::string& src, const std::string& name, const size_t chan)
{
    RFNOC_LOG_TRACE("set_rx_lo_source(name=" << name << ", src=" << src << ")");
}

void thinbx_dboard_impl::set_tx_lo_source(
    const std::string& src, const std::string& name, const size_t chan)
{
    RFNOC_LOG_TRACE("set_tx_lo_source(name=" << name << ", src=" << src << ")");
}

double thinbx_dboard_impl::set_tx_lo_freq(
    double freq, const std::string& name, const size_t chan)
{
    RFNOC_LOG_TRACE("set_tx_lo_freq(freq=" << freq << ", name=" << name << ")");
}

double thinbx_dboard_impl::get_tx_lo_freq(const std::string& name, const size_t chan)
{
    return 0;
}

freq_range_t thinbx_dboard_impl::_get_lo_freq_range(
    const std::string& name, const size_t /*chan*/) const
{
    if (name == RFDC_NCO) {
        // It might make sense to constrain the possible NCO values more, since
        // the bandpass filters for IF2 only allow a certain range. Note that LO1
        // and LO2 freq ranges are also constrained by their analog filters.
        // But in principle, this is the range for the NCO... so why not.
        return freq_range_t{0.0, _rfdc_rate};
    }
    throw uhd::value_error("Invalid LO name: " + name);
}

double thinbx_dboard_impl::set_rx_lo_freq(
    double freq, const std::string& name, const size_t chan)
{
    RFNOC_LOG_TRACE("set_rx_lo_freq(freq=" << freq << ", name=" << name << ")");
    const fs_path fe_path = _get_frontend_path(RX_DIRECTION, chan);
    assert_has(ZBX_LOS, name);

    return _tree->access<double>(fe_path / "los" / name / "freq" / "value")
        .set(freq)
        .get();
}

double thinbx_dboard_impl::get_rx_lo_freq(const std::string& name, size_t chan)
{
    RFNOC_LOG_TRACE("get_rx_lo_freq(name=" << name << ")");
    const fs_path fe_path = _get_frontend_path(RX_DIRECTION, chan);
    assert_has(ZBX_LOS, name);

    return _tree->access<double>(fe_path / "los" / name / "freq" / "value").get();
}

std::string thinbx_dboard_impl::get_tx_antenna(size_t chan) const
{
    const fs_path fe_path = _get_frontend_path(TX_DIRECTION, chan);
    return _tree->access<std::string>(fe_path / "antenna" / "value").get();
}

std::string thinbx_dboard_impl::get_rx_antenna(size_t chan) const
{
    const fs_path fe_path = _get_frontend_path(RX_DIRECTION, chan);
    return _tree->access<std::string>(fe_path / "antenna" / "value").get();
}

double thinbx_dboard_impl::get_tx_frequency(size_t chan)
{
    const fs_path fe_path = _get_frontend_path(TX_DIRECTION, chan);
    return _tree->access<double>(fe_path / "freq").get();
}

double thinbx_dboard_impl::get_rx_frequency(size_t chan)
{
    const fs_path fe_path = _get_frontend_path(RX_DIRECTION, chan);
    return _tree->access<double>(fe_path / "freq").get();
}

void thinbx_dboard_impl::set_tx_tune_args(const uhd::device_addr_t&, const size_t)
{
    RFNOC_LOG_TRACE("tune_args not supported by this radio.");
}

void thinbx_dboard_impl::set_rx_tune_args(const uhd::device_addr_t&, const size_t)
{
    RFNOC_LOG_TRACE("tune_args not supported by this radio.");
}

void thinbx_dboard_impl::set_rx_agc(const bool, const size_t)
{
    throw uhd::not_implemented_error("set_rx_agc() is not supported on this radio!");
}

uhd::gain_range_t thinbx_dboard_impl::get_tx_gain_range(
    const std::string& name, const size_t chan) const
{
    // We have to accept the empty string for "all", because that's widely used
    // (e.g. by multi_usrp)
    if (!name.empty() && name != ZBX_GAIN_STAGE_ALL) {
        throw uhd::value_error(
            std::string("get_tx_gain_range(): Unknown gain name '") + name + "'!");
    }
    return get_tx_gain_range(chan);
}

uhd::gain_range_t thinbx_dboard_impl::get_rx_gain_range(
    const std::string& name, const size_t chan) const
{
    // We have to accept the empty string for "all", because that's widely used
    // (e.g. by multi_usrp)
    if (!name.empty() && name != ZBX_GAIN_STAGE_ALL) {
        throw uhd::value_error(
            std::string("get_rx_gain_range(): Unknown gain name '") + name + "'!");
    }
    return get_rx_gain_range(chan);
}

void thinbx_dboard_impl::set_rx_lo_export_enabled(bool, const std::string&, const size_t)
{
    throw uhd::not_implemented_error(
        "set_rx_lo_export_enabled is not supported on this radio");
}

bool thinbx_dboard_impl::get_rx_lo_export_enabled(const std::string&, const size_t)
{
    return false;
}

void thinbx_dboard_impl::set_tx_lo_export_enabled(bool, const std::string&, const size_t)
{
    throw uhd::not_implemented_error(
        "set_rx_lo_export_enabled is not supported on this radio");
}

bool thinbx_dboard_impl::get_tx_lo_export_enabled(const std::string&, const size_t)
{
    return false;
}

/******************************************************************************
 * EEPROM API
 *****************************************************************************/
eeprom_map_t thinbx_dboard_impl::get_db_eeprom()
{
    return _mb_rpcc->get_db_eeprom(_db_idx);
}

size_t thinbx_dboard_impl::get_chan_from_dboard_fe(
    const std::string& fe, const uhd::direction_t) const
{
    if (fe == "0") {
        return 0;
    }
    if (fe == "1") {
        return 1;
    }
    throw uhd::key_error(std::string("[X400] Invalid frontend: ") + fe);
}

std::string thinbx_dboard_impl::get_dboard_fe_from_chan(
    const size_t chan, const uhd::direction_t) const
{
    if (chan == 0) {
        return "0";
    }
    if (chan == 1) {
        return "1";
    }
    throw uhd::lookup_error(
        std::string("[X400] Invalid channel: ") + std::to_string(chan));
}

/*********************************************************************
 *   Private misc/calculative helper functions
 **********************************************************************/

fs_path thinbx_dboard_impl::_get_frontend_path(
    const direction_t dir, const size_t chan_idx) const
{
    UHD_ASSERT_THROW(chan_idx < ZBX_NUM_CHANS);
    const std::string frontend = dir == TX_DIRECTION ? "tx_frontends" : "rx_frontends";
    return fs_path("dboard") / frontend / chan_idx;
}

std::vector<uhd::usrp::pwr_cal_mgr::sptr>& thinbx_dboard_impl::get_pwr_mgr(
    uhd::direction_t trx)
{
    switch (trx) {
        case uhd::RX_DIRECTION:
            return _rx_pwr_mgr;
        case uhd::TX_DIRECTION:
            return _tx_pwr_mgr;
        default:
            UHD_THROW_INVALID_CODE_PATH();
    }
}

}}} // namespace uhd::usrp::thinbx
