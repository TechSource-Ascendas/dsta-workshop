@echo off
setlocal
set VIV=C:\Xilinx\Vivado\2024.1\bin
cd /d %~dp0
if exist xsim.dir rmdir /s /q xsim.dir
call "%VIV%\xvhdl.bat" --2008 ^
  fft8_dut_pkg.vhd SimpleDualPortRAM_generic.vhd SDFCommutator1.vhd RADIX22FFT_SDF1_1.vhd ^
  RADIX22FFT_CTRL1_1.vhd SDFCommutator2.vhd RADIX22FFT_SDF2_2.vhd RADIX22FFT_CTRL1_2.vhd ^
  TWDLROM_3_1.vhd Complex4Multiply.vhd SDFCommutator3.vhd RADIX22FFT_SDF1_3.vhd ^
  RADIX22FFT_CTRL1_1_block.vhd RADIX2FFT_bitNatural.vhd FFT.vhd fft8_dut.vhd ^
  fft8_dut_tb_pkg.vhd fft8_dut_tb.vhd
if errorlevel 1 exit /b 1
call "%VIV%\xelab.bat" -debug typical work.fft8_dut_tb -s fft8gen_sim
if errorlevel 1 exit /b 1
call "%VIV%\xsim.bat" fft8gen_sim -R
