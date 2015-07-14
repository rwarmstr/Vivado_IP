# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_CLK_FREQ_HZ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_PWM_PERIOD_US" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_CLK_FREQ_HZ { PARAM_VALUE.C_CLK_FREQ_HZ } {
	# Procedure called to update C_CLK_FREQ_HZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_CLK_FREQ_HZ { PARAM_VALUE.C_CLK_FREQ_HZ } {
	# Procedure called to validate C_CLK_FREQ_HZ
	return true
}

proc update_PARAM_VALUE.C_PWM_PERIOD_US { PARAM_VALUE.C_PWM_PERIOD_US } {
	# Procedure called to update C_PWM_PERIOD_US when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_PWM_PERIOD_US { PARAM_VALUE.C_PWM_PERIOD_US } {
	# Procedure called to validate C_PWM_PERIOD_US
	return true
}


proc update_MODELPARAM_VALUE.C_CLK_FREQ_HZ { MODELPARAM_VALUE.C_CLK_FREQ_HZ PARAM_VALUE.C_CLK_FREQ_HZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_CLK_FREQ_HZ}] ${MODELPARAM_VALUE.C_CLK_FREQ_HZ}
}

proc update_MODELPARAM_VALUE.C_PWM_PERIOD_US { MODELPARAM_VALUE.C_PWM_PERIOD_US PARAM_VALUE.C_PWM_PERIOD_US } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PWM_PERIOD_US}] ${MODELPARAM_VALUE.C_PWM_PERIOD_US}
}

