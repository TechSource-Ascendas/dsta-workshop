@echo off
setlocal
set VIV=C:\Xilinx\Vivado\2024.1\bin
cd /d %~dp0
if exist xsim.dir rmdir /s /q xsim.dir
call "%VIV%\xvhdl.bat" --2008 fft8_pkg.vhd fft8.vhd fft8_tb.vhd
if errorlevel 1 exit /b 1
call "%VIV%\xelab.bat" -debug typical work.fft8_tb -s fft8_sim
if errorlevel 1 exit /b 1
call "%VIV%\xsim.bat" fft8_sim -R
