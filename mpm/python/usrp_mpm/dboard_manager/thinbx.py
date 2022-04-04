#
# Copyright 2019-2020 Ettus Research, a National Instruments Brand
# Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""
ThinBX dboard implementation module
ThinBX is a ZBX with only RFDC left. This is a board meant for RFSoC based
boards that don't have ZBX dboard. Currently it is implemented by copying ZBX
code and removing all unneeded stuff.
"""

import time
from usrp_mpm.dboard_manager import DboardManagerBase
from usrp_mpm.mpmlog import get_logger

###############################################################################
# Main dboard control class
###############################################################################
class ThinBX(DboardManagerBase):
    """
    Holds all dboard specific information and methods of the ThinBX dboard
    """
    #########################################################################
    # Overridables
    #
    # See DboardManagerBase for documentation on these fields
    #########################################################################
    pids = [0x4012]
    ### End of overridables #################################################

    #########################################################################
    # MPM Initialization
    #########################################################################
    def __init__(self, slot_idx, **kwargs):
        DboardManagerBase.__init__(self, slot_idx, **kwargs)
        self.log = get_logger("ThinBX-{}".format(slot_idx))
        self.log.trace("Initializing ThinBX daughterboard, slot index %d",
                       self.slot_idx)

        # Interface with MB HW
        if 'db_iface' not in kwargs:
            self.log.error("Required DB Iface was not provided!")
            raise RuntimeError("Required DB Iface was not provided!")
        self.db_iface = kwargs['db_iface']

        # self._enable_base_power()
        # for trx in ['rx', 'tx']:
        #     for channel in range(0,2):
        #         self.enable_iq_swap(False, trx, channel)

    #########################################################################
    # UHD (De-)Initialization
    #########################################################################
    def init(self, args):
        """
        Execute necessary init dance to bring up dboard. This happens when a UHD
        session starts.
        """
        self.log.debug("init() called with args `{}'".format(
            ",".join(['{}={}'.format(x, args[x]) for x in args])
        ))
        return True

    def deinit(self):
        """
        De-initialize after UHD session completes
        """
        self.log.debug("deiniti() called")

    def tear_down(self):
        self.db_iface.tear_down()

    #########################################################################
    # API calls needed by the ThinBX_dboard driver
    #########################################################################
    def enable_iq_swap(self, enable, trx, channel):
        """
        Turn on IQ swapping in the RFDC
        """
        self.db_iface.enable_iq_swap(enable, trx, channel)

    def get_dboard_sample_rate(self):
        """
        Return the RFDC rate. This is usually a big number in the 3 GHz range.
        """
        return self.db_iface.get_sample_rate()

    def get_dboard_prc_rate(self):
        """
        Return the PRC rate. The CPLD and LOs are clocked with this.
        """
        return self.db_iface.get_prc_rate()
