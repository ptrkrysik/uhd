
################################################################
# This is a generated script based on design: adc_100m_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2021.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source adc_100m_bd_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# adc_3_1_clk_converter, adc_gearbox_2x1, ddc_saturate, scale_2x

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu28dr-ffvg1517-1-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name adc_100m_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

  # Add USER_COMMENTS on $design_name
  set_property USER_COMMENTS.comment_0 "Scale_2x is a simple shift to left by 2 logic and does not need any pipeline stage" [get_bd_designs $design_name]

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axis_register_slice:1.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:fir_compiler:7.2\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
adc_3_1_clk_converter\
adc_gearbox_2x1\
ddc_saturate\
scale_2x\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set adc_data_out [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 adc_data_out ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {170666667} \
   ] $adc_data_out

  set adc_i_data_in [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 adc_i_data_in ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {256000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $adc_i_data_in

  set adc_q_data_in [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 adc_q_data_in ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {256000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $adc_q_data_in


  # Create ports
  set adc_data_out_resetn_dclk [ create_bd_port -dir I -type rst adc_data_out_resetn_dclk ]
  set data_clk [ create_bd_port -dir I -type clk -freq_hz 170666667 data_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {adc_data_out} \
 ] $data_clk
  set enable_data_to_fir_rclk [ create_bd_port -dir I enable_data_to_fir_rclk ]
  set fir_resetn_rclk2x [ create_bd_port -dir I -type rst fir_resetn_rclk2x ]
  set rfdc_adc_axi_resetn_rclk [ create_bd_port -dir I -type rst rfdc_adc_axi_resetn_rclk ]
  set rfdc_clk [ create_bd_port -dir I -type clk -freq_hz 256000000 rfdc_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {adc_i_data_in:adc_q_data_in} \
   CONFIG.ASSOCIATED_RESET {adc_gearbox_resetn_rclk:rfdc_adc_axi_resetn_rclk} \
 ] $rfdc_clk
  set rfdc_clk_2x [ create_bd_port -dir I -type clk -freq_hz 368640000 rfdc_clk_2x ]
  set swap_iq_2x [ create_bd_port -dir I swap_iq_2x ]

  # Create instance: adc_3_1_clk_converter_0, and set properties
  set block_name adc_3_1_clk_converter
  set block_cell_name adc_3_1_clk_converter_0
  if { [catch {set adc_3_1_clk_converter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $adc_3_1_clk_converter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: adc_data_to_axi, and set properties
  set adc_data_to_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 adc_data_to_axi ]
  set_property -dict [ list \
   CONFIG.HAS_TREADY {0} \
   CONFIG.REG_CONFIG {1} \
   CONFIG.TDATA_NUM_BYTES {4} \
 ] $adc_data_to_axi

  # Create instance: adc_gearbox_2x1_0, and set properties
  set block_name adc_gearbox_2x1
  set block_cell_name adc_gearbox_2x1_0
  if { [catch {set adc_gearbox_2x1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $adc_gearbox_2x1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: adc_i_data_from_axi, and set properties
  set adc_i_data_from_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 adc_i_data_from_axi ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {0} \
   CONFIG.TDATA_NUM_BYTES {4} \
 ] $adc_i_data_from_axi

  # Create instance: adc_q_data_from_axi, and set properties
  set adc_q_data_from_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 adc_q_data_from_axi ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {0} \
   CONFIG.TDATA_NUM_BYTES {4} \
 ] $adc_q_data_from_axi

  # Create instance: const_1, and set properties
  set const_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_1 ]

  # Create instance: ddc_saturate, and set properties
  set block_name ddc_saturate
  set block_cell_name ddc_saturate
  if { [catch {set ddc_saturate [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ddc_saturate eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fir_compiler_0, and set properties
  set fir_compiler_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_compiler_0 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {512} \
   CONFIG.CoefficientVector {-2,0,8,12,0,-26,-36,0,63,81,0,-130,-161,0,241,291,0,-415,-491,0,676,788,0,-1059,-1223,0,1621,1864,0,-2473,-2860,0,3892,4607,0,-6820,-8705,0,17900,36048,43690,36048,17900,0,-8705,-6820,0,4607,3892,0,-2860,-2473,0,1864,1621,0,-1223,-1059,0,788,676,0,-491,-415,0,291,241,0,-161,-130,0,81,63,0,-36,-26,0,12,8,0,-2}\
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {18} \
   CONFIG.ColumnConfig {14} \
   CONFIG.Data_Fractional_Bits {0} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {3} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Decimation} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TREADY {false} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Convergent_Rounding_to_Even} \
   CONFIG.Output_Width {17} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Reset_Data_Vector {true} \
   CONFIG.S_DATA_Has_FIFO {false} \
   CONFIG.Sample_Frequency {512} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_compiler_0

  # Create instance: scale_2x_0, and set properties
  set block_name scale_2x
  set block_cell_name scale_2x_0
  if { [catch {set scale_2x_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $scale_2x_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.kDataWidth {32} \
 ] $scale_2x_0

  # Create interface connections
  connect_bd_intf_net -intf_net adc_data_combine_M_AXIS [get_bd_intf_ports adc_data_out] [get_bd_intf_pins adc_data_to_axi/M_AXIS]
  connect_bd_intf_net -intf_net adc_i_axi_data_1 [get_bd_intf_ports adc_i_data_in] [get_bd_intf_pins adc_i_data_from_axi/S_AXIS]
  connect_bd_intf_net -intf_net adc_q_axi_data_1 [get_bd_intf_ports adc_q_data_in] [get_bd_intf_pins adc_q_data_from_axi/S_AXIS]
  connect_bd_intf_net -intf_net fir_compiler_0_M_AXIS_DATA [get_bd_intf_pins adc_3_1_clk_converter_0/s_axis] [get_bd_intf_pins fir_compiler_0/M_AXIS_DATA]

  # Create port connections
  connect_bd_net -net adc_3_1_clk_converter_0_m_axis_tdata [get_bd_pins adc_3_1_clk_converter_0/m_axis_tdata] [get_bd_pins ddc_saturate/cDataIn]
  connect_bd_net -net adc_3_1_clk_converter_0_m_axis_tvalid [get_bd_pins adc_3_1_clk_converter_0/m_axis_tvalid] [get_bd_pins ddc_saturate/cDataValidIn]
  connect_bd_net -net adc_data_out_resetn_dclk_1 [get_bd_ports adc_data_out_resetn_dclk] [get_bd_pins adc_3_1_clk_converter_0/m_axis_resetn] [get_bd_pins adc_data_to_axi/aresetn]
  connect_bd_net -net adc_gearbox_2x1_0_adc_data_out_2x [get_bd_pins adc_gearbox_2x1_0/adc_out_2x] [get_bd_pins fir_compiler_0/s_axis_data_tdata]
  connect_bd_net -net adc_gearbox_2x1_0_rfi_1x [get_bd_pins adc_i_data_from_axi/m_axis_tready] [get_bd_pins adc_q_data_from_axi/m_axis_tready] [get_bd_pins const_1/dout]
  connect_bd_net -net adc_gearbox_2x1_0_valid_out_2x [get_bd_pins adc_gearbox_2x1_0/valid_out_2x] [get_bd_pins fir_compiler_0/s_axis_data_tvalid]
  connect_bd_net -net adc_q_data_breakout_m_axis_tdata [get_bd_pins adc_gearbox_2x1_0/adc_q_in_1x] [get_bd_pins adc_q_data_from_axi/m_axis_tdata]
  connect_bd_net -net aresetn_0_1 [get_bd_ports fir_resetn_rclk2x] [get_bd_pins adc_3_1_clk_converter_0/s_axis_resetn] [get_bd_pins fir_compiler_0/aresetn]
  connect_bd_net -net axis_register_slice_0_m_axis_tdata [get_bd_pins adc_gearbox_2x1_0/adc_i_in_1x] [get_bd_pins adc_i_data_from_axi/m_axis_tdata]
  connect_bd_net -net axis_register_slice_0_m_axis_tvalid [get_bd_pins adc_gearbox_2x1_0/valid_in_1x] [get_bd_pins adc_i_data_from_axi/m_axis_tvalid]
  connect_bd_net -net data_clock_mmcm_data_clk [get_bd_ports data_clk] [get_bd_pins adc_3_1_clk_converter_0/m_axis_clk] [get_bd_pins adc_data_to_axi/aclk] [get_bd_pins ddc_saturate/Clk]
  connect_bd_net -net data_clock_mmcm_rfdc_clk [get_bd_ports rfdc_clk] [get_bd_pins adc_gearbox_2x1_0/clk1x] [get_bd_pins adc_i_data_from_axi/aclk] [get_bd_pins adc_q_data_from_axi/aclk]
  connect_bd_net -net data_clock_mmcm_rfdc_clk_2x [get_bd_ports rfdc_clk_2x] [get_bd_pins adc_3_1_clk_converter_0/s_axis_clk] [get_bd_pins adc_gearbox_2x1_0/clk2x] [get_bd_pins fir_compiler_0/aclk]
  connect_bd_net -net ddc_saturate_cDataOut [get_bd_pins ddc_saturate/cDataOut] [get_bd_pins scale_2x_0/cDataIn]
  connect_bd_net -net ddc_saturate_cDataValidOut [get_bd_pins ddc_saturate/cDataValidOut] [get_bd_pins scale_2x_0/cDataValidIn]
  connect_bd_net -net enable_data_to_fir_rclk_1 [get_bd_ports enable_data_to_fir_rclk] [get_bd_pins adc_gearbox_2x1_0/enable_1x]
  connect_bd_net -net rfdc_adc_axi_resetn_rclk_1 [get_bd_ports rfdc_adc_axi_resetn_rclk] [get_bd_pins adc_gearbox_2x1_0/reset_n_1x] [get_bd_pins adc_i_data_from_axi/aresetn] [get_bd_pins adc_q_data_from_axi/aresetn]
  connect_bd_net -net scale_2x_0_cDataOut [get_bd_pins adc_data_to_axi/s_axis_tdata] [get_bd_pins scale_2x_0/cDataOut]
  connect_bd_net -net scale_2x_0_cDataValidOut [get_bd_pins adc_data_to_axi/s_axis_tvalid] [get_bd_pins scale_2x_0/cDataValidOut]
  connect_bd_net -net swap_iq_2x_1 [get_bd_ports swap_iq_2x] [get_bd_pins adc_gearbox_2x1_0/swap_iq_2x]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


