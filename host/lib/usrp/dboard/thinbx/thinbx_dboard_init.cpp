//
// Copyright 2020 Ettus Research, a National Instruments Brand
// Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later
//

#include <uhd/cal/database.hpp>
#include <uhd/exception.hpp>
#include <uhd/experts/expert_container.hpp>
#include <uhd/experts/expert_factory.hpp>
#include <uhd/property_tree.hpp>
#include <uhd/property_tree.ipp>
#include <uhd/rfnoc/register_iface.hpp>
#include <uhd/types/direction.hpp>
#include <uhd/types/eeprom.hpp>
#include <uhd/types/ranges.hpp>
#include <uhd/types/sensors.hpp>
#include <uhd/utils/log.hpp>
#include <uhdlib/rfnoc/reg_iface_adapter.hpp>
#include <uhdlib/usrp/dboard/thinbx/thinbx_constants.hpp>
#include <uhdlib/usrp/dboard/thinbx/thinbx_dboard.hpp>
#include <uhdlib/usrp/dboard/thinbx/thinbx_expert.hpp>
#include <boost/algorithm/string.hpp>
#include <sstream>
#include <vector>

using namespace uhd;
using namespace uhd::experts;
using namespace uhd::rfnoc;

// ostream << operator overloads for our enum classes, so that property nodes of that type
// can be added to our expert graph
namespace uhd { namespace usrp { namespace thinbx {

// void thinbx_dboard_impl::_init_peripherals()
// {
//     RFNOC_LOG_TRACE("Initializing peripherals...");
//     // Load DSA cal data (rx and tx)
//     constexpr char dsa_step_filename_tx[] = "thinbx_dsa_tx";
//     constexpr char dsa_step_filename_rx[] = "thinbx_dsa_rx";
//     uhd::eeprom_map_t eeprom_map          = get_db_eeprom();
//     const std::string db_serial(eeprom_map["serial"].begin(),
//     eeprom_map["serial"].end()); if (uhd::usrp::cal::database::has_cal_data(
//             dsa_step_filename_tx, db_serial, uhd::usrp::cal::source::ANY)) {
//         RFNOC_LOG_TRACE("load binary TX DSA steps from database...");
//         const auto tx_dsa_data = uhd::usrp::cal::database::read_cal_data(
//             dsa_step_filename_tx, db_serial, uhd::usrp::cal::source::ANY);
//         RFNOC_LOG_TRACE("create TX DSA object...");
//         _tx_dsa_cal = uhd::usrp::cal::zbx_tx_dsa_cal::make();
//         RFNOC_LOG_TRACE("store deserialized TX DSA data into object...");
//         _tx_dsa_cal->deserialize(tx_dsa_data);
//     } else {
//         RFNOC_LOG_ERROR("Could not find TX DSA cal data!");
//         throw uhd::runtime_error("Could not find TX DSA cal data!");
//     }
//     if (uhd::usrp::cal::database::has_cal_data(
//             dsa_step_filename_rx, db_serial, uhd::usrp::cal::source::ANY)) {
//         // read binary blob without knowledge about content
//         RFNOC_LOG_TRACE("load binary RX DSA steps from database...");
//         const auto rx_dsa_data = uhd::usrp::cal::database::read_cal_data(
//             dsa_step_filename_rx, db_serial, uhd::usrp::cal::source::ANY);

//         RFNOC_LOG_TRACE("create RX DSA object...");
//         _rx_dsa_cal = uhd::usrp::cal::zbx_rx_dsa_cal::make();

//         RFNOC_LOG_TRACE("store deserialized RX DSA data into object...");
//         _rx_dsa_cal->deserialize(rx_dsa_data);
//     } else {
//         RFNOC_LOG_ERROR("Could not find RX DSA cal data!");
//         throw uhd::runtime_error("Could not find RX DSA cal data!");
//     }
// }

void thinbx_dboard_impl::_init_prop_tree()
{
    auto subtree = get_tree()->subtree(fs_path("dboard"));

    // Construct RX frontend
    for (size_t chan_idx = 0; chan_idx < THINBX_NUM_CHANS; chan_idx++) {
        const fs_path fe_path = fs_path("rx_frontends") / chan_idx;

        // Command time needs to be shadowed into the property tree so we can use
        // it in the expert graph. TX and RX share the command time, so we could
        // put it onto its own sub-tree, or copy the property between TX and RX.
        // With respect to TwinRX and trying to keep the tree lean and browsable,
        // we compromise and put the command time onto the RX frontend path, even
        // though it's also valid for TX.
        // This data node will be used for scheduling the other experts:
        expert_factory::add_data_node<time_spec_t>(
            _expert_container, fe_path / "time/fe", time_spec_t(0.0));
        // This prop node will be used to import the command time into the
        // graph:
        expert_factory::add_prop_node<time_spec_t>(
            _expert_container, subtree, fe_path / "time/cmd", time_spec_t(0.0));

        _init_frontend_subtree(subtree, RX_DIRECTION, chan_idx, fe_path);

        // The time nodes get connected with one scheduling expert per channel:
        expert_factory::add_worker_node<thinbx_scheduling_expert>(
            _expert_container, _expert_container->node_retriever(), fe_path);
    }

    // Construct TX frontend
    // Note: the TX frontend uses the RX property tree, this must
    // be constructed after the RX frontend
    for (size_t chan_idx = 0; chan_idx < THINBX_NUM_CHANS; chan_idx++) {
        const fs_path fe_path = fs_path("tx_frontends") / chan_idx;
        _init_frontend_subtree(subtree, TX_DIRECTION, chan_idx, fe_path);
    }

    // Now add the sync worker:
    expert_factory::add_worker_node<thinbx_sync_expert>(_expert_container,
        _expert_container->node_retriever(),
        fs_path("tx_frontends"),
        fs_path("rx_frontends"),
        _rfdcc);

    // subtree->create<eeprom_map_t>("eeprom")
    //     .add_coerced_subscriber([](const eeprom_map_t&) {
    //         throw uhd::runtime_error("Attempting to update daughterboard eeprom!");
    //     })
    //     .set_publisher([this]() { return get_db_eeprom(); });
}

void thinbx_dboard_impl::_init_frontend_subtree(uhd::property_tree::sptr subtree,
    const uhd::direction_t trx,
    const size_t chan_idx,
    const fs_path fe_path)
{
    static constexpr char THINBX_FE_NAME[] = "ThinBX";

    RFNOC_LOG_TRACE("Adding non-RFNoC block properties for channel "
                    << chan_idx << " to prop tree path " << fe_path);
    // Standard attributes
    subtree->create<std::string>(fe_path / "name").set(THINBX_FE_NAME);
    subtree->create<std::string>(fe_path / "connection").set("IQ");

    _init_frequency_prop_tree(subtree, _expert_container, fe_path);
    _init_gain_prop_tree(subtree, fe_path);
    _init_antenna_prop_tree(subtree, _expert_container, trx, chan_idx, fe_path);
    _init_lo_prop_tree(subtree, _expert_container, trx, chan_idx, fe_path);
    _init_experts(_expert_container, trx, chan_idx, fe_path);
}


// uhd::usrp::pwr_cal_mgr::sptr thinbx_dboard_impl::_init_power_cal(
//     uhd::property_tree::sptr subtree,
//     const uhd::direction_t trx,
//     const size_t chan_idx,
//     const fs_path fe_path)
// {
//     const std::string DIR = (trx == TX_DIRECTION) ? "TX" : "RX";

//     uhd::eeprom_map_t eeprom_map = get_db_eeprom();
//     /* The cal serial is the DB serial plus the FE name */
//     const std::string db_serial(eeprom_map["serial"].begin(),
//     eeprom_map["serial"].end()); const std::string cal_serial =
//         db_serial + "#" + subtree->access<std::string>(fe_path / "name").get();
//     /* Now create a gain group for this. */
//     /* _?x_gain_groups won't work, because it doesn't group the */
//     /* gains the way we want them to be grouped. */
//     auto ggroup = uhd::gain_group::make();
//     ggroup->register_fcns(HW_GAIN_STAGE,
//         {[this, trx, chan_idx]() {
//              return trx == TX_DIRECTION ? get_tx_gain_range(chan_idx)
//                                         : get_rx_gain_range(chan_idx);
//          },
//             [this, trx, chan_idx]() {
//                 return trx == TX_DIRECTION ? get_tx_gain(ZBX_GAIN_STAGE_ALL, chan_idx)
//                                            : get_rx_gain(ZBX_GAIN_STAGE_ALL, chan_idx);
//             },
//             [this, trx, chan_idx](const double gain) {
//                 trx == TX_DIRECTION ? set_tx_gain(gain, chan_idx)
//                                     : set_rx_gain(gain, chan_idx);
//             }},
//         10 /* High priority */);
//     /* If we had a digital (baseband) gain, we would register it here,*/
//     /* so that the power manager would know to use it as a */
//     /* backup gain stage. */
//     /* Note that such a baseband gain might not be available */
//     /* on the LV version. */
//     return uhd::usrp::pwr_cal_mgr::make(
//         cal_serial,
//         "X400-CAL-" + DIR,
//         [this, trx, chan_idx]() {
//             return trx == TX_DIRECTION ? get_tx_frequency(chan_idx)
//                                        : get_rx_frequency(chan_idx);
//         },
//         [trx_str = (trx == TX_DIRECTION ? "tx" : "rx"),
//             fe_path,
//             subtree,
//             chan_str = std::to_string(chan_idx)]() -> std::string {
//             const std::string antenna = pwr_cal_mgr::sanitize_antenna_name(
//                 subtree->access<std::string>(fe_path / "antenna/value").get());
//             // The lookup key for X410 + ZBX shall start with x4xx_pwr_thinbx.
//             // Should we rev the ZBX in a way that would make generic cal data
//             // unsuitable between revs, then we need to check the rev (or PID)
//             // here and generate a different key prefix (e.g. x4xx_pwr_thinbxD_ or
//             // something like that).
//             return std::string("x4xx_pwr_thinbx_") + trx_str + "_" + chan_str + "_"
//                    + antenna;
//         },
//         ggroup);
// }

void thinbx_dboard_impl::_init_experts(expert_container::sptr expert,
    const uhd::direction_t trx,
    const size_t chan_idx,
    const fs_path fe_path)
{
    RFNOC_LOG_TRACE(fe_path + ", Creating experts...");

    // get_pwr_mgr(trx).insert(get_pwr_mgr(trx).begin() + chan_idx,
    //     _init_power_cal(subtree, trx, chan_idx, fe_path));

    // NOTE: THE ORDER OF EXPERT INITIALIZATION MATTERS
    //    After construction, all nodes (properties and experts) are marked dirty. Any
    //    subsequent calls to the container will trigger a resolve_all(), in which case
    //    the nodes are all resolved in REVERSE ORDER of construction, like a stack. With
    //    that in mind, we have to initialize the experts in line with that reverse order,
    //    because some experts rely on each other's construction/resolution to avoid
    //    errors (e.g., gain expert's dsa_cal is dependant on frequency be's coerced
    //    frequency, which is nan on dual_prop_node construction) After construction and
    //    subsequent resolution, the nodes will follow simple topological ruling as long
    //    as we only change one property at a time.

    expert_factory::add_worker_node<thinbx_freq_be_expert>(
        expert, expert->node_retriever(), fe_path);

    expert_factory::add_worker_node<thinbx_band_inversion_expert>(
        expert, expert->node_retriever(), fe_path, trx, chan_idx, _rpcc);


    // Initialize our RFDC LO Control Experts
    expert_factory::add_worker_node<thinbx_rfdc_freq_expert>(expert,
        expert->node_retriever(),
        fe_path,
        trx,
        chan_idx,
        _rpc_prefix,
        _db_idx,
        _mb_rpcc);

    expert_factory::add_worker_node<thinbx_freq_fe_expert>(
        expert, expert->node_retriever(), fe_path, trx, _rfdc_rate);
    RFNOC_LOG_TRACE(fe_path + ", Experts created");
}

void thinbx_dboard_impl::_init_frequency_prop_tree(uhd::property_tree::sptr subtree,
    expert_container::sptr expert,
    const fs_path fe_path)
{
    expert_factory::add_dual_prop_node<double>(
        expert, subtree, fe_path / "freq", THINBX_DEFAULT_FREQ, AUTO_RESOLVE_ON_WRITE);
    expert_factory::add_dual_prop_node<double>(
        expert, subtree, fe_path / "if_freq", 0.0, AUTO_RESOLVE_ON_WRITE);
    expert_factory::add_data_node<bool>(
        expert, fe_path / "band_inverted", false, AUTO_RESOLVE_ON_WRITE);

    subtree->create<double>(fe_path / "bandwidth" / "value")
        .set(THINBX_DEFAULT_BANDWIDTH)
        .set_coercer([](const double) { return THINBX_DEFAULT_BANDWIDTH; });
    subtree->create<meta_range_t>(fe_path / "bandwidth" / "range")
        .set({THINBX_DEFAULT_BANDWIDTH, THINBX_DEFAULT_BANDWIDTH})
        .set_coercer([](const meta_range_t&) {
            return meta_range_t(THINBX_DEFAULT_BANDWIDTH, THINBX_DEFAULT_BANDWIDTH);
        });
    subtree->create<meta_range_t>(fe_path / "freq" / "range")
        .set(THINBX_FREQ_RANGE)
        .add_coerced_subscriber([](const meta_range_t&) {
            throw uhd::runtime_error("Attempting to update freq range!");
        });
}

void thinbx_dboard_impl::_init_gain_prop_tree(
    uhd::property_tree::sptr subtree, const fs_path fe_path)
{
    // Create empty gain node
    subtree->create<meta_range_t>(fe_path / "gains");
}

void thinbx_dboard_impl::_init_antenna_prop_tree(uhd::property_tree::sptr subtree,
    expert_container::sptr expert,
    const uhd::direction_t trx,
    const size_t chan_idx,
    const fs_path fe_path)
{
    const std::string default_ant = trx == TX_DIRECTION ? DEFAULT_TX_ANTENNA
                                                        : DEFAULT_RX_ANTENNA;
    expert_factory::add_prop_node<std::string>(expert,
        subtree,
        fe_path / "antenna" / "value",
        default_ant,
        AUTO_RESOLVE_ON_WRITE);
    subtree->access<std::string>(fe_path / "antenna" / "value")
        .set_coercer([trx](const std::string& ant_name) {
            const auto ant_map = trx == TX_DIRECTION ? TX_ANTENNA_NAME_COMPAT_MAP
                                                     : RX_ANTENNA_NAME_COMPAT_MAP;
            return ant_map.count(ant_name) ? ant_map.at(ant_name) : ant_name;
        });
    subtree->create<std::vector<std::string>>(fe_path / "antenna" / "options")
        .set(trx == TX_DIRECTION ? get_tx_antennas(chan_idx) : get_rx_antennas(chan_idx))
        .add_coerced_subscriber([](const std::vector<std::string>&) {
            throw uhd::runtime_error("Attempting to update antenna options!");
        });
}

void thinbx_dboard_impl::_init_lo_prop_tree(uhd::property_tree::sptr subtree,
    expert_container::sptr expert,
    const uhd::direction_t trx,
    const size_t chan_idx,
    const fs_path fe_path)
{
    // The NCO gets a sub-node called 'reset'. It is read/write: Write will
    // perform a reset, and read will return the reset status. The latter is
    // also returned in the 'locked' sensor for the NCO, but the 'nco_locked'
    // sensor node is read-only, and returns a sensor_value_t (not a bool).
    // This node is primarily used for debugging, but can also serve as a manual
    // reset line for the NCOs.
    const auto nco = (trx == TX_DIRECTION)
                         ? (chan_idx == 0 ? rfdc_control::rfdc_type::TX0
                                          : rfdc_control::rfdc_type::TX1)
                         : (chan_idx == 0 ? rfdc_control::rfdc_type::RX0
                                          : rfdc_control::rfdc_type::RX1);
    subtree->create<bool>(fe_path / "los" / RFDC_NCO / "reset")
        .set_publisher([this]() { return this->_rfdcc->get_nco_reset_done(); })
        .add_coerced_subscriber([this, nco, chan_idx](const bool&) {
            RFNOC_LOG_TRACE("Resetting NCO " << size_t(nco) << ", chan " << chan_idx);
            this->_rfdcc->reset_ncos({nco}, this->_time_accessor(chan_idx));
        });

    expert_factory::add_dual_prop_node<double>(expert,
        subtree,
        fe_path / "los" / RFDC_NCO / "freq" / "value",
        // Initialize with current value
        _mb_rpcc->rfdc_get_nco_freq(trx == TX_DIRECTION ? "tx" : "rx", _db_idx, chan_idx),
        AUTO_RESOLVE_ON_WRITE);

    // LO lock sensor
    // We can't make this its own property value because it has to have access to two
    // containers (two instances of thinbx lo expert)
    subtree->create<sensor_value_t>(fe_path / "sensors" / "nco_locked")
        .add_coerced_subscriber([](const sensor_value_t&) {
            throw uhd::runtime_error("Attempting to write to sensor!");
        })
        .set_publisher([this]() {
            return sensor_value_t(
                RFDC_NCO, this->_rfdcc->get_nco_reset_done(), "locked", "unlocked");
        });
}
}}} // namespace uhd::usrp::thinbx
