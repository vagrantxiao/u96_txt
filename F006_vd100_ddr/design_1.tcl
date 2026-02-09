
################################################################
# This is a generated script based on design: design_1
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
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axil_ctrl, mem_agent_maxi

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcve2302-sfva784-1LP-e-S
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

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
xilinx.com:ip:versal_cips:3.4\
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconstant:1.1\
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
axil_ctrl\
mem_agent_maxi\
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
  set DDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 DDR4 ]

  set sys_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $sys_clk


  # Create ports
  set led [ create_bd_port -dir O led ]

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.4 versal_cips_0 ]
  set_property -dict [list \
    CONFIG.BOOT_MODE {Custom} \
    CONFIG.DDR_MEMORY_MODE {Enable} \
    CONFIG.DESIGN_MODE {1} \
    CONFIG.IO_CONFIG_MODE {Custom} \
    CONFIG.PS_PMC_CONFIG { \
      BOOT_MODE {Custom} \
      DDR_MEMORY_MODE {Connectivity to DDR via NOC} \
      IO_CONFIG_MODE {Custom} \
      PMC_QSPI_PERIPHERAL_ENABLE {1} \
      PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
      PMC_REF_CLK_FREQMHZ {33.333333} \
      PMC_SD0 {{CD_ENABLE 0} {CD_IO {PMC_MIO 24}} {POW_ENABLE 0} {POW_IO {PMC_MIO 17}} {RESET_ENABLE 1} {RESET_IO {PMC_MIO 49}} {WP_ENABLE 0} {WP_IO {PMC_MIO 25}}} \
      PMC_SD0_DATA_TRANSFER_MODE {8Bit} \
      PMC_SD0_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x00} {CLK_200_SDR_OTAP_DLY 0x2} {CLK_50_DDR_ITAP_DLY 0x1E} {CLK_50_DDR_OTAP_DLY 0x5} {CLK_50_SDR_ITAP_DLY 0x2C} {CLK_50_SDR_OTAP_DLY 0x5} {ENABLE 1} {IO\
{PMC_MIO 37 .. 49}}} \
      PMC_SD0_SLOT_TYPE {eMMC} \
      PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 0} {POW_IO {PMC_MIO 12}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 12}} {WP_ENABLE 0} {WP_IO {PMC_MIO 1}}} \
      PMC_SD1_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x00} {CLK_200_SDR_OTAP_DLY 0x00} {CLK_50_DDR_ITAP_DLY 0x00} {CLK_50_DDR_OTAP_DLY 0x00} {CLK_50_SDR_ITAP_DLY 0x2C} {CLK_50_SDR_OTAP_DLY 0x4} {ENABLE 1} {IO\
{PMC_MIO 26 .. 36}}} \
      PMC_USE_PMC_NOC_AXI0 {1} \
      PS_ENET0_MDIO {{ENABLE 1} {IO {PMC_MIO 50 .. 51}}} \
      PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 11}}} \
      PS_GEN_IPI0_ENABLE {1} \
      PS_GEN_IPI1_ENABLE {1} \
      PS_GEN_IPI2_ENABLE {1} \
      PS_GEN_IPI3_ENABLE {1} \
      PS_GEN_IPI4_ENABLE {1} \
      PS_GEN_IPI5_ENABLE {1} \
      PS_GEN_IPI6_ENABLE {1} \
      PS_GPIO_EMIO_PERIPHERAL_ENABLE {1} \
      PS_MIO24 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO25 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_NUM_FABRIC_RESETS {1} \
      PS_TTC0_PERIPHERAL_ENABLE {1} \
      PS_TTC1_PERIPHERAL_ENABLE {1} \
      PS_TTC2_PERIPHERAL_ENABLE {1} \
      PS_TTC3_PERIPHERAL_ENABLE {1} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 16 .. 17}}} \
      PS_USB3_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 13 .. 25}}} \
      PS_USE_FPD_CCI_NOC {1} \
      PS_USE_FPD_CCI_NOC0 {1} \
      PS_USE_NOC_LPD_AXI0 {1} \
      PS_USE_PMCPL_CLK0 {1} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
    } \
    CONFIG.PS_PMC_CONFIG_APPLIED {1} \
  ] $versal_cips_0


  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0 ]
  set_property -dict [list \
    CONFIG.CONTROLLERTYPE {DDR4_SDRAM} \
    CONFIG.MC_CASLATENCY {22} \
    CONFIG.MC_CHAN_REGION1 {NONE} \
    CONFIG.MC_COMPONENT_WIDTH {x16} \
    CONFIG.MC_ECC_SCRUB_SIZE {4096} \
    CONFIG.MC_F1_TFAW {30000} \
    CONFIG.MC_F1_TFAWMIN {30000} \
    CONFIG.MC_F1_TRCD {13750} \
    CONFIG.MC_F1_TRCDMIN {13750} \
    CONFIG.MC_F1_TRRD_L {11} \
    CONFIG.MC_F1_TRRD_L_MIN {11} \
    CONFIG.MC_F1_TRRD_S {9} \
    CONFIG.MC_F1_TRRD_S_MIN {9} \
    CONFIG.MC_INPUTCLK0_PERIOD {5000} \
    CONFIG.MC_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} \
    CONFIG.MC_SYSTEM_CLOCK {No_Buffer} \
    CONFIG.MC_TFAW {30000} \
    CONFIG.MC_TFAWMIN {30000} \
    CONFIG.MC_TRC {45750} \
    CONFIG.MC_TRCD {13750} \
    CONFIG.MC_TRCDMIN {13750} \
    CONFIG.MC_TRCMIN {45750} \
    CONFIG.MC_TRP {13750} \
    CONFIG.MC_TRPMIN {13750} \
    CONFIG.MC_TRRD_L {11} \
    CONFIG.MC_TRRD_L_MIN {11} \
    CONFIG.MC_TRRD_S {9} \
    CONFIG.MC_TRRD_S_MIN {9} \
    CONFIG.MC_USER_DEFINED_ADDRESS_MAP {16RA-2BA-1BG-10CA} \
    CONFIG.NUM_CLKS {8} \
    CONFIG.NUM_MC {1} \
    CONFIG.NUM_MCP {4} \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {7} \
  ] $axi_noc_0


  set_property -dict [ list \
   CONFIG.APERTURES {{0x201_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M00_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {M00_AXI {read_bw {5} write_bw {5}} MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {M00_AXI:0x40} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_1 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /axi_noc_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI:S06_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {} \
 ] [get_bd_pins /axi_noc_0/aclk7]

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]

  # Create instance: axil_ctrl_0, and set properties
  set block_name axil_ctrl
  set block_cell_name axil_ctrl_0
  if { [catch {set axil_ctrl_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axil_ctrl_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axil_ctrl_0_smc, and set properties
  set axil_ctrl_0_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axil_ctrl_0_smc ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axil_ctrl_0_smc


  # Create instance: rst_versal_cips_0_239M, and set properties
  set rst_versal_cips_0_239M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_versal_cips_0_239M ]

  # Create instance: mem_agent_maxi_0, and set properties
  set block_name mem_agent_maxi
  set block_cell_name mem_agent_maxi_0
  if { [catch {set mem_agent_maxi_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mem_agent_maxi_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_noc_0_CH0_DDR4_0 [get_bd_intf_ports DDR4] [get_bd_intf_pins axi_noc_0/CH0_DDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_M00_AXI [get_bd_intf_pins axil_ctrl_0_smc/S00_AXI] [get_bd_intf_pins axi_noc_0/M00_AXI]
  connect_bd_intf_net -intf_net axil_ctrl_0_smc_M00_AXI [get_bd_intf_pins axil_ctrl_0/S_AXI] [get_bd_intf_pins axil_ctrl_0_smc/M00_AXI]
  connect_bd_intf_net -intf_net mem_agent_maxi_0_M_AXI [get_bd_intf_pins mem_agent_maxi_0/M_AXI] [get_bd_intf_pins axi_noc_0/S06_AXI]
  connect_bd_intf_net -intf_net sys_clk_1 [get_bd_intf_ports sys_clk] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_0 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0] [get_bd_intf_pins axi_noc_0/S00_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_1 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1] [get_bd_intf_pins axi_noc_0/S01_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_2 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2] [get_bd_intf_pins axi_noc_0/S02_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_3 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3] [get_bd_intf_pins axi_noc_0/S03_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_LPD_AXI_NOC_0 [get_bd_intf_pins versal_cips_0/LPD_AXI_NOC_0] [get_bd_intf_pins axi_noc_0/S04_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_0 [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0] [get_bd_intf_pins axi_noc_0/S05_AXI]

  # Create port connections
  connect_bd_net -net axil_ctrl_0_rd_start0_out [get_bd_pins axil_ctrl_0/rd_start0_out] [get_bd_pins mem_agent_maxi_0/r_start_in]
  connect_bd_net -net axil_ctrl_0_wr_start0_out [get_bd_pins axil_ctrl_0/wr_start0_out] [get_bd_pins mem_agent_maxi_0/w_start_in]
  connect_bd_net -net axil_ctrl_0_wr_start15_out [get_bd_pins axil_ctrl_0/wr_start15_out] [get_bd_ports led]
  connect_bd_net -net mem_agent_maxi_0_b_bit_out [get_bd_pins mem_agent_maxi_0/b_bit_out] [get_bd_pins axil_ctrl_0/clinet1_in]
  connect_bd_net -net mem_agent_maxi_0_rd_bit_out [get_bd_pins mem_agent_maxi_0/rd_bit_out] [get_bd_pins axil_ctrl_0/clinet0_in]
  connect_bd_net -net mem_agent_maxi_0_rd_data_bp_out [get_bd_pins mem_agent_maxi_0/rd_data_bp_out] [get_bd_pins axil_ctrl_0/rd_data_bp_in]
  connect_bd_net -net mem_agent_maxi_0_rd_data_cnt_out [get_bd_pins mem_agent_maxi_0/rd_data_cnt_out] [get_bd_pins axil_ctrl_0/rd_data_cnt_in]
  connect_bd_net -net mem_agent_maxi_0_rd_latency_out [get_bd_pins mem_agent_maxi_0/rd_latency_out] [get_bd_pins axil_ctrl_0/rd_latency_in]
  connect_bd_net -net mem_agent_maxi_0_rd_req_bp_out [get_bd_pins mem_agent_maxi_0/rd_req_bp_out] [get_bd_pins axil_ctrl_0/rd_req_bp_in]
  connect_bd_net -net mem_agent_maxi_0_rd_req_cnt_out [get_bd_pins mem_agent_maxi_0/rd_req_cnt_out] [get_bd_pins axil_ctrl_0/rd_req_cnt_in]
  connect_bd_net -net mem_agent_maxi_0_timestamp_out [get_bd_pins mem_agent_maxi_0/timestamp_out] [get_bd_pins axil_ctrl_0/timestamp_in]
  connect_bd_net -net mem_agent_maxi_0_wr_data_bp_out [get_bd_pins mem_agent_maxi_0/wr_data_bp_out] [get_bd_pins axil_ctrl_0/wr_data_bp_in]
  connect_bd_net -net mem_agent_maxi_0_wr_data_cnt_out [get_bd_pins mem_agent_maxi_0/wr_data_cnt_out] [get_bd_pins axil_ctrl_0/wr_data_cnt_in]
  connect_bd_net -net mem_agent_maxi_0_wr_latency_out [get_bd_pins mem_agent_maxi_0/wr_latency_out] [get_bd_pins axil_ctrl_0/wr_latency_in]
  connect_bd_net -net mem_agent_maxi_0_wr_req_bp_out [get_bd_pins mem_agent_maxi_0/wr_req_bp_out] [get_bd_pins axil_ctrl_0/wr_req_bp_in]
  connect_bd_net -net mem_agent_maxi_0_wr_req_cnt_out [get_bd_pins mem_agent_maxi_0/wr_req_cnt_out] [get_bd_pins axil_ctrl_0/wr_req_cnt_in]
  connect_bd_net -net rst_versal_cips_0_239M_peripheral_aresetn [get_bd_pins rst_versal_cips_0_239M/peripheral_aresetn] [get_bd_pins axil_ctrl_0/S_AXI_ARESETN] [get_bd_pins axil_ctrl_0_smc/aresetn] [get_bd_pins mem_agent_maxi_0/ARESETN]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins axi_noc_0/sys_clk0]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi0_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk0]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi1_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk] [get_bd_pins axi_noc_0/aclk1]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi2_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk] [get_bd_pins axi_noc_0/aclk2]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi3_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk] [get_bd_pins axi_noc_0/aclk3]
  connect_bd_net -net versal_cips_0_lpd_axi_noc_clk [get_bd_pins versal_cips_0/lpd_axi_noc_clk] [get_bd_pins axi_noc_0/aclk4]
  connect_bd_net -net versal_cips_0_pl0_ref_clk [get_bd_pins versal_cips_0/pl0_ref_clk] [get_bd_pins axil_ctrl_0/S_AXI_ACLK] [get_bd_pins axi_noc_0/aclk7] [get_bd_pins rst_versal_cips_0_239M/slowest_sync_clk] [get_bd_pins axil_ctrl_0_smc/aclk] [get_bd_pins mem_agent_maxi_0/ACLK] [get_bd_pins axi_noc_0/aclk6]
  connect_bd_net -net versal_cips_0_pl0_resetn [get_bd_pins versal_cips_0/pl0_resetn] [get_bd_pins rst_versal_cips_0_239M/ext_reset_in]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi0_clk [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk5]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins axil_ctrl_0/clinet2_in] [get_bd_pins axil_ctrl_0/clinet3_in] [get_bd_pins axil_ctrl_0/clinet4_in] [get_bd_pins axil_ctrl_0/clinet5_in] [get_bd_pins axil_ctrl_0/clinet6_in] [get_bd_pins axil_ctrl_0/clinet7_in] [get_bd_pins axil_ctrl_0/clinet8_in] [get_bd_pins axil_ctrl_0/clinet9_in] [get_bd_pins axil_ctrl_0/clinet10_in] [get_bd_pins axil_ctrl_0/clinet11_in] [get_bd_pins axil_ctrl_0/clinet12_in] [get_bd_pins axil_ctrl_0/clinet13_in] [get_bd_pins axil_ctrl_0/clinet14_in] [get_bd_pins axil_ctrl_0/clinet15_in] [get_bd_pins axil_ctrl_0/clinet16_in] [get_bd_pins axil_ctrl_0/clinet17_in] [get_bd_pins axil_ctrl_0/clinet18_in] [get_bd_pins axil_ctrl_0/clinet19_in] [get_bd_pins axil_ctrl_0/clinet20_in] [get_bd_pins axil_ctrl_0/clinet21_in] [get_bd_pins axil_ctrl_0/clinet22_in] [get_bd_pins axil_ctrl_0/clinet23_in] [get_bd_pins axil_ctrl_0/clinet24_in] [get_bd_pins axil_ctrl_0/clinet25_in] [get_bd_pins axil_ctrl_0/clinet26_in] [get_bd_pins axil_ctrl_0/clinet27_in] [get_bd_pins axil_ctrl_0/clinet28_in] [get_bd_pins axil_ctrl_0/clinet29_in] [get_bd_pins axil_ctrl_0/clinet30_in] [get_bd_pins axil_ctrl_0/clinet31_in]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axi_noc_0/S00_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axil_ctrl_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs axi_noc_0/S01_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs axi_noc_0/S02_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs axi_noc_0/S03_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S04_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs axi_noc_0/S05_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces mem_agent_maxi_0/M_AXI] [get_bd_addr_segs axi_noc_0/S06_AXI/C0_DDR_LOW0] -force


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


