create_project vivado_sim -part xc7a200tfbg676-2 -force
add_files -fileset sim_1 -norecurse ./Complex4Multiply.vhd
add_files -fileset sim_1 -norecurse ./FFT.vhd
add_files -fileset sim_1 -norecurse ./RADIX22FFT_CTRL1_1.vhd
add_files -fileset sim_1 -norecurse ./RADIX22FFT_CTRL1_1_block.vhd
add_files -fileset sim_1 -norecurse ./RADIX22FFT_CTRL1_2.vhd
add_files -fileset sim_1 -norecurse ./RADIX22FFT_SDF1_1.vhd
add_files -fileset sim_1 -norecurse ./RADIX22FFT_SDF1_3.vhd
add_files -fileset sim_1 -norecurse ./RADIX22FFT_SDF2_2.vhd
add_files -fileset sim_1 -norecurse ./RADIX2FFT_bitNatural.vhd
add_files -fileset sim_1 -norecurse ./SDFCommutator1.vhd
add_files -fileset sim_1 -norecurse ./SDFCommutator2.vhd
add_files -fileset sim_1 -norecurse ./SDFCommutator3.vhd
add_files -fileset sim_1 -norecurse ./SimpleDualPortRAM_generic.vhd
add_files -fileset sim_1 -norecurse ./TWDLROM_3_1.vhd
add_files -fileset sim_1 -norecurse ./fft8_dut.vhd
add_files -fileset sim_1 -norecurse ./fft8_dut_pkg.vhd
add_files -fileset sim_1 -norecurse ./fft8_dut_tb.vhd
add_files -fileset sim_1 -norecurse ./fft8_dut_tb_pkg.vhd
add_files -fileset sim_1 -norecurse ./Complex4Multiply.v
add_files -fileset sim_1 -norecurse ./FFT.v
add_files -fileset sim_1 -norecurse ./RADIX22FFT_CTRL1_1.v
add_files -fileset sim_1 -norecurse ./RADIX22FFT_CTRL1_1_block.v
add_files -fileset sim_1 -norecurse ./RADIX22FFT_CTRL1_2.v
add_files -fileset sim_1 -norecurse ./RADIX22FFT_SDF1_1.v
add_files -fileset sim_1 -norecurse ./RADIX22FFT_SDF1_3.v
add_files -fileset sim_1 -norecurse ./RADIX22FFT_SDF2_2.v
add_files -fileset sim_1 -norecurse ./RADIX2FFT_bitNatural.v
add_files -fileset sim_1 -norecurse ./SDFCommutator1.v
add_files -fileset sim_1 -norecurse ./SDFCommutator2.v
add_files -fileset sim_1 -norecurse ./SDFCommutator3.v
add_files -fileset sim_1 -norecurse ./SimpleDualPortRAM_generic.v
add_files -fileset sim_1 -norecurse ./TWDLROM_3_1.v
add_files -fileset sim_1 -norecurse ./fft8_dut.v
add_files -fileset sim_1 -norecurse ./fft8_dut_tb.v
add_files -fileset sim_1 -norecurse ./dataIn.dat
add_files -fileset sim_1 -norecurse ./dataIn_re.dat
add_files -fileset sim_1 -norecurse ./dataOut_re_expected.dat
add_files -fileset sim_1 -norecurse ./validIn.dat
add_files -fileset sim_1 -norecurse ./validOut_expected.dat
update_compile_order -fileset sim_1
launch_simulation
set_property -name {xsim.simulate.runtime} -value {} -objects [get_filesets sim_1]
run all
