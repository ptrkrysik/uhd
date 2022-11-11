#
# Copyright 2019 Ettus Research, a National Instruments Brand
# Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""
LMK04208 driver for use with X4xx
"""

from time import sleep

from usrp_mpm.chips import LMK04208


class LMK04208X4xx(LMK04208):
    """
    X4xx-specific subclass of the Reference Clock PLL LMK04208 controls.
    """
    def __init__(self, pll_regs_iface, prepare_for_read_cb=None, log=None):
        LMK04208.__init__(self, pll_regs_iface, log)

        self._prepare_for_read_cb = prepare_for_read_cb

    def init(self):
        """
        Perform a soft reset and verify chip ID
        """
        # Trigger soft reset
        self.reset(True)
        self.reset(False)

    def peek32(self, addr):
        """
        Reads value of a register from addr
        """
        if self._prepare_for_read_cb is not None:
            self._prepare_for_read_cb()
        return LMK04208.peek32(self, addr)

    def reset(self, value=True):
        """
        Perform a hard reset from the GPIO pins or a soft reset from the LMK register
        """
        self.soft_reset(value)

    def get_status(self):
        """
        Returns PLL lock for both PLL1 and PLL2
        """
        if self._prepare_for_read_cb is not None:
            self._prepare_for_read_cb()
        return self.check_plls_locked()

    def config(self):#, ref_select=2, brc_rate=25e6, usr_clk_rate=156.25e6, brc_select='PLL'):
        """
        Configures LMK04208 clock generator
        """

        # Configuration for 
        # input frequency: 12.8e6
        # lmx clock ('master clock'): 122.88e6
        # pll reference clock: 61.44e6
        # sysref clock: ...
        registers = [ 0x00144B00, 0x00144B01, 0x00140642, 0xC0140303,
                      0x40140024, 0x00144B05, 0x01100006, 0x01100007,
                      0x06010008, 0x55555549, 0x9102410A, 0x0401100B,
                      0x1B0C006C, 0x3F02882D, 0x0200000E, 0x8000800F,
                      0xC1550410, 0x00000058, 0x02C9C419, 0x8FA8001A,
                      0x10001E1B, 0x0021201C, 0x0180033D, 0x0200033E,
                      0x0002001F ]

        addr_vals = [ (reg & 0x1f, reg >> 5) for reg in registers]

        self.pokes32(addr_vals)

        #set holdover_mux to default as spi output
        self._set_holdover_mux()
