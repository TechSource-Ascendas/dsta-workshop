# Digilent Arty A7-35T: board clock and reset for the reference design.
# The DUT I/O pins (LEDs, buttons, switches) are NOT listed here - HDL Coder
# generates their constraints from the board definition when DUT ports are
# mapped to board interfaces in the Set Target Interface task.

## 100 MHz board clock
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name clk -period 10.00 -waveform {0 5} [get_ports { clk }];

## Reset: push button BTN0, active high
set_property PACKAGE_PIN D9 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
