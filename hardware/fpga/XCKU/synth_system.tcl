set TOP [lindex $argv 0]
set PART xcku040-fbva676-1-c

set VSRC [lindex $argv 1]
set HW_INCLUDE [lindex $argv 2]
set HW_DEFINE [lindex $argv 3]

puts $VSRC

#verilog sources
foreach file [split $VSRC \ ] {
    puts $file
    if {$file != "" && $file != " " && $file != "\n"} {
        read_verilog -sv $file
    }
}

set_property part $PART [current_project]

synth_design -include_dirs $HW_INCLUDE -verilog_define $HW_DEFINE -part $PART -top $TOP -mode out_of_context -flatten_hierarchy none -verbose

read_xdc ./synth_system.xdc

opt_design
place_design
route_design

report_utilization
report_timing

write_edif -force $TOP.edif
set TOP_STUB $TOP
append TOP_STUB "_stub"
write_verilog -force -mode synth_stub $TOP_STUB.v
