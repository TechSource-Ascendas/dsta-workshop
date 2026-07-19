# HDL Coder Downstream Integration Tcl Script

set myTool "Xilinx Vivado 2024.1"
set myProject "flash_led_top_vivado"
set myProjectFile "flash_led_top_vivado.xpr"
set myTopLevelEntity "flash_led_top"
set Family "Artix7"
set Device "xc7a35ti"
set Package "csg324"
set Speed "-1L"
set MapTimePathNumber "3"
set MapTimeAdvAnalysis "True"
set PARTimePathNumber "3"
set PARTimeAdvAnalysis "True"

# Open existing project
puts "### Open existing $myTool project hdl_prj\\vivado_prj\\flash_led_top_vivado.xpr"
open_project ${myProject}

puts "### Run custom Tcl files"
# Runs during the HDL Workflow Advisor "Create Project" task.
# Adds the Arty A7 board adapter and pin constraints to the Vivado project
# and makes the adapter the top-level module.
set board_dir "C:/demo/hdl_coder_led_blinking/board"
add_files -norecurse "$board_dir/arty_top.vhd"
add_files -fileset constrs_1 "$board_dir/arty_a7.xdc"
set_property top arty_top [current_fileset]
update_compile_order -fileset sources_1
# HDL Coder creates the synthesis run in out-of-context mode (module analysis, no
# I/O buffers). Clear it so the full design with pin mapping can be implemented.
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {} -objects [get_runs synth_1]

# Close project
puts "### Close $myTool project."
close_project

