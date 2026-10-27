#############################################################################
# build_bitstream.tcl - one-command build: project -> synth -> impl -> .bit
#   vivado -mode batch -source build_bitstream.tcl
# Output: ./stopwatch_top.bit  (program it from Hardware Manager)
#############################################################################
source ./build.tcl

launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    error "Synthesis failed"
}

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    error "Implementation failed"
}

open_run impl_1
report_timing_summary -file ./timing_summary.rpt
report_utilization    -file ./utilization.rpt

file copy -force ./stopwatch_proj/stopwatch.runs/impl_1/stopwatch_top.bit ./stopwatch_top.bit
puts "Bitstream ready: ./stopwatch_top.bit"
