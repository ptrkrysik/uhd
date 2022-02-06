#
# Copyright 2021 Ettus Research, a National Instruments Brand
# Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#
# Description:
#   Common pin constraints for X410.
#

###############################################################################
# Pin constraints for the MGTs reference clocks
###############################################################################

set_property PACKAGE_PIN U33 [get_ports {MGT_REFCLK_LMK3_P}] ; #zamienione lmk0 i lmk3
set_property PACKAGE_PIN U34 [get_ports {MGT_REFCLK_LMK3_N}]

set_property PACKAGE_PIN T31 [get_ports {MGT_REFCLK_LMK1_P}]
set_property PACKAGE_PIN T32 [get_ports {MGT_REFCLK_LMK1_N}]

set_property PACKAGE_PIN W33 [get_ports {MGT_REFCLK_LMK2_P}]
set_property PACKAGE_PIN W34 [get_ports {MGT_REFCLK_LMK2_N}]

set_property PACKAGE_PIN V31 [get_ports {MGT_REFCLK_LMK0_P}] ; #ten zdaje się jest dobrze podłączony na zcu111
set_property PACKAGE_PIN V32 [get_ports {MGT_REFCLK_LMK0_N}]


###############################################################################
# Common pin constraints for the QSFP28 ports
###############################################################################

# set_property PACKAGE_PIN AJ15 [get_ports {QSFP0_MODPRS_n}] ; #GPIO_DIP_SW - tego nie ma gdzie podlaczyc - ustawiam na stale w kodzie
# set_property PACKAGE_PIN AH16 [get_ports {QSFP0_RESET_n}] ; #GPIO_DIP_SW3
# set_property PACKAGE_PIN AH15 [get_ports {QSFP0_LPMODE_n}] ; #GPIO_DIP_SW2

# set_property PACKAGE_PIN AL11 [get_ports {QSFP1_MODPRS_n}] ; #NC !! co z nim zrobić?
# set_property PACKAGE_PIN AR8  [get_ports {QSFP1_RESET_n}] ; #FMCP_HSPC_LA01_CC_N
# set_property PACKAGE_PIN AT9  [get_ports {QSFP1_LPMODE_n}] ; #NC

# set_property IOSTANDARD LVCMOS12 [get_ports {QSFP*_MODPRS_n QSFP*_RESET_n QSFP*_LPMODE_n}]
# set_property SLEW       SLOW     [get_ports {QSFP*_RESET_n QSFP*_LPMODE_n}]


###############################################################################
# eCPRI future clocks
###############################################################################

# Input
# set_property PACKAGE_PIN AK17 [get_ports {FPGA_AUX_REF}] ; #SYSREF_FPGA_C_P
# set_property IOSTANDARD LVCMOS12 [get_ports {FPGA_AUX_REF}]

# Output
# set_property PACKAGE_PIN AG17 [get_ports {FABRIC_CLK_OUT_P}] ; #GPIO_DIP_SW5
# set_property PACKAGE_PIN AH17 [get_ports {FABRIC_CLK_OUT_N}] ; #GPIO_DIP_SW4
# set_property IOSTANDARD DIFF_SSTL12 [get_ports {FABRIC_CLK_OUT_*}] 

# GTY_RCV_CLK_P is defined in qsfp_port1


###############################################################################
# Pin constraints for the other PL pins (1.8 V)
###############################################################################

# set_property PACKAGE_PIN A9  [get_ports {DB1_GPIO[0]}] ; #DACIO_00
# set_property PACKAGE_PIN A10 [get_ports {DB1_GPIO[1]}] ; #DACIO_01
# set_property PACKAGE_PIN A6  [get_ports {DB1_GPIO[2]}] ; #DACIO_02
# set_property PACKAGE_PIN A7  [get_ports {DB1_GPIO[3]}] ; #DACIO_03
# set_property PACKAGE_PIN A5  [get_ports {DB1_GPIO[4]}] ; #DACIO_04
# set_property PACKAGE_PIN B5  [get_ports {DB1_GPIO[5]}] ; #DACIO_05
# set_property PACKAGE_PIN C5  [get_ports {DB1_GPIO[6]}] ; #DACIO_06
# set_property PACKAGE_PIN C6  [get_ports {DB1_GPIO[7]}] ; #DACIO_07
# set_property PACKAGE_PIN B9  [get_ports {DB1_GPIO[8]}] ; #DACIO_08
# set_property PACKAGE_PIN B10 [get_ports {DB1_GPIO[9]}] ; #DACIO_09
# set_property PACKAGE_PIN B7  [get_ports {DB1_GPIO[10]}] ; #DACIO_10
# set_property PACKAGE_PIN B8  [get_ports {DB1_GPIO[11]}] ; #DACIO_11
# set_property PACKAGE_PIN D8  [get_ports {DB1_GPIO[12]}] ; #DACIO_12
# set_property PACKAGE_PIN D9  [get_ports {DB1_GPIO[13]}] ; #DACIO_13
# set_property PACKAGE_PIN C7  [get_ports {DB1_GPIO[14]}] ; #DACIO_14
# set_property PACKAGE_PIN C8  [get_ports {DB1_GPIO[15]}] ; #DACIO_15
# set_property PACKAGE_PIN C10 [get_ports {DB1_GPIO[16]}] ; #DACIO_16
# set_property PACKAGE_PIN D10 [get_ports {DB1_GPIO[17]}] ; #DACIO_17
# set_property PACKAGE_PIN D6  [get_ports {DB1_GPIO[18]}] ; #DACIO_18
# set_property PACKAGE_PIN C17 [get_ports {DB1_GPIO[19]}] ; #PMOD0_0_LS
# set_property IOSTANDARD LVCMOS12 [get_ports {DB1_GPIO[*]}]
# set_property PULLDOWN   TRUE     [get_ports {DB1_GPIO[*]}]
# set_property IOB        TRUE     [get_ports {DB1_GPIO[*]}]

# set_property PACKAGE_PIN E7  [get_ports {DB1_SYNTH_SYNC}] ; #DACIO_19
# set_property IOSTANDARD LVCMOS12 [get_ports {DB1_SYNTH_SYNC}]

# set_property PACKAGE_PIN AP5 [get_ports {DB0_GPIO[0]}] ; #ADCIO_00
# set_property PACKAGE_PIN AP6 [get_ports {DB0_GPIO[1]}] ; #ADCIO_01
# set_property PACKAGE_PIN AR6 [get_ports {DB0_GPIO[2]}] ; #ADCIO_02
# set_property PACKAGE_PIN AR7 [get_ports {DB0_GPIO[3]}] ; #ADCIO_03
# set_property PACKAGE_PIN AV7 [get_ports {DB0_GPIO[4]}] ; #ADCIO_04
# set_property PACKAGE_PIN AU7 [get_ports {DB0_GPIO[5]}] ; #ADCIO_05
# set_property PACKAGE_PIN AV8 [get_ports {DB0_GPIO[6]}] ; #ADCIO_06
# set_property PACKAGE_PIN AU8 [get_ports {DB0_GPIO[7]}] ; #ADCIO_07
# set_property PACKAGE_PIN AT6 [get_ports {DB0_GPIO[8]}] ; #ADCIO_08
# set_property PACKAGE_PIN AT7 [get_ports {DB0_GPIO[9]}] ; #ADCIO_09
# set_property PACKAGE_PIN AU5 [get_ports {DB0_GPIO[10]}] ; #ADCIO_10
# set_property PACKAGE_PIN AT5 [get_ports {DB0_GPIO[11]}] ; #ADCIO_11
# set_property PACKAGE_PIN AU3 [get_ports {DB0_GPIO[12]}] ; #ADCIO_12
# set_property PACKAGE_PIN AU4 [get_ports {DB0_GPIO[13]}] ; #ADCIO_13
# set_property PACKAGE_PIN AV5 [get_ports {DB0_GPIO[14]}] ; #ADCIO_14
# set_property PACKAGE_PIN AV6 [get_ports {DB0_GPIO[15]}] ; #ADCIO_15
# set_property PACKAGE_PIN AU1 [get_ports {DB0_GPIO[16]}] ; #ADCIO_16
# set_property PACKAGE_PIN AU2 [get_ports {DB0_GPIO[17]}] ; #ADCIO_17
# set_property PACKAGE_PIN AV2 [get_ports {DB0_GPIO[18]}] ; #ADCIO_18
# set_property PACKAGE_PIN M18 [get_ports {DB0_GPIO[19]}] ; #PMOD0_1_LS
# set_property IOSTANDARD LVCMOS12 [get_ports {DB0_GPIO[*]}]
# set_property PULLDOWN   TRUE     [get_ports {DB0_GPIO[*]}]
# set_property IOB        TRUE     [get_ports {DB0_GPIO[*]}]

# set_property PACKAGE_PIN AV3 [get_ports {DB0_SYNTH_SYNC}] ; #ADCIO_19
# #set_property IOSTANDARD LVCMOS18 [get_ports {DB0_SYNTH_SYNC}]
# set_property IOSTANDARD LVCMOS12 [get_ports {DB0_SYNTH_SYNC}] ; #zmiana napiecia by pozbyc sie errora

# set_property PACKAGE_PIN H17   [get_ports {LMK_SYNC}] ; #PMOD0_3_LS - already used for BASE_REFCLK
# set_property IOB         TRUE [get_ports {LMK_SYNC}]
# set_property IOSTANDARD LVCMOS12 [get_ports {LMK_SYNC}]

# set_property PACKAGE_PIN J16 [get_ports {TRIG_IO}] ; #PMOD0_4_LS
set_property PACKAGE_PIN AP14  [get_ports {PPS_IN}] ; #AMS_FPGA_REF_CLK
# set_property PACKAGE_PIN AR7 [get_ports {PL_CPLD_SCLK}] ; #ADCIO_03
# set_property PACKAGE_PIN AR6 [get_ports {PL_CPLD_MOSI}] ; #ADCIO_02
# set_property PACKAGE_PIN AP6 [get_ports {PL_CPLD_MISO}] ; #ADCIO_01
#set_property IOSTANDARD LVCMOS18 [get_ports {LMK_SYNC TRIG_IO PPS_IN PL_CPLD_SCLK PL_CPLD_MOSI PL_CPLD_MISO}]
# set_property IOSTANDARD LVCMOS12 [get_ports {LMK_SYNC TRIG_IO PPS_IN PL_CPLD_SCLK PL_CPLD_MOSI PL_CPLD_MISO}]
# set_property DRIVE      16     [get_ports {PL_CPLD_SCLK}]

set_property IOSTANDARD LVCMOS18 [get_ports {PPS_IN}]

###############################################################################
# Pin constraints for the other PL pins (1.2 V)
###############################################################################

set_property PACKAGE_PIN AL16 [get_ports {PLL_REFCLK_FPGA_P}] ; #FPGA_REFCLK_OUT_C_P
set_property PACKAGE_PIN AL15 [get_ports {PLL_REFCLK_FPGA_N}] ; #FPGA_REFCLK_OUT_C_N
set_property IOSTANDARD DIFF_SSTL12 [get_ports {PLL_REFCLK_FPGA_*}]

set_property PACKAGE_PIN H17  [get_ports {BASE_REFCLK_FPGA_P}] ; #PMOD0_3_LS
set_property PACKAGE_PIN H16  [get_ports {BASE_REFCLK_FPGA_N}] ; #PMOD0_2_LS
set_property IOSTANDARD DIFF_SSTL12 [get_ports {BASE_REFCLK_FPGA_*}]

set_property PACKAGE_PIN AK17 [get_ports {SYSREF_FABRIC_P}] ; #SYSREF_FPGA_C_P
set_property PACKAGE_PIN AK16 [get_ports {SYSREF_FABRIC_N}] ; #SYSREF_FPGA_C_N
set_property IOSTANDARD DIFF_SSTL12 [get_ports {SYSREF_FABRIC_*}]

# set_property PACKAGE_PIN K16  [get_ports {DIOA_FPGA[0]}] ; #PMOD0_5_LS
# set_property PACKAGE_PIN H15  [get_ports {DIOA_FPGA[1]}] ; #PMOD0_6_LS
# set_property PACKAGE_PIN J15  [get_ports {DIOA_FPGA[2]}] ; #PMOD0_7_LS
# set_property PACKAGE_PIN E8   [get_ports {DIOA_FPGA[3]}] ; #GPIO_SW_S
# set_property PACKAGE_PIN L14  [get_ports {DIOA_FPGA[4]}] ; #PMOD1_0_LS
# set_property PACKAGE_PIN L15  [get_ports {DIOA_FPGA[5]}] ; #PMOD1_1_LS
# set_property PACKAGE_PIN M13  [get_ports {DIOA_FPGA[6]}] ; #PMOD1_2_LS
# set_property PACKAGE_PIN N13  [get_ports {DIOA_FPGA[7]}] ; #PMOD1_3_LS
# set_property PACKAGE_PIN M15  [get_ports {DIOA_FPGA[8]}] ; #PMOD1_4_LS
# set_property PACKAGE_PIN N15  [get_ports {DIOA_FPGA[9]}] ; #PMOD1_5_LS
# set_property PACKAGE_PIN M14  [get_ports {DIOA_FPGA[10]}] ; #PMOD1_6_LS
# set_property PACKAGE_PIN N14  [get_ports {DIOA_FPGA[11]}] ; #PMOD1_7_LS
# set_property PACKAGE_PIN AF16 [get_ports {DIOB_FPGA[0]}] ; #GPIO_DIP_SW0
# set_property PACKAGE_PIN AF17 [get_ports {DIOB_FPGA[1]}] ; #GPIO_DIP_SW1
# set_property PACKAGE_PIN AH15 [get_ports {DIOB_FPGA[2]}] ; #GPIO_DIP_SW2
# set_property PACKAGE_PIN AH16 [get_ports {DIOB_FPGA[3]}] ; #GPIO_DIP_SW3
# set_property PACKAGE_PIN AH17 [get_ports {DIOB_FPGA[4]}] ; #GPIO_DIP_SW4
# set_property PACKAGE_PIN AG17 [get_ports {DIOB_FPGA[5]}] ; #GPIO_DIP_SW5
# set_property PACKAGE_PIN AJ15 [get_ports {DIOB_FPGA[6]}] ; #GPIO_DIP_SW6
# set_property PACKAGE_PIN AJ16 [get_ports {DIOB_FPGA[7]}] ; #GPIO_DIP_SW7
# set_property PACKAGE_PIN AW3  [get_ports {DIOB_FPGA[8]}] ; #GPIO_SW_N
# set_property PACKAGE_PIN AW4  [get_ports {DIOB_FPGA[9]}] ; #GPIO_SW_E
# set_property PACKAGE_PIN AW5  [get_ports {DIOB_FPGA[10]}] ; #GPIO_SW_C
# set_property PACKAGE_PIN AW6  [get_ports {DIOB_FPGA[11]}] ; #GPIO_SW_W

# set_property IOSTANDARD LVCMOS12 [get_ports {DIO*_FPGA[*]}]
# set_property PULLDOWN   true     [get_ports {DIO*_FPGA[*]}]

set_property PACKAGE_PIN AR13 [get_ports {PPS_LED}] ; #GPIO_LED_0_LS
set_property IOSTANDARD LVCMOS18 [get_ports {PPS_LED}]

# set_property PACKAGE_PIN B23  [get_ports {PL_CPLD_JTAGEN}] ; #NC
# set_property PACKAGE_PIN N21  [get_ports {PL_CPLD_CS0_n}] ; #NC
# set_property PACKAGE_PIN J24  [get_ports {PL_CPLD_CS1_n}] ; #NC
# set_property PACKAGE_PIN AN12 [get_ports {CPLD_JTAG_OE_n}] ; #FMCP_HSPC_LA10_N
# set_property IOSTANDARD LVCMOS12 [get_ports {PL_CPLD_JTAGEN PL_CPLD_CS*_n CPLD_JTAG_OE_n}]


###############################################################################
# Unused pins
###############################################################################

# set_property PACKAGE_PIN D19  [get_ports {PL_CPLD_IRQ}] ; #PL_DDR4_PARITY
# set_property PACKAGE_PIN AF15 [get_ports {FPGA_TEST}] ; #CPU_RESET
# set_property IOSTANDARD LVCMOS12 [get_ports {FPGA_TEST PL_CPLD_IRQ}]

# set_property PACKAGE_PIN AK16 [get_ports {TDC_SPARE_0}] ; #SYSREF_FPGA_C_N
# set_property PACKAGE_PIN AJ16 [get_ports {TDC_SPARE_1}] ; #GPIO_DIP_SW7
# set_property IOSTANDARD LVCMOS12 [get_ports {TDC_SPARE_*}]

# Testowe LEDy
# set_property PACKAGE_PIN AR13     [get_ports { led_pll }] ; #GPIO_LED_0_LS
# set_property IOSTANDARD  LVCMOS18 [get_ports { led_pll }] ;
# set_property PACKAGE_PIN AP13     [get_ports { led_sysref }] ; #GPIO_LED_1_LS
# set_property IOSTANDARD  LVCMOS18 [get_ports { led_sysref }] ;

# set_property PACKAGE_PIN AR16     [get_ports { gpio_leds_o[0] }] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports { gpio_leds_o[0] }] ;
# set_property PACKAGE_PIN AP16     [get_ports { gpio_leds_o[1] }] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports { gpio_leds_o[1] }] ;
# set_property PACKAGE_PIN AP15     [get_ports { gpio_leds_o[2] }] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports { gpio_leds_o[2] }] ;
# set_property PACKAGE_PIN AN16     [get_ports { gpio_leds_o[3] }] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports { gpio_leds_o[3] }] ;

###############################################################################
# SFP Enable pins
###############################################################################

set_property PACKAGE_PIN G12      [get_ports { QSFP0_TX_ENABLE[0] }] ;
set_property IOSTANDARD  LVCMOS12 [get_ports { QSFP0_TX_ENABLE[0] }] ;
set_property PACKAGE_PIN G10      [get_ports { QSFP0_TX_ENABLE[1] }] ;
set_property IOSTANDARD  LVCMOS12 [get_ports { QSFP0_TX_ENABLE[1] }] ;
set_property PACKAGE_PIN K12      [get_ports { QSFP0_TX_ENABLE[2] }] ;
set_property IOSTANDARD  LVCMOS12 [get_ports { QSFP0_TX_ENABLE[2] }] ;
set_property PACKAGE_PIN J7       [get_ports { QSFP0_TX_ENABLE[3] }] ;
set_property IOSTANDARD  LVCMOS12 [get_ports { QSFP0_TX_ENABLE[3] }] ;
