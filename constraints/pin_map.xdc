##Clock signal
set_property PACKAGE_PIN N18 [get_ports clk_40Mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_40Mhz]
create_clock -period 25.000 -name clk_40mhz [get_ports clk_40Mhz]

############################################################
## HDMI TMDS OUTPUT
############################################################
# Clock TMDS
set_property PACKAGE_PIN H16 [get_ports TMDS_CLK_P]
set_property PACKAGE_PIN H17 [get_ports TMDS_CLK_N]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_CLK_P TMDS_CLK_N}]

# Lane 0: HDMI_D0
set_property PACKAGE_PIN F19 [get_ports TMDS_DATA_P[0]]
set_property PACKAGE_PIN F20 [get_ports TMDS_DATA_N[0]]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_DATA_P[0] TMDS_DATA_N[0]}]

# Lane 1: HDMI_D1 
set_property PACKAGE_PIN C20 [get_ports  TMDS_DATA_P[1]]
set_property PACKAGE_PIN B20 [get_ports  TMDS_DATA_N[1]]
set_property IOSTANDARD TMDS_33 [get_ports { TMDS_DATA_P[1]  TMDS_DATA_N[1]}]

# Lane 2: HDMI_D2
set_property PACKAGE_PIN B19 [get_ports TMDS_DATA_P[2]]
set_property PACKAGE_PIN A20 [get_ports TMDS_DATA_N[2]]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_DATA_P[2] TMDS_DATA_N[2]}]

# HPD va I2C HDMI (Chưa dùng)
#set_property PACKAGE_PIN D19 [get_ports hdmi_scl]
#set_property IOSTANDARD LVCMOS33 [get_ports hdmi_scl]
#set_property PACKAGE_PIN D18 [get_ports hdmi_sda]
#set_property IOSTANDARD LVCMOS33 [get_ports hdmi_sda]

############################################################
## SYSTEM CONTROL & LED
############################################################
set_property PACKAGE_PIN U19 [get_ports resetn]
set_property IOSTANDARD LVCMOS33 [get_ports resetn]

set_property PACKAGE_PIN V20 [get_ports locked_led]
set_property IOSTANDARD LVCMOS33 [get_ports locked_led]

set_property PACKAGE_PIN T19 [get_ports clk_1hz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_1hz]

############################################################
## ROTARY ENCODER INPUTS
############################################################
set_property PACKAGE_PIN U20 [get_ports A] 
set_property IOSTANDARD LVCMOS33 [get_ports A]

set_property PACKAGE_PIN T20 [get_ports B]
set_property IOSTANDARD LVCMOS33 [get_ports B]

############################################################
## AUDIO DAC CS4344 (I2S INTERFACE)
############################################################
set_property PACKAGE_PIN E19 [get_ports buzzer]
set_property IOSTANDARD LVCMOS33 [get_ports buzzer]

