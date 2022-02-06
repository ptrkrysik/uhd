#
# Copyright 2021 Ettus Research, a National Instruments Brand
# Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#
# Description:
#   DRAM pin constraints for X411 (ZCU111).
#

###############################################################################
# Pin constraints for DRAM controller 0
###############################################################################

set_property PACKAGE_PIN A19 [get_ports DRAM0_ACT_n] ; # set_property PACKAGE_PIN A19      [get_ports "PL_DDR4_ACT_B"] ;# Bank  69 VCCO - VCC1V2   - IO_L20N_T3L_N3_AD1N_69
set_property PACKAGE_PIN D18 [get_ports {DRAM0_ADDR[0]}] ; # set_property PACKAGE_PIN D18      [get_ports "PL_DDR4_A0"] ;# Bank  69 VCCO - VCC1V2   - IO_L19P_T3L_N0_DBC_AD9P_69
set_property PACKAGE_PIN G18 [get_ports {DRAM0_ADDR[10]}] ; # set_property PACKAGE_PIN G18      [get_ports "PL_DDR4_A10"] ;# Bank  69 VCCO - VCC1V2   - IO_L14N_T2L_N3_GC_69
set_property PACKAGE_PIN H18 [get_ports {DRAM0_ADDR[11]}] ; # set_property PACKAGE_PIN H18      [get_ports "PL_DDR4_A11"] ;# Bank  69 VCCO - VCC1V2   - IO_L14P_T2L_N2_GC_69
set_property PACKAGE_PIN K17 [get_ports {DRAM0_ADDR[12]}] ; # set_property PACKAGE_PIN K17      [get_ports "PL_DDR4_A12"] ;# Bank  69 VCCO - VCC1V2   - IO_L8N_T1L_N3_AD5N_69
set_property PACKAGE_PIN L17 [get_ports {DRAM0_ADDR[13]}] ; # set_property PACKAGE_PIN L17      [get_ports "PL_DDR4_A13"] ;# Bank  69 VCCO - VCC1V2   - IO_L8P_T1L_N2_AD5P_69
set_property PACKAGE_PIN B17 [get_ports {DRAM0_ADDR[14]}] ; # set_property PACKAGE_PIN B17      [get_ports "PL_DDR4_WE_B"] ;# Bank  69 VCCO - VCC1V2   - IO_L22N_T3U_N7_DBC_AD0N_69
set_property PACKAGE_PIN D15 [get_ports {DRAM0_ADDR[15]}] ; # set_property PACKAGE_PIN D15      [get_ports "PL_DDR4_CAS_B"] ;# Bank  69 VCCO - VCC1V2   - IO_L23N_T3U_N9_69
set_property PACKAGE_PIN C18 [get_ports {DRAM0_ADDR[16]}] ; # set_property PACKAGE_PIN C18      [get_ports "PL_DDR4_RAS_B"] ;# Bank  69 VCCO - VCC1V2   - IO_L19N_T3L_N1_DBC_AD9N_69
set_property PACKAGE_PIN E19 [get_ports {DRAM0_ADDR[1]}] ; # set_property PACKAGE_PIN E19      [get_ports "PL_DDR4_A1"] ;# Bank  69 VCCO - VCC1V2   - IO_T2U_N12_69
set_property PACKAGE_PIN E17 [get_ports {DRAM0_ADDR[2]}] ; # set_property PACKAGE_PIN E17      [get_ports "PL_DDR4_A2"] ;# Bank  69 VCCO - VCC1V2   - IO_L18N_T2U_N11_AD2N_69
set_property PACKAGE_PIN E18 [get_ports {DRAM0_ADDR[3]}] ; # set_property PACKAGE_PIN E18      [get_ports "PL_DDR4_A3"] ;# Bank  69 VCCO - VCC1V2   - IO_L18P_T2U_N10_AD2P_69
set_property PACKAGE_PIN E16 [get_ports {DRAM0_ADDR[4]}] ; # set_property PACKAGE_PIN E16      [get_ports "PL_DDR4_A4"] ;# Bank  69 VCCO - VCC1V2   - IO_L17N_T2U_N9_AD10N_69
set_property PACKAGE_PIN F16 [get_ports {DRAM0_ADDR[5]}] ; # set_property PACKAGE_PIN F16      [get_ports "PL_DDR4_A5"] ;# Bank  69 VCCO - VCC1V2   - IO_L17P_T2U_N8_AD10P_69
set_property PACKAGE_PIN F19 [get_ports {DRAM0_ADDR[6]}] ; # set_property PACKAGE_PIN F19      [get_ports "PL_DDR4_A6"] ;# Bank  69 VCCO - VCC1V2   - IO_L16N_T2U_N7_QBC_AD3N_69
set_property PACKAGE_PIN G19 [get_ports {DRAM0_ADDR[7]}] ; # set_property PACKAGE_PIN G19      [get_ports "PL_DDR4_A7"] ;# Bank  69 VCCO - VCC1V2   - IO_L16P_T2U_N6_QBC_AD3P_69
set_property PACKAGE_PIN F15 [get_ports {DRAM0_ADDR[8]}] ; # set_property PACKAGE_PIN F15      [get_ports "PL_DDR4_A8"] ;# Bank  69 VCCO - VCC1V2   - IO_L15N_T2L_N5_AD11N_69
set_property PACKAGE_PIN G15 [get_ports {DRAM0_ADDR[9]}] ; # set_property PACKAGE_PIN G15      [get_ports "PL_DDR4_A9"] ;# Bank  69 VCCO - VCC1V2   - IO_L15P_T2L_N4_AD11P_69
set_property PACKAGE_PIN K18 [get_ports {DRAM0_BA[0]}] ; # set_property PACKAGE_PIN K18      [get_ports "PL_DDR4_BA0"] ;# Bank  69 VCCO - VCC1V2   - IO_L10N_T1U_N7_QBC_AD4N_69
set_property PACKAGE_PIN K19 [get_ports {DRAM0_BA[1]}] ; # set_property PACKAGE_PIN K19      [get_ports "PL_DDR4_BA1"] ;# Bank  69 VCCO - VCC1V2   - IO_L10P_T1U_N6_QBC_AD4P_69
set_property PACKAGE_PIN C16 [get_ports {DRAM0_BG[0]}] ; # set_property PACKAGE_PIN C16      [get_ports "PL_DDR4_BG0"] ;# Bank  69 VCCO - VCC1V2   - IO_L21N_T3L_N5_AD8N_69
set_property PACKAGE_PIN G17 [get_ports {DRAM0_CLK_P[0]}] ; # set_property PACKAGE_PIN G17      [get_ports "PL_DDR4_CK0_T"] ;# Bank  69 VCCO - VCC1V2   - IO_L13P_T2L_N0_GC_QBC_69
set_property PACKAGE_PIN F17 [get_ports {DRAM0_CLK_N[0]}] ; # set_property PACKAGE_PIN F17      [get_ports "PL_DDR4_CK0_C"] ;# Bank  69 VCCO - VCC1V2   - IO_L13N_T2L_N1_GC_QBC_69
set_property PACKAGE_PIN A16 [get_ports {DRAM0_CKE[0]}] ; # set_property PACKAGE_PIN A16      [get_ports "PL_DDR4_CKE"] ;# Bank  69 VCCO - VCC1V2   - IO_L24N_T3U_N11_69
set_property PACKAGE_PIN D16 [get_ports {DRAM0_CS_n[0]}] ; # set_property PACKAGE_PIN D16      [get_ports "PL_DDR4_CS_B"] ;# Bank  69 VCCO - VCC1V2   - IO_L23P_T3U_N8_69
set_property PACKAGE_PIN B19 [get_ports {DRAM0_ODT[0]}] ; # set_property PACKAGE_PIN B19      [get_ports "PL_DDR4_ODT"] ;# Bank  69 VCCO - VCC1V2   - IO_L20P_T3L_N2_AD1P_69
set_property PACKAGE_PIN A17 [get_ports DRAM0_RESET_n] ; # set_property PACKAGE_PIN A17      [get_ports "PL_DDR4_RESET_B"] ;# Bank  69 VCCO - VCC1V2   - IO_L24P_T3U_N10_69
set_property PACKAGE_PIN AM15 [get_ports DRAM0_REFCLK_P] ; # set_property PACKAGE_PIN AM15     [get_ports "CLK_100_P"] ;# Bank  64 VCCO - VCC1V8   - IO_L11P_T1U_N8_GC_64
set_property PACKAGE_PIN AN15 [get_ports DRAM0_REFCLK_N] ; # set_property PACKAGE_PIN AN15     [get_ports "CLK_100_N"] ;# Bank  64 VCCO - VCC1V8   - IO_L11N_T1U_N9_GC_64
set_property PACKAGE_PIN G13 [get_ports {DRAM0_DM_n[0]}] ; # set_property PACKAGE_PIN G13      [get_ports "PL_DDR4_DM0_B"] ;# Bank  68 VCCO - VCC1V2   - IO_L13P_T2L_N0_GC_QBC_68
set_property PACKAGE_PIN E13 [get_ports {DRAM0_DQS_p[0]}] ; # set_property PACKAGE_PIN E13      [get_ports "PL_DDR4_DQS0_T"] ;# Bank  68 VCCO - VCC1V2   - IO_L16P_T2U_N6_QBC_AD3P_68
set_property PACKAGE_PIN E12 [get_ports {DRAM0_DQS_n[0]}] ; # set_property PACKAGE_PIN E12      [get_ports "PL_DDR4_DQS0_C"] ;# Bank  68 VCCO - VCC1V2   - IO_L16N_T2U_N7_QBC_AD3N_68
set_property PACKAGE_PIN D14 [get_ports {DRAM0_DQ[0]}] ; # set_property PACKAGE_PIN D14      [get_ports "PL_DDR4_DQ0"] ;# Bank  68 VCCO - VCC1V2   - IO_L18N_T2U_N11_AD2N_68
set_property PACKAGE_PIN E11 [get_ports {DRAM0_DQ[1]}] ; # set_property PACKAGE_PIN E11      [get_ports "PL_DDR4_DQ1"] ;# Bank  68 VCCO - VCC1V2   - IO_L17N_T2U_N9_AD10N_68
set_property PACKAGE_PIN F14 [get_ports {DRAM0_DQ[2]}] ; # set_property PACKAGE_PIN F14      [get_ports "PL_DDR4_DQ2"] ;# Bank  68 VCCO - VCC1V2   - IO_L15N_T2L_N5_AD11N_68
set_property PACKAGE_PIN F12 [get_ports {DRAM0_DQ[3]}] ; # set_property PACKAGE_PIN F12      [get_ports "PL_DDR4_DQ3"] ;# Bank  68 VCCO - VCC1V2   - IO_L17P_T2U_N8_AD10P_68
set_property PACKAGE_PIN E14 [get_ports {DRAM0_DQ[4]}] ; # set_property PACKAGE_PIN E14      [get_ports "PL_DDR4_DQ4"] ;# Bank  68 VCCO - VCC1V2   - IO_L18P_T2U_N10_AD2P_68
set_property PACKAGE_PIN H12 [get_ports {DRAM0_DQ[5]}] ; # set_property PACKAGE_PIN H12      [get_ports "PL_DDR4_DQ5"] ;# Bank  68 VCCO - VCC1V2   - IO_L14N_T2L_N3_GC_68
set_property PACKAGE_PIN G14 [get_ports {DRAM0_DQ[6]}] ; # set_property PACKAGE_PIN G14      [get_ports "PL_DDR4_DQ6"] ;# Bank  68 VCCO - VCC1V2   - IO_L15P_T2L_N4_AD11P_68
set_property PACKAGE_PIN H13 [get_ports {DRAM0_DQ[7]}] ; # set_property PACKAGE_PIN H13      [get_ports "PL_DDR4_DQ7"] ;# Bank  68 VCCO - VCC1V2   - IO_L14P_T2L_N2_GC_68
set_property PACKAGE_PIN C12 [get_ports {DRAM0_DM_n[1]}] ; # set_property PACKAGE_PIN C12      [get_ports "PL_DDR4_DM1_B"] ;# Bank  68 VCCO - VCC1V2   - IO_L19P_T3L_N0_DBC_AD9P_68
set_property PACKAGE_PIN C15 [get_ports {DRAM0_DQS_p[1]}] ; # set_property PACKAGE_PIN C15      [get_ports "PL_DDR4_DQS1_T"] ;# Bank  68 VCCO - VCC1V2   - IO_L22P_T3U_N6_DBC_AD0P_68
set_property PACKAGE_PIN B15 [get_ports {DRAM0_DQS_n[1]}] ; # set_property PACKAGE_PIN B15      [get_ports "PL_DDR4_DQS1_C"] ;# Bank  68 VCCO - VCC1V2   - IO_L22N_T3U_N7_DBC_AD0N_68
set_property PACKAGE_PIN B13 [get_ports {DRAM0_DQ[8]}] ; # set_property PACKAGE_PIN B13      [get_ports "PL_DDR4_DQ8"] ;# Bank  68 VCCO - VCC1V2   - IO_L21N_T3L_N5_AD8N_68
set_property PACKAGE_PIN A15 [get_ports {DRAM0_DQ[9]}] ; # set_property PACKAGE_PIN A15      [get_ports "PL_DDR4_DQ9"] ;# Bank  68 VCCO - VCC1V2   - IO_L24P_T3U_N10_68
set_property PACKAGE_PIN A12 [get_ports {DRAM0_DQ[10]}] ; # set_property PACKAGE_PIN A12      [get_ports "PL_DDR4_DQ10"] ;# Bank  68 VCCO - VCC1V2   - IO_L23P_T3U_N8_68
set_property PACKAGE_PIN A14 [get_ports {DRAM0_DQ[11]}] ; # set_property PACKAGE_PIN A14      [get_ports "PL_DDR4_DQ11"] ;# Bank  68 VCCO - VCC1V2   - IO_L24N_T3U_N11_68
set_property PACKAGE_PIN D13 [get_ports {DRAM0_DQ[12]}] ; # set_property PACKAGE_PIN D13      [get_ports "PL_DDR4_DQ12"] ;# Bank  68 VCCO - VCC1V2   - IO_L20P_T3L_N2_AD1P_68
set_property PACKAGE_PIN B14 [get_ports {DRAM0_DQ[13]}] ; # set_property PACKAGE_PIN B14      [get_ports "PL_DDR4_DQ13"] ;# Bank  68 VCCO - VCC1V2   - IO_L21P_T3L_N4_AD8P_68
set_property PACKAGE_PIN A11 [get_ports {DRAM0_DQ[14]}] ; # set_property PACKAGE_PIN A11      [get_ports "PL_DDR4_DQ14"] ;# Bank  68 VCCO - VCC1V2   - IO_L23N_T3U_N9_68
set_property PACKAGE_PIN C13 [get_ports {DRAM0_DQ[15]}] ; # set_property PACKAGE_PIN C13      [get_ports "PL_DDR4_DQ15"] ;# Bank  68 VCCO - VCC1V2   - IO_L20N_T3L_N3_AD1N_68
set_property PACKAGE_PIN K13 [get_ports {DRAM0_DM_n[2]}] ; # set_property PACKAGE_PIN K13      [get_ports "PL_DDR4_DM2_B"] ;# Bank  68 VCCO - VCC1V2   - IO_L7P_T1L_N0_QBC_AD13P_68
set_property PACKAGE_PIN J14 [get_ports {DRAM0_DQS_p[2]}] ; # set_property PACKAGE_PIN J14      [get_ports "PL_DDR4_DQS2_T"] ;# Bank  68 VCCO - VCC1V2   - IO_L10P_T1U_N6_QBC_AD4P_68
set_property PACKAGE_PIN J13 [get_ports {DRAM0_DQS_n[2]}] ; # set_property PACKAGE_PIN J13      [get_ports "PL_DDR4_DQS2_C"] ;# Bank  68 VCCO - VCC1V2   - IO_L10N_T1U_N7_QBC_AD4N_68
set_property PACKAGE_PIN K11 [get_ports {DRAM0_DQ[16]}] ; # set_property PACKAGE_PIN K11      [get_ports "PL_DDR4_DQ16"] ;# Bank  68 VCCO - VCC1V2   - IO_L8P_T1L_N2_AD5P_68
set_property PACKAGE_PIN J11 [get_ports {DRAM0_DQ[17]}] ; # set_property PACKAGE_PIN J11      [get_ports "PL_DDR4_DQ17"] ;# Bank  68 VCCO - VCC1V2   - IO_L11P_T1U_N8_GC_68
set_property PACKAGE_PIN H10 [get_ports {DRAM0_DQ[18]}] ; # set_property PACKAGE_PIN H10      [get_ports "PL_DDR4_DQ18"] ;# Bank  68 VCCO - VCC1V2   - IO_L12N_T1U_N11_GC_68
set_property PACKAGE_PIN F11 [get_ports {DRAM0_DQ[19]}] ; # set_property PACKAGE_PIN F11      [get_ports "PL_DDR4_DQ19"] ;# Bank  68 VCCO - VCC1V2   - IO_L9P_T1L_N4_AD12P_68
set_property PACKAGE_PIN K10 [get_ports {DRAM0_DQ[20]}] ; # set_property PACKAGE_PIN K10      [get_ports "PL_DDR4_DQ20"] ;# Bank  68 VCCO - VCC1V2   - IO_L8N_T1L_N3_AD5N_68
set_property PACKAGE_PIN F10 [get_ports {DRAM0_DQ[21]}] ; # set_property PACKAGE_PIN F10      [get_ports "PL_DDR4_DQ21"] ;# Bank  68 VCCO - VCC1V2   - IO_L9N_T1L_N5_AD12N_68
set_property PACKAGE_PIN J10 [get_ports {DRAM0_DQ[22]}] ; # set_property PACKAGE_PIN J10      [get_ports "PL_DDR4_DQ22"] ;# Bank  68 VCCO - VCC1V2   - IO_L11N_T1U_N9_GC_68
set_property PACKAGE_PIN H11 [get_ports {DRAM0_DQ[23]}] ; # set_property PACKAGE_PIN H11      [get_ports "PL_DDR4_DQ23"] ;# Bank  68 VCCO - VCC1V2   - IO_L12P_T1U_N10_GC_68
set_property PACKAGE_PIN J8 [get_ports {DRAM0_DM_n[3]}] ; # set_property PACKAGE_PIN J8       [get_ports "PL_DDR4_DM3_B"] ;# Bank  68 VCCO - VCC1V2   - IO_L1P_T0L_N0_DBC_68
set_property PACKAGE_PIN H8 [get_ports {DRAM0_DQS_p[3]}] ; # set_property PACKAGE_PIN H8       [get_ports "PL_DDR4_DQS3_T"] ;# Bank  68 VCCO - VCC1V2   - IO_L4P_T0U_N6_DBC_AD7P_68
set_property PACKAGE_PIN G8 [get_ports {DRAM0_DQS_n[3]}] ; # set_property PACKAGE_PIN G8       [get_ports "PL_DDR4_DQS3_C"] ;# Bank  68 VCCO - VCC1V2   - IO_L4N_T0U_N7_DBC_AD7N_68
set_property PACKAGE_PIN G9  [get_ports {DRAM0_DQ[24]}] ; # set_property PACKAGE_PIN G9       [get_ports "PL_DDR4_DQ24"] ;# Bank  68 VCCO - VCC1V2   - IO_L6P_T0U_N10_AD6P_68
set_property PACKAGE_PIN G7 [get_ports {DRAM0_DQ[25]}] ; # set_property PACKAGE_PIN G7       [get_ports "PL_DDR4_DQ25"] ;# Bank  68 VCCO - VCC1V2   - IO_L5P_T0U_N8_AD14P_68
set_property PACKAGE_PIN F9 [get_ports {DRAM0_DQ[26]}] ; # set_property PACKAGE_PIN F9       [get_ports "PL_DDR4_DQ26"] ;# Bank  68 VCCO - VCC1V2   - IO_L6N_T0U_N11_AD6N_68
set_property PACKAGE_PIN G6 [get_ports {DRAM0_DQ[27]}] ; # set_property PACKAGE_PIN G6       [get_ports "PL_DDR4_DQ27"] ;# Bank  68 VCCO - VCC1V2   - IO_L5N_T0U_N9_AD14N_68
set_property PACKAGE_PIN H6  [get_ports {DRAM0_DQ[28]}] ; # set_property PACKAGE_PIN H6       [get_ports "PL_DDR4_DQ28"] ;# Bank  68 VCCO - VCC1V2   - IO_L3N_T0L_N5_AD15N_68
set_property PACKAGE_PIN H7 [get_ports {DRAM0_DQ[29]}] ; # set_property PACKAGE_PIN H7       [get_ports "PL_DDR4_DQ29"] ;# Bank  68 VCCO - VCC1V2   - IO_L3P_T0L_N4_AD15P_68
set_property PACKAGE_PIN J9 [get_ports {DRAM0_DQ[30]}] ; # set_property PACKAGE_PIN J9       [get_ports "PL_DDR4_DQ30"] ;# Bank  68 VCCO - VCC1V2   - IO_L2N_T0L_N3_68
set_property PACKAGE_PIN K9 [get_ports {DRAM0_DQ[31]}] ; # set_property PACKAGE_PIN K9       [get_ports "PL_DDR4_DQ31"] ;# Bank  68 VCCO - VCC1V2   - IO_L2P_T0L_N2_68
set_property PACKAGE_PIN C23 [get_ports {DRAM0_DM_n[4]}] ; # set_property PACKAGE_PIN C23      [get_ports "PL_DDR4_DM4_B"] ;# Bank  67 VCCO - VCC1V2   - IO_L19P_T3L_N0_DBC_AD9P_67
set_property PACKAGE_PIN B22 [get_ports {DRAM0_DQS_p[4]}] ; # set_property PACKAGE_PIN B22      [get_ports "PL_DDR4_DQS4_T"] ;# Bank  67 VCCO - VCC1V2   - IO_L22P_T3U_N6_DBC_AD0P_67
set_property PACKAGE_PIN A22 [get_ports {DRAM0_DQS_n[4]}] ; # set_property PACKAGE_PIN A22      [get_ports "PL_DDR4_DQS4_C"] ;# Bank  67 VCCO - VCC1V2   - IO_L22N_T3U_N7_DBC_AD0N_67
set_property PACKAGE_PIN C22 [get_ports {DRAM0_DQ[32]}] ; # set_property PACKAGE_PIN C22      [get_ports "PL_DDR4_DQ32"] ;# Bank  67 VCCO - VCC1V2   - IO_L21N_T3L_N5_AD8N_67
set_property PACKAGE_PIN A20 [get_ports {DRAM0_DQ[33]}] ; # set_property PACKAGE_PIN A20      [get_ports "PL_DDR4_DQ33"] ;# Bank  67 VCCO - VCC1V2   - IO_L24P_T3U_N10_67
set_property PACKAGE_PIN A21 [get_ports {DRAM0_DQ[34]}] ; # set_property PACKAGE_PIN A21      [get_ports "PL_DDR4_DQ34"] ;# Bank  67 VCCO - VCC1V2   - IO_L24N_T3U_N11_67
set_property PACKAGE_PIN C21 [get_ports {DRAM0_DQ[35]}] ; # set_property PACKAGE_PIN C21      [get_ports "PL_DDR4_DQ35"] ;# Bank  67 VCCO - VCC1V2   - IO_L21P_T3L_N4_AD8P_67
set_property PACKAGE_PIN A24 [get_ports {DRAM0_DQ[36]}] ; # set_property PACKAGE_PIN A24      [get_ports "PL_DDR4_DQ36"] ;# Bank  67 VCCO - VCC1V2   - IO_L20N_T3L_N3_AD1N_67
set_property PACKAGE_PIN B20 [get_ports {DRAM0_DQ[37]}] ; # set_property PACKAGE_PIN B20      [get_ports "PL_DDR4_DQ37"] ;# Bank  67 VCCO - VCC1V2   - IO_L23N_T3U_N9_67
set_property PACKAGE_PIN B24 [get_ports {DRAM0_DQ[38]}] ; # set_property PACKAGE_PIN B24      [get_ports "PL_DDR4_DQ38"] ;# Bank  67 VCCO - VCC1V2   - IO_L20P_T3L_N2_AD1P_67
set_property PACKAGE_PIN C20 [get_ports {DRAM0_DQ[39]}] ; # set_property PACKAGE_PIN C20      [get_ports "PL_DDR4_DQ39"] ;# Bank  67 VCCO - VCC1V2   - IO_L23P_T3U_N8_67
set_property PACKAGE_PIN F21  [get_ports {DRAM0_DM_n[5]}] ; # set_property PACKAGE_PIN F21      [get_ports "PL_DDR4_DM5_B"] ;# Bank  67 VCCO - VCC1V2   - IO_L13P_T2L_N0_GC_QBC_67
set_property PACKAGE_PIN D23  [get_ports {DRAM0_DQS_p[5]}] ; # set_property PACKAGE_PIN D23      [get_ports "PL_DDR4_DQS5_T"] ;# Bank  67 VCCO - VCC1V2   - IO_L16P_T2U_N6_QBC_AD3P_67
set_property PACKAGE_PIN D24  [get_ports {DRAM0_DQS_n[5]}] ; # set_property PACKAGE_PIN D24      [get_ports "PL_DDR4_DQS5_C"] ;# Bank  67 VCCO - VCC1V2   - IO_L16N_T2U_N7_QBC_AD3N_67
set_property PACKAGE_PIN E24  [get_ports {DRAM0_DQ[40]}] ; # set_property PACKAGE_PIN E24      [get_ports "PL_DDR4_DQ40"] ;# Bank  67 VCCO - VCC1V2   - IO_L15N_T2L_N5_AD11N_67
set_property PACKAGE_PIN E22  [get_ports {DRAM0_DQ[41]}] ; # set_property PACKAGE_PIN E22      [get_ports "PL_DDR4_DQ41"] ;# Bank  67 VCCO - VCC1V2   - IO_L17P_T2U_N8_AD10P_67
set_property PACKAGE_PIN E23  [get_ports {DRAM0_DQ[42]}] ; # set_property PACKAGE_PIN E23      [get_ports "PL_DDR4_DQ42"] ;# Bank  67 VCCO - VCC1V2   - IO_L17N_T2U_N9_AD10N_67
set_property PACKAGE_PIN G20  [get_ports {DRAM0_DQ[43]}] ; # set_property PACKAGE_PIN G20      [get_ports "PL_DDR4_DQ43"] ;# Bank  67 VCCO - VCC1V2   - IO_L14P_T2L_N2_GC_67
set_property PACKAGE_PIN F24  [get_ports {DRAM0_DQ[44]}] ; # set_property PACKAGE_PIN F24      [get_ports "PL_DDR4_DQ44"] ;# Bank  67 VCCO - VCC1V2   - IO_L15P_T2L_N4_AD11P_67
set_property PACKAGE_PIN E21  [get_ports {DRAM0_DQ[45]}] ; # set_property PACKAGE_PIN E21      [get_ports "PL_DDR4_DQ45"] ;# Bank  67 VCCO - VCC1V2   - IO_L18P_T2U_N10_AD2P_67
set_property PACKAGE_PIN F20  [get_ports {DRAM0_DQ[46]}] ; # set_property PACKAGE_PIN F20      [get_ports "PL_DDR4_DQ46"] ;# Bank  67 VCCO - VCC1V2   - IO_L14N_T2L_N3_GC_67
set_property PACKAGE_PIN D21  [get_ports {DRAM0_DQ[47]}] ; # set_property PACKAGE_PIN D21      [get_ports "PL_DDR4_DQ47"] ;# Bank  67 VCCO - VCC1V2   - IO_L18N_T2U_N11_AD2N_67
set_property PACKAGE_PIN J23 [get_ports {DRAM0_DM_n[6]}] ; # set_property PACKAGE_PIN J23      [get_ports "PL_DDR4_DM6_B"] ;# Bank  67 VCCO - VCC1V2   - IO_L7P_T1L_N0_QBC_AD13P_67
set_property PACKAGE_PIN J20 [get_ports {DRAM0_DQS_p[6]}] ; # set_property PACKAGE_PIN J20      [get_ports "PL_DDR4_DQS6_T"] ;# Bank  67 VCCO - VCC1V2   - IO_L10P_T1U_N6_QBC_AD4P_67
set_property PACKAGE_PIN H20 [get_ports {DRAM0_DQS_n[6]}] ; # set_property PACKAGE_PIN H20      [get_ports "PL_DDR4_DQS6_C"] ;# Bank  67 VCCO - VCC1V2   - IO_L10N_T1U_N7_QBC_AD4N_67
set_property PACKAGE_PIN H23 [get_ports {DRAM0_DQ[48]}] ; # set_property PACKAGE_PIN H23      [get_ports "PL_DDR4_DQ48"] ;# Bank  67 VCCO - VCC1V2   - IO_L12P_T1U_N10_GC_67
set_property PACKAGE_PIN G23 [get_ports {DRAM0_DQ[49]}] ; # set_property PACKAGE_PIN G23      [get_ports "PL_DDR4_DQ49"] ;# Bank  67 VCCO - VCC1V2   - IO_L12N_T1U_N11_GC_67
set_property PACKAGE_PIN K24 [get_ports {DRAM0_DQ[50]}] ; # set_property PACKAGE_PIN K24      [get_ports "PL_DDR4_DQ50"] ;# Bank  67 VCCO - VCC1V2   - IO_L8N_T1L_N3_AD5N_67
set_property PACKAGE_PIN G22 [get_ports {DRAM0_DQ[51]}] ; # set_property PACKAGE_PIN G22      [get_ports "PL_DDR4_DQ51"] ;# Bank  67 VCCO - VCC1V2   - IO_L11N_T1U_N9_GC_67
set_property PACKAGE_PIN J21 [get_ports {DRAM0_DQ[52]}] ; # set_property PACKAGE_PIN J21      [get_ports "PL_DDR4_DQ52"] ;# Bank  67 VCCO - VCC1V2   - IO_L9P_T1L_N4_AD12P_67
set_property PACKAGE_PIN H22 [get_ports {DRAM0_DQ[53]}] ; # set_property PACKAGE_PIN H22      [get_ports "PL_DDR4_DQ53"] ;# Bank  67 VCCO - VCC1V2   - IO_L11P_T1U_N8_GC_67
set_property PACKAGE_PIN L24 [get_ports {DRAM0_DQ[54]}] ; # set_property PACKAGE_PIN L24      [get_ports "PL_DDR4_DQ54"] ;# Bank  67 VCCO - VCC1V2   - IO_L8P_T1L_N2_AD5P_67
set_property PACKAGE_PIN H21 [get_ports {DRAM0_DQ[55]}] ; # set_property PACKAGE_PIN H21      [get_ports "PL_DDR4_DQ55"] ;# Bank  67 VCCO - VCC1V2   - IO_L9N_T1L_N5_AD12N_67
set_property PACKAGE_PIN N20 [get_ports {DRAM0_DM_n[7]}] ; # set_property PACKAGE_PIN N20      [get_ports "PL_DDR4_DM7_B"] ;# Bank  67 VCCO - VCC1V2   - IO_L1P_T0L_N0_DBC_67
set_property PACKAGE_PIN K21 [get_ports {DRAM0_DQS_p[7]}] ; # set_property PACKAGE_PIN K21      [get_ports "PL_DDR4_DQS7_T"] ;# Bank  67 VCCO - VCC1V2   - IO_L4P_T0U_N6_DBC_AD7P_67
set_property PACKAGE_PIN K22 [get_ports {DRAM0_DQS_n[7]}] ; # set_property PACKAGE_PIN K22      [get_ports "PL_DDR4_DQS7_C"] ;# Bank  67 VCCO - VCC1V2   - IO_L4N_T0U_N7_DBC_AD7N_67
set_property PACKAGE_PIN L23 [get_ports {DRAM0_DQ[56]}] ; # set_property PACKAGE_PIN L23      [get_ports "PL_DDR4_DQ56"] ;# Bank  67 VCCO - VCC1V2   - IO_L5N_T0U_N9_AD14N_67
set_property PACKAGE_PIN L20 [get_ports {DRAM0_DQ[57]}] ; # set_property PACKAGE_PIN L20      [get_ports "PL_DDR4_DQ57"] ;# Bank  67 VCCO - VCC1V2   - IO_L6N_T0U_N11_AD6N_67
set_property PACKAGE_PIN L22 [get_ports {DRAM0_DQ[58]}] ; # set_property PACKAGE_PIN L22      [get_ports "PL_DDR4_DQ58"] ;# Bank  67 VCCO - VCC1V2   - IO_L5P_T0U_N8_AD14P_67
set_property PACKAGE_PIN L21 [get_ports {DRAM0_DQ[59]}] ; # set_property PACKAGE_PIN L21      [get_ports "PL_DDR4_DQ59"] ;# Bank  67 VCCO - VCC1V2   - IO_L3N_T0L_N5_AD15N_67
set_property PACKAGE_PIN M20 [get_ports {DRAM0_DQ[60]}] ; # set_property PACKAGE_PIN M20      [get_ports "PL_DDR4_DQ60"] ;# Bank  67 VCCO - VCC1V2   - IO_L3P_T0L_N4_AD15P_67
set_property PACKAGE_PIN L19 [get_ports {DRAM0_DQ[61]}] ; # set_property PACKAGE_PIN L19      [get_ports "PL_DDR4_DQ61"] ;# Bank  67 VCCO - VCC1V2   - IO_L6P_T0U_N10_AD6P_67
set_property PACKAGE_PIN M19 [get_ports {DRAM0_DQ[62]}] ; # set_property PACKAGE_PIN M19      [get_ports "PL_DDR4_DQ62"] ;# Bank  67 VCCO - VCC1V2   - IO_L2N_T0L_N3_67
set_property PACKAGE_PIN N19 [get_ports {DRAM0_DQ[63]}] ; # set_property PACKAGE_PIN N19      [get_ports "PL_DDR4_DQ63"] ;# Bank  67 VCCO - VCC1V2   - IO_L2P_T0L_N2_67

set_property IOSTANDARD DIFF_POD12_DCI  [get_ports {DRAM0_DQS_*[*]}]
set_property IOSTANDARD DIFF_SSTL12     [get_ports {DRAM0_REFCLK_*}]
set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports {DRAM0_CLK_*[0]}]
set_property IOSTANDARD LVCMOS12        [get_ports  DRAM0_RESET_n]
set_property IOSTANDARD POD12_DCI       [get_ports {DRAM0_DM_n[*] \
                                                    DRAM0_DQ[*]}]
set_property IOSTANDARD SSTL12_DCI      [get_ports {DRAM0_ACT_n \
                                                    DRAM0_ADDR[*] \
                                                    DRAM0_BA[*] \
                                                    DRAM0_BG[0] \
                                                    DRAM0_CKE[0] \
                                                    DRAM0_CS_n[0] \
                                                    DRAM0_ODT[0]}]

set_property DRIVE      8                [get_ports DRAM0_RESET_n]

set_property SLEW FAST [get_ports {DRAM0_ACT_n \
                                   DRAM0_ADDR[*] \
                                   DRAM0_BA[*] \
                                   DRAM0_BG[0] \
                                   DRAM0_CLK_*[0] \
                                   DRAM0_CKE[0] \
                                   DRAM0_CS_n[0] \
                                   DRAM0_DM_n[*] \
                                   DRAM0_DQ[*] \
                                   DRAM0_DQS_*[*] \
                                   DRAM0_ODT[0]}]

set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {DRAM0_ACT_n \
                                                     DRAM0_ADDR[*] \
                                                     DRAM0_BA[*] \
                                                     DRAM0_BG[0] \
                                                     DRAM0_CLK_*[0] \
                                                     DRAM0_CKE[0] \
                                                     DRAM0_CS_n[0] \
                                                     DRAM0_DM_n[*] \
                                                     DRAM0_DQ[*] \
                                                     DRAM0_DQS_*[*] \
                                                     DRAM0_ODT[0]}]

set_property IBUF_LOW_PWR FALSE [get_ports {DRAM0_DM_n[*] \
                                            DRAM0_DQ[*] \
                                            DRAM0_DQS_*[*]}]



###############################################################################
# Pin constraints for DRAM controller 1
###############################################################################

# set_property PACKAGE_PIN E14 [get_ports DRAM1_ACT_n]
# set_property PACKAGE_PIN B12 [get_ports {DRAM1_ADDR[0]}]
# set_property PACKAGE_PIN G14 [get_ports {DRAM1_ADDR[1]}]
# set_property PACKAGE_PIN D13 [get_ports {DRAM1_ADDR[2]}]
# set_property PACKAGE_PIN F12 [get_ports {DRAM1_ADDR[3]}]
# set_property PACKAGE_PIN C13 [get_ports {DRAM1_ADDR[4]}]
# set_property PACKAGE_PIN D14 [get_ports {DRAM1_ADDR[5]}]
# set_property PACKAGE_PIN C12 [get_ports {DRAM1_ADDR[6]}]
# set_property PACKAGE_PIN C15 [get_ports {DRAM1_ADDR[7]}]
# set_property PACKAGE_PIN H12 [get_ports {DRAM1_ADDR[8]}]
# set_property PACKAGE_PIN H13 [get_ports {DRAM1_ADDR[9]}]
# set_property PACKAGE_PIN A14 [get_ports {DRAM1_ADDR[10]}]
# set_property PACKAGE_PIN K12 [get_ports {DRAM1_ADDR[11]}]
# set_property PACKAGE_PIN D11 [get_ports {DRAM1_ADDR[12]}]
# set_property PACKAGE_PIN J7  [get_ports {DRAM1_ADDR[13]}]
# set_property PACKAGE_PIN A15 [get_ports {DRAM1_ADDR[14]}]
# set_property PACKAGE_PIN B14 [get_ports {DRAM1_ADDR[15]}]
# set_property PACKAGE_PIN E11 [get_ports {DRAM1_ADDR[16]}]
# set_property PACKAGE_PIN A12 [get_ports {DRAM1_BA[0]}]
# set_property PACKAGE_PIN A11 [get_ports {DRAM1_BA[1]}]
# set_property PACKAGE_PIN B13 [get_ports {DRAM1_BG[0]}]
# set_property PACKAGE_PIN E13 [get_ports {DRAM1_CLK_P[0]}]
# set_property PACKAGE_PIN E12 [get_ports {DRAM1_CLK_N[0]}]
# set_property PACKAGE_PIN C11 [get_ports {DRAM1_CKE[0]}]
# set_property PACKAGE_PIN F14 [get_ports {DRAM1_CS_n[0]}]
# set_property PACKAGE_PIN B15 [get_ports {DRAM1_ODT[0]}]
# set_property PACKAGE_PIN G24 [get_ports DRAM1_RESET_n]
# set_property PACKAGE_PIN G13 [get_ports DRAM1_REFCLK_P]
# set_property PACKAGE_PIN G12 [get_ports DRAM1_REFCLK_N]
# set_property PACKAGE_PIN J8  [get_ports {DRAM1_DM_n[0]}]
# set_property PACKAGE_PIN H8  [get_ports {DRAM1_DQS_p[0]}]
# set_property PACKAGE_PIN G8  [get_ports {DRAM1_DQS_n[0]}]
# set_property PACKAGE_PIN G9  [get_ports {DRAM1_DQ[0]}]
# set_property PACKAGE_PIN J9  [get_ports {DRAM1_DQ[1]}]
# set_property PACKAGE_PIN H7  [get_ports {DRAM1_DQ[2]}]
# set_property PACKAGE_PIN H6  [get_ports {DRAM1_DQ[3]}]
# set_property PACKAGE_PIN G7  [get_ports {DRAM1_DQ[4]}]
# set_property PACKAGE_PIN G6  [get_ports {DRAM1_DQ[5]}]
# set_property PACKAGE_PIN F9  [get_ports {DRAM1_DQ[6]}]
# set_property PACKAGE_PIN K9  [get_ports {DRAM1_DQ[7]}]
# set_property PACKAGE_PIN K13 [get_ports {DRAM1_DM_n[1]}]
# set_property PACKAGE_PIN J14 [get_ports {DRAM1_DQS_p[1]}]
# set_property PACKAGE_PIN J13 [get_ports {DRAM1_DQS_n[1]}]
# set_property PACKAGE_PIN F10 [get_ports {DRAM1_DQ[8]}]
# set_property PACKAGE_PIN K10 [get_ports {DRAM1_DQ[9]}]
# set_property PACKAGE_PIN F11 [get_ports {DRAM1_DQ[10]}]
# set_property PACKAGE_PIN H10 [get_ports {DRAM1_DQ[11]}]
# set_property PACKAGE_PIN H11 [get_ports {DRAM1_DQ[12]}]
# set_property PACKAGE_PIN J10 [get_ports {DRAM1_DQ[13]}]
# set_property PACKAGE_PIN J11 [get_ports {DRAM1_DQ[14]}]
# set_property PACKAGE_PIN K11 [get_ports {DRAM1_DQ[15]}]
# set_property PACKAGE_PIN D18 [get_ports {DRAM1_DM_n[2]}]
# set_property PACKAGE_PIN B18 [get_ports {DRAM1_DQS_p[2]}]
# set_property PACKAGE_PIN B17 [get_ports {DRAM1_DQS_n[2]}]
# set_property PACKAGE_PIN A17 [get_ports {DRAM1_DQ[16]}]
# set_property PACKAGE_PIN D15 [get_ports {DRAM1_DQ[17]}]
# set_property PACKAGE_PIN A16 [get_ports {DRAM1_DQ[18]}]
# set_property PACKAGE_PIN D16 [get_ports {DRAM1_DQ[19]}]
# set_property PACKAGE_PIN C17 [get_ports {DRAM1_DQ[20]}]
# set_property PACKAGE_PIN B19 [get_ports {DRAM1_DQ[21]}]
# set_property PACKAGE_PIN A19 [get_ports {DRAM1_DQ[22]}]
# set_property PACKAGE_PIN C16 [get_ports {DRAM1_DQ[23]}]
# set_property PACKAGE_PIN N14 [get_ports {DRAM1_DM_n[3]}]
# set_property PACKAGE_PIN L15 [get_ports {DRAM1_DQS_p[3]}]
# set_property PACKAGE_PIN L14 [get_ports {DRAM1_DQS_n[3]}]
# set_property PACKAGE_PIN N15 [get_ports {DRAM1_DQ[24]}]
# set_property PACKAGE_PIN M12 [get_ports {DRAM1_DQ[25]}]
# set_property PACKAGE_PIN M15 [get_ports {DRAM1_DQ[26]}]
# set_property PACKAGE_PIN M13 [get_ports {DRAM1_DQ[27]}]
# set_property PACKAGE_PIN N17 [get_ports {DRAM1_DQ[28]}]
# set_property PACKAGE_PIN L12 [get_ports {DRAM1_DQ[29]}]
# set_property PACKAGE_PIN M17 [get_ports {DRAM1_DQ[30]}]
# set_property PACKAGE_PIN N13 [get_ports {DRAM1_DQ[31]}]
# set_property PACKAGE_PIN C23 [get_ports {DRAM1_DM_n[4]}]
# set_property PACKAGE_PIN B22 [get_ports {DRAM1_DQS_p[4]}]
# set_property PACKAGE_PIN A22 [get_ports {DRAM1_DQS_n[4]}]
# set_property PACKAGE_PIN B24 [get_ports {DRAM1_DQ[32]}]
# set_property PACKAGE_PIN C21 [get_ports {DRAM1_DQ[33]}]
# set_property PACKAGE_PIN C22 [get_ports {DRAM1_DQ[34]}]
# set_property PACKAGE_PIN A21 [get_ports {DRAM1_DQ[35]}]
# set_property PACKAGE_PIN A24 [get_ports {DRAM1_DQ[36]}]
# set_property PACKAGE_PIN B20 [get_ports {DRAM1_DQ[37]}]
# set_property PACKAGE_PIN C20 [get_ports {DRAM1_DQ[38]}]
# set_property PACKAGE_PIN A20 [get_ports {DRAM1_DQ[39]}]
# set_property PACKAGE_PIN F21 [get_ports {DRAM1_DM_n[5]}]
# set_property PACKAGE_PIN D23 [get_ports {DRAM1_DQS_p[5]}]
# set_property PACKAGE_PIN D24 [get_ports {DRAM1_DQS_n[5]}]
# set_property PACKAGE_PIN E24 [get_ports {DRAM1_DQ[40]}]
# set_property PACKAGE_PIN E22 [get_ports {DRAM1_DQ[41]}]
# set_property PACKAGE_PIN F24 [get_ports {DRAM1_DQ[42]}]
# set_property PACKAGE_PIN E23 [get_ports {DRAM1_DQ[43]}]
# set_property PACKAGE_PIN E21 [get_ports {DRAM1_DQ[44]}]
# set_property PACKAGE_PIN D21 [get_ports {DRAM1_DQ[45]}]
# set_property PACKAGE_PIN F20 [get_ports {DRAM1_DQ[46]}]
# set_property PACKAGE_PIN G20 [get_ports {DRAM1_DQ[47]}]
# set_property PACKAGE_PIN J23 [get_ports {DRAM1_DM_n[6]}]
# set_property PACKAGE_PIN J20 [get_ports {DRAM1_DQS_p[6]}]
# set_property PACKAGE_PIN H20 [get_ports {DRAM1_DQS_n[6]}]
# set_property PACKAGE_PIN L24 [get_ports {DRAM1_DQ[48]}]
# set_property PACKAGE_PIN H23 [get_ports {DRAM1_DQ[49]}]
# set_property PACKAGE_PIN J21 [get_ports {DRAM1_DQ[50]}]
# set_property PACKAGE_PIN H22 [get_ports {DRAM1_DQ[51]}]
# set_property PACKAGE_PIN K24 [get_ports {DRAM1_DQ[52]}]
# set_property PACKAGE_PIN G23 [get_ports {DRAM1_DQ[53]}]
# set_property PACKAGE_PIN H21 [get_ports {DRAM1_DQ[54]}]
# set_property PACKAGE_PIN G22 [get_ports {DRAM1_DQ[55]}]
# set_property PACKAGE_PIN N20 [get_ports {DRAM1_DM_n[7]}]
# set_property PACKAGE_PIN K21 [get_ports {DRAM1_DQS_p[7]}]
# set_property PACKAGE_PIN K22 [get_ports {DRAM1_DQS_n[7]}]
# set_property PACKAGE_PIN M19 [get_ports {DRAM1_DQ[56]}]
# set_property PACKAGE_PIN L21 [get_ports {DRAM1_DQ[57]}]
# set_property PACKAGE_PIN M20 [get_ports {DRAM1_DQ[58]}]
# set_property PACKAGE_PIN L23 [get_ports {DRAM1_DQ[59]}]
# set_property PACKAGE_PIN N19 [get_ports {DRAM1_DQ[60]}]
# set_property PACKAGE_PIN L22 [get_ports {DRAM1_DQ[61]}]
# set_property PACKAGE_PIN L20 [get_ports {DRAM1_DQ[62]}]
# set_property PACKAGE_PIN L19 [get_ports {DRAM1_DQ[63]}]


# set_property IOSTANDARD DIFF_POD12_DCI  [get_ports {DRAM1_DQS_*[*]}]
# set_property IOSTANDARD DIFF_SSTL12     [get_ports {DRAM1_REFCLK_*}]
# set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports {DRAM1_CLK_*[0]}]
# set_property IOSTANDARD LVCMOS12        [get_ports  DRAM1_RESET_n]
# set_property IOSTANDARD POD12_DCI       [get_ports {DRAM1_DM_n[*] \
#                                                     DRAM1_DQ[*]}]
# set_property IOSTANDARD SSTL12_DCI      [get_ports {DRAM1_ACT_n \
#                                                     DRAM1_ADDR[*] \
#                                                     DRAM1_BA[*] \
#                                                     DRAM1_BG[0] \
#                                                     DRAM1_CKE[0] \
#                                                     DRAM1_CS_n[0] \
#                                                     DRAM1_ODT[0]}]

# set_property DRIVE      8                [get_ports DRAM1_RESET_n]

# set_property SLEW FAST [get_ports {DRAM1_ACT_n \
#                                    DRAM1_ADDR[*] \
#                                    DRAM1_BA[*] \
#                                    DRAM1_BG[0] \
#                                    DRAM1_CLK_*[0] \
#                                    DRAM1_CKE[0] \
#                                    DRAM1_CS_n[0] \
#                                    DRAM1_DM_n[*] \
#                                    DRAM1_DQ[*] \
#                                    DRAM1_DQS_*[*] \
#                                    DRAM1_ODT[0]}]

# set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {DRAM1_ACT_n \
#                                                      DRAM1_ADDR[*] \
#                                                      DRAM1_BA[*] \
#                                                      DRAM1_BG[0] \
#                                                      DRAM1_CLK_*[0] \
#                                                      DRAM1_CKE[0] \
#                                                      DRAM1_CS_n[0] \
#                                                      DRAM1_DM_n[*] \
#                                                      DRAM1_DQ[*] \
#                                                      DRAM1_DQS_*[*] \
#                                                      DRAM1_ODT[0]}]

# set_property IBUF_LOW_PWR FALSE [get_ports {DRAM1_DM_n[*] \
#                                             DRAM1_DQ[*] \
#                                             DRAM1_DQS_*[*]}]
