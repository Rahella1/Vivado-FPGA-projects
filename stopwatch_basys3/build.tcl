#############################################################################
# build.tcl - creates the Vivado project.
#   vivado -mode batch -source build.tcl
# Then open stopwatch_proj/stopwatch.xpr in the GUI, or run build_bitstream.tcl
#############################################################################
set proj_name "stopwatch"
set proj_dir  "./stopwatch_proj"
set part      "xc7a35tcpg236-1"      ;# Basys3

create_project $proj_name $proj_dir -part $part -force

add_files -norecurse [glob ./src/*.v]
add_files -fileset sim_1 -norecurse [glob ./sim/*.v]
add_files -fileset constrs_1 -norecurse ./constraints/basys3_stopwatch.xdc

set_property top stopwatch_top [current_fileset]
set_property top tb_stopwatch_core [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "Project created: ${proj_dir}/${proj_name}.xpr"
