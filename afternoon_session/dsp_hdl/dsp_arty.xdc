# Digilent Arty A7-35T constraints for the DSP HDL filter demo
# Ports: clk, reset, sw0, sw1, sw2, led[3:0], rgb[2:0]

## 100 MHz system clock
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

## Reset: push button BTN0 (active high)
set_property PACKAGE_PIN D9 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## Slide switches SW0, SW1, SW2
set_property PACKAGE_PIN A8  [get_ports sw0]
set_property PACKAGE_PIN C11 [get_ports sw1]
set_property PACKAGE_PIN C10 [get_ports sw2]

## Green LEDs LD4..LD7 -> level bar led[3:0]
set_property PACKAGE_PIN H5  [get_ports {led[0]}]
set_property PACKAGE_PIN J5  [get_ports {led[1]}]
set_property PACKAGE_PIN T9  [get_ports {led[2]}]
set_property PACKAGE_PIN T10 [get_ports {led[3]}]

## RGB LED LD0 -> filter-mode colour  (rgb[0]=blue, rgb[1]=green, rgb[2]=red)
set_property PACKAGE_PIN E1 [get_ports {rgb[0]}]
set_property PACKAGE_PIN F6 [get_ports {rgb[1]}]
set_property PACKAGE_PIN G6 [get_ports {rgb[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {sw0 sw1 sw2}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[*]}]
