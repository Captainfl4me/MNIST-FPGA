onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/reset
add wave -noupdate /testbench/clock
add wave -noupdate /testbench/clkimg
add wave -noupdate /testbench/start
add wave -noupdate /testbench/ready
add wave -noupdate /testbench/image
add wave -noupdate /testbench/DP/pixelin
add wave -noupdate /testbench/DP/pixelin2
add wave -noupdate /testbench/labl
add wave -noupdate /testbench/labl1
add wave -noupdate /testbench/labl2
add wave -noupdate /testbench/labl3
add wave -noupdate /testbench/labl4
add wave -noupdate /testbench/labl5
add wave -noupdate /testbench/valid
add wave -noupdate /testbench/DP/cur_state_m1
add wave -noupdate /testbench/DP/cur_state_m2
add wave -noupdate /testbench/DP/pixel_index
add wave -noupdate /testbench/DP/pixel_index2
add wave -noupdate /testbench/DP/neuron_index
add wave -noupdate /testbench/DP/mult1
add wave -noupdate /testbench/DP/add1
add wave -noupdate /testbench/DP/activf1
add wave -noupdate /testbench/DP/activf1_L
add wave -noupdate /testbench/DP/add2
add wave -noupdate /testbench/DP/mult2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {163950000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 191
configure wave -valuecolwidth 176
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {628643 ps}
