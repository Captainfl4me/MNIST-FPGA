onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/reset
add wave -noupdate /testbench/clock
add wave -noupdate /testbench/clkimg
add wave -noupdate /testbench/start
add wave -noupdate /testbench/ready
add wave -noupdate /testbench/image
add wave -noupdate /testbench/labout
add wave -noupdate /testbench/labout2
add wave -noupdate /testbench/valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {104344 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {3187249 ps}
