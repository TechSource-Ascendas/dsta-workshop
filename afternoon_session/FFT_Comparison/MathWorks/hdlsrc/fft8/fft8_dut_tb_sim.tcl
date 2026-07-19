exec xelab -debug typical -top fft8_dut_tb -snapshot fft8_dut_tb_snapshot
exec xsim -tclbatch simulation.tcl fft8_dut_tb_snapshot
source xsim.dir/fft8_dut_tb_snapshot/xsim_script.tcl
