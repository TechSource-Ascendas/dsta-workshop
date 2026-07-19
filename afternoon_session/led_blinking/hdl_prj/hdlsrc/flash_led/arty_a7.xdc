# Digilent Arty A7-35T constraints for flash_led_top (clk, reset, led[7:0])
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

# reset : push button BTN0 (active high)
set_property PACKAGE_PIN D9 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# led[3:0] -> green LEDs LD4..LD7 ; led[7:4] -> green channel of RGB LEDs LD0..LD3
set_property PACKAGE_PIN H5  [get_ports {led[0]}]
set_property PACKAGE_PIN J5  [get_ports {led[1]}]
set_property PACKAGE_PIN T9  [get_ports {led[2]}]
set_property PACKAGE_PIN T10 [get_ports {led[3]}]
set_property PACKAGE_PIN F6  [get_ports {led[4]}]
set_property PACKAGE_PIN J4  [get_ports {led[5]}]
set_property PACKAGE_PIN J2  [get_ports {led[6]}]
set_property PACKAGE_PIN H6  [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
