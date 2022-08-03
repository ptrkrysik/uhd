#
# Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""
LMK04208 parent driver class
(based on LMK04832)
"""

import time

from usrp_mpm.chips.ic_reg_maps import lmk04208_regs_t
from usrp_mpm.mpmlog import get_logger


class LMK04208:
    """
    Generic driver class for LMK04208 access.
    """

    def __init__(self, regs_iface, parent_log=None):
        self.log = \
            parent_log.getChild("LMK04208") if parent_log is not None \
            else get_logger("LMK04208")
        self.regs_iface = regs_iface
        assert hasattr(self.regs_iface, 'peek32')
        assert hasattr(self.regs_iface, 'poke32')
        self._poke32 = regs_iface.poke32
        self._peek32 = regs_iface.peek32
        self.lmk04208_regs = lmk04208_regs_t()

    def pokes32(self, addr_vals):
        """
        Apply a series of pokes.
        pokes32([(0,1),(0,2)]) is the same as calling poke32(0,1), poke32(0,2).
        """
        for addr, val in addr_vals:
            self.poke32(addr, val)

    def peek32(self, addr):
        """
        Reads value of a register from addr
        """
        # Select addr of the register
        self.lmk04208_regs.READBACK_ADDR = addr
        self.lmk04208_regs.READBACK_LE = self.lmk04208_regs.READBACK_LE_t.READBACK_LE_LE_LOW
        # Set oldest bit to run univeral 32 bit tranfser
        # instead of following X410 CPLD's specific protocol
        sel_reg_addr = self.lmk04208_regs.READBACK_ADDR_addr| 0x8000000000000000
        self.poke32(sel_reg_addr, self.lmk04208_regs.get_reg(sel_reg_addr))
        #read selected register
        return self._peek32(sel_reg_addr)

    def poke32(self, addr, data):
        """
        Wrapper adding flag to run univeral 32 bit tranfser
        instead of following X410 CPLD's specific protocol
        """
        addr_and_flag = addr | 0x8000000000000000
        self._poke32(addr_and_flag, data)

    def _set_holdover_mux(
            self,
            mux_state=lmk04208_regs_t.HOLDOVER_MUX_t.HOLDOVER_MUX_UWIRE_RB.value
    ):
        """
        Sets function of HOLDOVER_LE line by changing state internal mux
        """
        self.lmk04208_regs.HOLDOVER_MUX = lmk04208_regs_t.HOLDOVER_MUX_t(mux_state)
        self.lmk04208_regs.HOLDOVER_TYPE = \
            lmk04208_regs_t.HOLDOVER_TYPE_t.HOLDOVER_TYPE_OUT_PUSH_PULL
        addr = self.lmk04208_regs.HOLDOVER_MUX_addr
        self.poke32(addr,
                    self.lmk04208_regs.get_reg(addr))

    def check_plls_locked(self, pll='BOTH'):
        """
        Returns True if the specified PLLs are locked, False otherwise.
        """
        assert pll in ('BOTH', 'PLL1', 'PLL2'), 'Invalid PLL specified'
        result = True

        if pll in ('PLL1'):
            self._set_holdover_mux(lmk04208_regs_t.HOLDOVER_MUX_t.HOLDOVER_MUX_PLL1_DLD.value)
            result = (self.peek32(self.lmk04208_regs.READBACK_ADDR_addr) == 0xffffffff)

        if pll in ('PLL2'):
            self._set_holdover_mux(lmk04208_regs_t.HOLDOVER_MUX_t.HOLDOVER_MUX_PLL2_DLD.value)
            result = (self.peek32(self.lmk04208_regs.READBACK_ADDR_addr) == 0xffffffff)

        if pll in ('BOTH'):
            self._set_holdover_mux(lmk04208_regs_t.HOLDOVER_MUX_t.HOLDOVER_MUX_BOTH.value)
            result = (self.peek32(self.lmk04208_regs.READBACK_ADDR_addr) == 0xffffffff)

        #set holdover_mux to default as spi output
        self._set_holdover_mux()

        return result

    def soft_reset(self, value=True):
        """
        Performs a soft reset of the LMK04208 by setting or unsetting the reset register.
        """
        self.lmk04208_regs.RESET = lmk04208_regs_t.RESET_t(value)
        reset_addr = self.lmk04208_regs.RESET_addr
        self.poke32(reset_addr, self.lmk04208_regs.get_reg(reset_addr))
