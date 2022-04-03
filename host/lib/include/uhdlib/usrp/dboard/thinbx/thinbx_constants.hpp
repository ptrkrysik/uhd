//
// Copyright 2019 Ettus Research, a National Instruments Brand
// Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later
//
#pragma once

#include <uhd/exception.hpp>
#include <uhd/types/ranges.hpp>
#include <unordered_map>
#include <array>
#include <cstddef>
#include <list>
#include <map>
#include <string>
#include <vector>

namespace uhd { namespace usrp { namespace thinbx {

/******************************************************************************
 * Important: When changing values here, check if that also requires updating
 * the manual (host/docs/thinbx.dox).
 *****************************************************************************/

// The ZBX has a non-configurable analog bandwidth of 400 MHz. At lower
// frequency, the usable bandwidth may be smaller though. For those smaller
// bandwidths, see the tune maps.
// TODO PK: as thinbx's bandwidth depends on master-clock, compute this value
// instead of showing a constant
static constexpr double THINBX_DEFAULT_BANDWIDTH = 400e6; // Hz

static constexpr double THINBX_MIN_FREQ = 0; // Hz
static constexpr double THINBX_MAX_FREQ = 3e9; // TODO PK: compute this value based
                                               // on master-clock instead of
                                               // showing a constant
// constant
static constexpr double THINBX_DEFAULT_FREQ = 0; // Hz
static const uhd::freq_range_t THINBX_FREQ_RANGE(THINBX_MIN_FREQ, THINBX_MAX_FREQ);

// constexpr char HW_GAIN_STAGE[] = "hw";

static constexpr double THINBX_MIN_GAIN     = 0;
static constexpr double THINBX_MAX_GAIN     = 0;
static constexpr double THINBX_GAIN_STEP    = 1;
static constexpr double THINBX_DEFAULT_GAIN = THINBX_MIN_GAIN;
static const uhd::gain_range_t THINBX_GAIN_RANGE(
    THINBX_MIN_GAIN, THINBX_MAX_GAIN, THINBX_GAIN_STEP);

// static constexpr char ZBX_GAIN_PROFILE_DEFAULT[]        = "default";
// static constexpr char ZBX_GAIN_PROFILE_MANUAL[]         = "manual";
// static constexpr char ZBX_GAIN_PROFILE_CPLD[]           = "table";
// static constexpr char ZBX_GAIN_PROFILE_CPLD_NOATR[]     = "table_noatr";
// static const std::vector<std::string> ZBX_GAIN_PROFILES = {ZBX_GAIN_PROFILE_DEFAULT,
//     ZBX_GAIN_PROFILE_MANUAL,
//     ZBX_GAIN_PROFILE_CPLD,
//     ZBX_GAIN_PROFILE_CPLD_NOATR};

// Maximum attenuation of the TX DSAs
// static constexpr uint8_t ZBX_TX_DSA_MAX_ATT = 31;
// Maximum attenuation of the RX DSAs
// static constexpr uint8_t ZBX_RX_DSA_MAX_ATT = 15;

// static constexpr char ZBX_GAIN_STAGE_DSA1[]  = "DSA1";
// static constexpr char ZBX_GAIN_STAGE_DSA2[]  = "DSA2";
// static constexpr char ZBX_GAIN_STAGE_DSA3A[] = "DSA3A";
// static constexpr char ZBX_GAIN_STAGE_DSA3B[] = "DSA3B";
// static constexpr char ZBX_GAIN_STAGE_AMP[]   = "AMP";
static constexpr char THINBX_GAIN_STAGE_ALL[] = "all";
// // Not technically a gain stage, but we'll keep it
// static constexpr char ZBX_GAIN_STAGE_TABLE[] = "TABLE";

// static const std::vector<std::string> ZBX_RX_GAIN_STAGES = {
//     ZBX_GAIN_STAGE_DSA1, ZBX_GAIN_STAGE_DSA2, ZBX_GAIN_STAGE_DSA3A,
//     ZBX_GAIN_STAGE_DSA3B};

// static const std::vector<std::string> ZBX_TX_GAIN_STAGES = {
//     ZBX_GAIN_STAGE_DSA1, ZBX_GAIN_STAGE_DSA2, ZBX_GAIN_STAGE_AMP};

/*** Antenna-related constants ***********************************************/
// TX and RX SMA connectors on the front panel
constexpr char ANTENNA_TXRX[] = "TX";
constexpr char ANTENNA_RX[]   = "RX";
// Default antennas (which are selected at init)
constexpr auto DEFAULT_TX_ANTENNA = ANTENNA_TXRX;
constexpr auto DEFAULT_RX_ANTENNA = ANTENNA_RX;
// Helper lists
static const std::vector<std::string> RX_ANTENNAS = {ANTENNA_RX};
static const std::vector<std::string> TX_ANTENNAS = {ANTENNA_TXRX};
// ThinBX enables changing the antenna names around from traditional ones to anything.
static const std::unordered_map<std::string, std::string> TX_ANTENNA_NAME_COMPAT_MAP{
    {"TX/RX", ANTENNA_TXRX}};
static const std::unordered_map<std::string, std::string> RX_ANTENNA_NAME_COMPAT_MAP{
    {"RX2", ANTENNA_RX}};

/*** LO-related constants ****************************************************/
static constexpr char RFDC_NCO[] = "rfdc";

static const std::vector<std::string> THINBX_LOS = {RFDC_NCO};

static constexpr size_t THINBX_NUM_CHANS = 2;
static constexpr std::array<size_t, 2> THINBX_CHANNELS{0, 1};

// // These are addresses for the various table-based registers
// static constexpr uint32_t ATR_ADDR_0X = 0;
// static constexpr uint32_t ATR_ADDR_RX = 1;
// static constexpr uint32_t ATR_ADDR_TX = 2;
// static constexpr uint32_t ATR_ADDR_XX = 3; // Full-duplex
// // Helper for looping
// static constexpr std::array<uint32_t, 4> ATR_ADDRS{0, 1, 2, 3};

}}} // namespace uhd::usrp::thinbx
