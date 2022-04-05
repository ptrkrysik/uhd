//
// Copyright 2020 Ettus Research, a National Instruments Brand
// Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later
//

#pragma once

#include "thinbx_constants.hpp"
#include <uhd/cal/container.hpp>
#include <uhd/cal/dsa_cal.hpp>
#include <uhd/property_tree.hpp>
#include <uhd/types/direction.hpp>
#include <uhd/types/ranges.hpp>
#include <uhdlib/experts/expert_nodes.hpp>
#include <uhdlib/rfnoc/rf_control/gain_profile_iface.hpp>
#include <uhdlib/usrp/common/pwr_cal_mgr.hpp>
#include <uhdlib/usrp/common/rpc.hpp>
#include <uhdlib/usrp/common/x400_rfdc_control.hpp>
#include <uhdlib/utils/rpc.hpp>
#include <cmath>
#include <memory>

namespace uhd { namespace usrp { namespace thinbx {

/*!---------------------------------------------------------
 * thinbx_scheduling_expert
 *
 * This expert is responsible for scheduling time sensitive actions
 * in other experts. It responds to changes in the command time and
 * selectively causes experts to run in order to ensure a synchronized
 * system.
 *
 * There is one scheduling expert per channel, they are shared between RX and TX.
 * So, 2 scheduling experts total per radio block.
 * ---------------------------------------------------------
 */
class thinbx_scheduling_expert : public experts::worker_node_t
{
public:
    thinbx_scheduling_expert(
        const experts::node_retriever_t& db, const uhd::fs_path fe_path)
        : experts::worker_node_t(fe_path / "thinbx_scheduling_expert")
        , _command_time(db, fe_path / "time/cmd")
        , _frontend_time(db, fe_path / "time/fe")
    {
        bind_accessor(_command_time);
        bind_accessor(_frontend_time);
    }

private:
    virtual void resolve();

    // Inputs
    experts::data_reader_t<time_spec_t> _command_time;

    // Outputs
    experts::data_writer_t<time_spec_t> _frontend_time;
};

/*!---------------------------------------------------------
 * thinbx_freq_fe_expert (Frequency Front-end Expert)
 *
 * This expert is responsible for responding to user requests for center frequency tuning
 *
 * This should trigger:
 *    - relevant LO experts
 *    - adjacent MPM expert
 *    - adjacent CPLD (tx/rx) Programming expert
 * After all of the above, the Frequency Backend expert should be triggered to returned
 * the coerced center frequency
 *
 * One instance of this expert is required for each combination of Direction (TX/RX) and
 * Channel (0,1); four total
 * --------------------------------------------------------
 */
class thinbx_freq_fe_expert : public uhd::experts::worker_node_t
{
public:
    thinbx_freq_fe_expert(const uhd::experts::node_retriever_t& db,
        const uhd::fs_path fe_path,
        const uhd::direction_t trx,
        const double rfdc_rate)
        // const double lo_step_size)
        // const size_t chan,
        : experts::worker_node_t(fe_path / "thinbx_freq_fe_expert")
        , _desired_frequency(db, fe_path / "freq" / "desired")
        , _band_inverted(db, fe_path / "band_inverted")
        , _rfdc_rate(rfdc_rate)
        , _trx(trx)
        , _rfdc_freq_desired(
              db, fe_path / "los" / RFDC_NCO / "freq" / "value" / "desired")
    {
        //  Inputs
        bind_accessor(_desired_frequency);

        //  Outputs
        bind_accessor(_rfdc_freq_desired);
        bind_accessor(_band_inverted);
    }

private:
    void resolve() override;

    // Inputs from user/API
    uhd::experts::data_reader_t<double> _desired_frequency;

    // Outputs
    // From calculation, to LO expert
    uhd::experts::data_writer_t<double> _rfdc_freq_desired;
    uhd::experts::data_writer_t<bool> _band_inverted;

    const double _rfdc_rate;
    const uhd::direction_t _trx;
};

/*!---------------------------------------------------------
 * thinbx_freq_be_expert (Frequency Back-end Expert)
 *
 * This expert is responsible for calculating the final coerced frequency and returning it
 * to the user
 *
 * This should trigger:
 *    - adjacent gain expert
 *
 * One instance of this expert is required for each combination of Direction (TX/RX) and
 * Channel (0,1); four total
 * --------------------------------------------------------
 */
class thinbx_freq_be_expert : public uhd::experts::worker_node_t
{
public:
    thinbx_freq_be_expert(
        const uhd::experts::node_retriever_t& db, const uhd::fs_path fe_path)
        : uhd::experts::worker_node_t(fe_path / "thinbx_freq_be_expert")
        , _rfdc_freq_coerced(
              db, fe_path / "los" / RFDC_NCO / "freq" / "value" / "coerced")
        , _coerced_frequency(db, fe_path / "freq" / "coerced")
    {
        //  Inputs
        bind_accessor(_rfdc_freq_coerced);

        //  Outputs
        bind_accessor(_coerced_frequency);
    }

private:
    void resolve() override;

    // Inputs from LO expert(s)
    uhd::experts::data_reader_t<double> _rfdc_freq_coerced;

    // Output to user/API
    uhd::experts::data_writer_t<double> _coerced_frequency;
};

/*! DSA coercer expert
 *
 * Knows how to coerce a DSA value.
 */
class thinbx_gain_coercer_expert : public uhd::experts::worker_node_t
{
public:
    thinbx_gain_coercer_expert(const uhd::experts::node_retriever_t& db,
        const uhd::fs_path gain_path,
        const uhd::meta_range_t valid_range)
        : uhd::experts::worker_node_t(gain_path / "thinbx_gain_coercer_expert")
        , _gain_desired(db, gain_path / "desired")
        , _gain_coerced(db, gain_path / "coerced")
        , _valid_range(valid_range)
    {
        bind_accessor(_gain_desired);
        bind_accessor(_gain_coerced);
    }

private:
    void resolve() override;
    // Input
    uhd::experts::data_reader_t<double> _gain_desired;
    // Output
    uhd::experts::data_writer_t<double> _gain_coerced;
    // Attributes
    const uhd::meta_range_t _valid_range;
};

/*!---------------------------------------------------------
 * thinbx_tx_gain_expert (TX Gain Expert)
 *
 * This expert is responsible for controlling the gain of each TX channel.
 * If the gain profile is set to default, then it will look up the corresponding
 * amp and DSA values and write them to those nodes.
 *
 * This should trigger:
 *    - Adjacent CPLD TX Programming Expert
 *
 * One instance of this expert is required for each TX Channel (0,1); two total
 * --------------------------------------------------------
 */
// class thinbx_tx_gain_expert : public uhd::experts::worker_node_t
// {
// public:
//     thinbx_tx_gain_expert(const uhd::experts::node_retriever_t& db,
//         const uhd::fs_path fe_path,
//         const size_t chan,
//         uhd::usrp::pwr_cal_mgr::sptr power_mgr,
//         uhd::usrp::cal::zbx_tx_dsa_cal::sptr dsa_cal)
//         : uhd::experts::worker_node_t(fe_path / "thinbx_gain_expert")
//         , _gain_in(db, fe_path / "gains" / ZBX_GAIN_STAGE_ALL / "value" / "desired")
//         , _profile(db, fe_path / "gains" / "all" / "profile")
//         , _frequency(db, fe_path / "freq" / "coerced")
//         , _gain_out(db, fe_path / "gains" / ZBX_GAIN_STAGE_ALL / "value" / "coerced")
//         , _dsa1(db, fe_path / "gains" / ZBX_GAIN_STAGE_DSA1 / "value" / "desired")
//         , _dsa2(db, fe_path / "gains" / ZBX_GAIN_STAGE_DSA2 / "value" / "desired")
//         , _amp_gain(db, fe_path / "gains" / ZBX_GAIN_STAGE_AMP / "value" / "desired")
//         , _power_mgr(power_mgr)
//         , _dsa_cal(dsa_cal)
//         , _chan(chan)
//     {
//         bind_accessor(_gain_in);
//         bind_accessor(_profile);
//         bind_accessor(_frequency);
//         bind_accessor(_gain_out);
//         bind_accessor(_dsa1);
//         bind_accessor(_dsa2);
//         bind_accessor(_amp_gain);
//     }

// private:
//     void resolve() override;
//     void _set_tx_dsa(const std::string, const uint8_t desired_gain);
//     double _set_tx_amp_by_gain(const double gain);
//     // Inputs from user/API
//     uhd::experts::data_reader_t<double> _gain_in;
//     // Inputs for DSA calibration
//     uhd::experts::data_reader_t<std::string> _profile;
//     uhd::experts::data_reader_t<double> _frequency;

//     // Output to user/API
//     uhd::experts::data_writer_t<double> _gain_out;
//     // Outputs to CPLD programming expert
//     uhd::experts::data_writer_t<double> _dsa1;
//     uhd::experts::data_writer_t<double> _dsa2;
//     uhd::experts::data_writer_t<double> _amp_gain;

//     uhd::usrp::pwr_cal_mgr::sptr _power_mgr;
//     uhd::usrp::cal::zbx_tx_dsa_cal::sptr _dsa_cal;
//     const size_t _chan;
// };

/*!---------------------------------------------------------
 * thinbx_rx_gain_expert (RX Gain Expert)
 *
 * This expert is responsible for controlling the gain of each RX channel
 *
 * This should trigger:
 *    - Adjacent CPLD RX Programming Expert
 *
 * One instance of this expert is required for each RX Channel (0,1); two total
 * --------------------------------------------------------
 */
// class thinbx_rx_gain_expert : public uhd::experts::worker_node_t
// {
// public:
//     thinbx_rx_gain_expert(const uhd::experts::node_retriever_t& db,
//         const uhd::fs_path fe_path,
//         uhd::usrp::pwr_cal_mgr::sptr power_mgr,
//         uhd::usrp::cal::zbx_rx_dsa_cal::sptr dsa_cal)
//         : uhd::experts::worker_node_t(fe_path / "thinbx_gain_expert")
//         , _gain_in(db, fe_path / "gains" / ZBX_GAIN_STAGE_ALL / "value" / "desired")
//         , _profile(db, fe_path / "gains" / "all" / "profile")
//         , _frequency(db, fe_path / "freq" / "coerced")
//         , _gain_out(db, fe_path / "gains" / ZBX_GAIN_STAGE_ALL / "value" / "coerced")
//         , _dsa1(db, fe_path / "gains" / ZBX_GAIN_STAGE_DSA1 / "value" / "desired")
//         , _dsa2(db, fe_path / "gains" / ZBX_GAIN_STAGE_DSA2 / "value" / "desired")
//         , _dsa3a(db, fe_path / "gains" / ZBX_GAIN_STAGE_DSA3A / "value" / "desired")
//         , _dsa3b(db, fe_path / "gains" / ZBX_GAIN_STAGE_DSA3B / "value" / "desired")
//         , _power_mgr(power_mgr)
//         , _dsa_cal(dsa_cal)
//     {
//         bind_accessor(_gain_in);
//         bind_accessor(_profile);
//         bind_accessor(_frequency);
//         bind_accessor(_gain_out);
//         bind_accessor(_dsa1);
//         bind_accessor(_dsa2);
//         bind_accessor(_dsa3a);
//         bind_accessor(_dsa3b);
//     }

// private:
//     void resolve() override;

//     // Inputs from user/API
//     uhd::experts::data_reader_t<double> _gain_in;
//     uhd::experts::data_reader_t<std::string> _profile;
//     // Inputs for dsa calibration
//     uhd::experts::data_reader_t<double> _frequency;

//     // Output to user/API
//     uhd::experts::data_writer_t<double> _gain_out;
//     // Outputs to CPLD programming expert
//     uhd::experts::data_writer_t<double> _dsa1;
//     uhd::experts::data_writer_t<double> _dsa2;
//     uhd::experts::data_writer_t<double> _dsa3a;
//     uhd::experts::data_writer_t<double> _dsa3b;

//     uhd::usrp::pwr_cal_mgr::sptr _power_mgr;
//     uhd::usrp::cal::zbx_rx_dsa_cal::sptr _dsa_cal;
// };

/*!---------------------------------------------------------
 * thinbx_band_inversion_expert
 *
 * This expert is responsible for handling the band inversion calls to MPM on the target
 * device
 *
 * This expert should not trigger any others
 *
 * One instance of this expert is required for each Direction (TX/RX) and Channel (0,1);
 * four total
 * --------------------------------------------------------
 */
class thinbx_band_inversion_expert : public uhd::experts::worker_node_t
{
public:
    thinbx_band_inversion_expert(const uhd::experts::node_retriever_t& db,
        const uhd::fs_path fe_path,
        const uhd::direction_t trx,
        const size_t chan,
        uhd::usrp::zbx_rpc_iface::sptr rpcc)
        : uhd::experts::worker_node_t(fe_path / "thinbx_band_inversion_expert")
        , _is_band_inverted(db, fe_path / "band_inverted")
        , _rpcc(rpcc)
        , _trx(trx)
        , _chan(chan)
    {
        bind_accessor(_is_band_inverted);
    }

private:
    void resolve() override;

    // Inputs from Frequency FE expert
    uhd::experts::data_reader_t<bool> _is_band_inverted;

    uhd::usrp::zbx_rpc_iface::sptr _rpcc;
    const uhd::direction_t _trx;
    const size_t _chan;
};

/*!---------------------------------------------------------
 * thinbx_rfdc_freq_expert
 *
 * This expert is responsible for handling any rfdc frequency calls to MPM on the target
 * device
 *
 * This expert should not trigger any experts
 *
 * One instance of this expert is required for each Direction (TX/RX) and Channel (0,1);
 * four total
 * --------------------------------------------------------
 */
class thinbx_rfdc_freq_expert : public uhd::experts::worker_node_t
{
public:
    thinbx_rfdc_freq_expert(const uhd::experts::node_retriever_t& db,
        const uhd::fs_path fe_path,
        const uhd::direction_t trx,
        const size_t chan,
        const std::string rpc_prefix,
        int db_idx,
        uhd::usrp::x400_rpc_iface::sptr rpcc)
        : uhd::experts::worker_node_t(fe_path / "thinbx_rfdc_freq_expert")
        , _rfdc_freq_desired(
              db, fe_path / "los" / RFDC_NCO / "freq" / "value" / "desired")
        , _rfdc_freq_coerced(
              db, fe_path / "los" / RFDC_NCO / "freq" / "value" / "coerced")
        , _rpc_prefix(rpc_prefix)
        , _db_idx(db_idx)
        , _rpcc(rpcc)
        , _trx(trx)
        , _chan(chan)
    {
        bind_accessor(_rfdc_freq_desired);
        bind_accessor(_rfdc_freq_coerced);
    }

private:
    void resolve() override;

    // Inputs from user/API
    uhd::experts::data_reader_t<double> _rfdc_freq_desired;

    // Outputs to user/API
    uhd::experts::data_writer_t<double> _rfdc_freq_coerced;

    const std::string _rpc_prefix;
    const size_t _db_idx;
    uhd::usrp::x400_rpc_iface::sptr _rpcc;
    const uhd::direction_t _trx;
    const size_t _chan;
};

using uhd::rfnoc::x400::rfdc_control;
/*!---------------------------------------------------------
 * thinbx_sync_expert
 *
 * This expert is responsible for handling the phase alignment.
 * Per channel, there are up to 4 things whose phase need syncing: The two
 * LOs, the NCO, and the ADC/DAC gearboxes. However, the LOs share a sync
 * register, and so do the NCOs.  To minimize writes, we thus need a single sync
 * expert at the end of the graph, who combines all LOs and all NCOs.
 * --------------------------------------------------------
 */
class thinbx_sync_expert : public uhd::experts::worker_node_t
{
public:
    thinbx_sync_expert(const uhd::experts::node_retriever_t& db,
        const uhd::fs_path tx_fe_path,
        const uhd::fs_path rx_fe_path,
        rfdc_control::sptr rfdcc)
        // std::shared_ptr<thinbx_cpld_ctrl> cpld)
        : uhd::experts::worker_node_t("thinbx_sync_expert")
        , _fe_time{{db, rx_fe_path / 0 / "time/fe"}, {db, rx_fe_path / 1 / "time/fe"}}
        , _nco_freqs{{rfdc_control::rfdc_type::RX0,
                         {db, rx_fe_path / 0 / "if_freq" / "coerced"}},
              {rfdc_control::rfdc_type::RX1,
                  {db, rx_fe_path / 1 / "los" / RFDC_NCO / "freq" / "value" / "coerced"}},
              {rfdc_control::rfdc_type::TX0,
                  {db, tx_fe_path / 0 / "los" / RFDC_NCO / "freq" / "value" / "coerced"}},
              {rfdc_control::rfdc_type::TX1,
                  {db, tx_fe_path / 1 / "los" / RFDC_NCO / "freq" / "value" / "coerced"}}}

        , _rfdcc(rfdcc)
    {
        for (auto& fe_time : _fe_time) {
            bind_accessor(fe_time);
        }
        for (auto& nco_freq : _nco_freqs) {
            bind_accessor(nco_freq.second);
        }
    }

private:
    void resolve() override;

    // Inputs from user/API
    // Command time: We have 2 channels, one time spec per channel
    std::vector<uhd::experts::data_reader_t<time_spec_t>> _fe_time;
    // We have 4 NCOs
    std::map<rfdc_control::rfdc_type, uhd::experts::data_reader_t<double>> _nco_freqs;

    // This expert has no outputs.

    // Attributes
    rfdc_control::sptr _rfdcc;
    //! Store the sync state of the ADC gearboxes. If false, we assume they're
    // out of sync. This could also be a vector of booleans if we want to be
    // able to sync ADC gearboxes individually.
    bool _adcs_synced = false;
    //! Store the sync state of the DAC gearboxes. If false, we assume they're
    // out of sync. This could also be a vector of booleans if we want to be
    // able to sync DAC gearboxes individually.
    bool _dacs_synced = false;
};

}}} // namespace uhd::usrp::thinbx
