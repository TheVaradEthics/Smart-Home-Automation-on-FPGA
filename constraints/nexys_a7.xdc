# constraints/nexys_a7.xdc
set_property PACKAGE_PIN W5 [get_ports clk_50m]
set_property IOSTANDARD LVCMOS33 [get_ports clk_50m]
set_property PACKAGE_PIN U18 [get_ports rst_btn]
set_property IOSTANDARD LVCMOS33 [get_ports rst_btn]

# Sensor Inputs (Switches)
set_property PACKAGE_PIN V17 [get_ports pir_raw]
set_property PACKAGE_PIN V16 [get_ports ldr_dark_raw]
set_property PACKAGE_PIN W16 [get_ports overcur_raw]

# Outputs (LEDs)
set_property PACKAGE_PIN U16 [get_ports ALARM_LED]
set_property PACKAGE_PIN E19 [get_ports L0_PWM]