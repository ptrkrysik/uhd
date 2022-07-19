#
# Copyright 2021 Ettus Research, a National Instruments Brand
# Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#
# Description:
#   QSFP28 Port 0 (Lane 2) pin constraints for X410.
#

###############################################################################
# Pin constraints for the MGTs (QSFP28 ports)
###############################################################################

# Bank 128 (Quad X0Y1, Lanes X0Y4-X0Y7)
# Lane 2 (X0Y6)

set_property PACKAGE_PIN U38  [get_ports {QSFP0_2_RX_P}]
set_property PACKAGE_PIN U39  [get_ports {QSFP0_2_RX_N}]

set_property PACKAGE_PIN T35  [get_ports {QSFP0_2_TX_P}]
set_property PACKAGE_PIN T36  [get_ports {QSFP0_2_TX_N}]
