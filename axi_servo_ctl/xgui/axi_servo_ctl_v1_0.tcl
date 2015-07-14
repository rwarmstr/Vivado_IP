# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_CLK_FREQ_HZ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_DUTY_MAX_US" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_DUTY_MIN_US" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_NUM_SERVOS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_PERIOD_US" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_AXI_ADDR_WIDTH { PARAM_VALUE.C_AXI_ADDR_WIDTH } {
	# Procedure called to update C_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_ADDR_WIDTH { PARAM_VALUE.C_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_DATA_WIDTH { PARAM_VALUE.C_AXI_DATA_WIDTH } {
	# Procedure called to update C_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_DATA_WIDTH { PARAM_VALUE.C_AXI_DATA_WIDTH } {
	# Procedure called to validate C_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_CLK_FREQ_HZ { PARAM_VALUE.C_CLK_FREQ_HZ } {
	# Procedure called to update C_CLK_FREQ_HZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_CLK_FREQ_HZ { PARAM_VALUE.C_CLK_FREQ_HZ } {
	# Procedure called to validate C_CLK_FREQ_HZ
	return true
}

proc update_PARAM_VALUE.C_DUTY_MAX_US { PARAM_VALUE.C_DUTY_MAX_US } {
	# Procedure called to update C_DUTY_MAX_US when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DUTY_MAX_US { PARAM_VALUE.C_DUTY_MAX_US } {
	# Procedure called to validate C_DUTY_MAX_US
	return true
}

proc update_PARAM_VALUE.C_DUTY_MIN_US { PARAM_VALUE.C_DUTY_MIN_US } {
	# Procedure called to update C_DUTY_MIN_US when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DUTY_MIN_US { PARAM_VALUE.C_DUTY_MIN_US } {
	# Procedure called to validate C_DUTY_MIN_US
	return true
}

proc update_PARAM_VALUE.C_NUM_SERVOS { PARAM_VALUE.C_NUM_SERVOS } {
	# Procedure called to update C_NUM_SERVOS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_NUM_SERVOS { PARAM_VALUE.C_NUM_SERVOS } {
	# Procedure called to validate C_NUM_SERVOS
	return true
}

proc update_PARAM_VALUE.C_PERIOD_US { PARAM_VALUE.C_PERIOD_US } {
	# Procedure called to update C_PERIOD_US when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_PERIOD_US { PARAM_VALUE.C_PERIOD_US } {
	# Procedure called to validate C_PERIOD_US
	return true
}


proc update_MODELPARAM_VALUE.C_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_AXI_DATA_WIDTH PARAM_VALUE.C_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_CLK_FREQ_HZ { MODELPARAM_VALUE.C_CLK_FREQ_HZ PARAM_VALUE.C_CLK_FREQ_HZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_CLK_FREQ_HZ}] ${MODELPARAM_VALUE.C_CLK_FREQ_HZ}
}

proc update_MODELPARAM_VALUE.C_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_AXI_ADDR_WIDTH PARAM_VALUE.C_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_NUM_SERVOS { MODELPARAM_VALUE.C_NUM_SERVOS PARAM_VALUE.C_NUM_SERVOS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_NUM_SERVOS}] ${MODELPARAM_VALUE.C_NUM_SERVOS}
}

proc update_MODELPARAM_VALUE.C_PERIOD_US { MODELPARAM_VALUE.C_PERIOD_US PARAM_VALUE.C_PERIOD_US } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PERIOD_US}] ${MODELPARAM_VALUE.C_PERIOD_US}
}

proc update_MODELPARAM_VALUE.C_DUTY_MIN_US { MODELPARAM_VALUE.C_DUTY_MIN_US PARAM_VALUE.C_DUTY_MIN_US } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DUTY_MIN_US}] ${MODELPARAM_VALUE.C_DUTY_MIN_US}
}

proc update_MODELPARAM_VALUE.C_DUTY_MAX_US { MODELPARAM_VALUE.C_DUTY_MAX_US PARAM_VALUE.C_DUTY_MAX_US } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DUTY_MAX_US}] ${MODELPARAM_VALUE.C_DUTY_MAX_US}
}

