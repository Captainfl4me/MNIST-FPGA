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
add wave -noupdate -radix sfixed -childformat {{/testbench/DP/mult1(0) -radix sfixed} {/testbench/DP/mult1(1) -radix sfixed} {/testbench/DP/mult1(2) -radix sfixed} {/testbench/DP/mult1(3) -radix sfixed} {/testbench/DP/mult1(4) -radix sfixed} {/testbench/DP/mult1(5) -radix sfixed} {/testbench/DP/mult1(6) -radix sfixed} {/testbench/DP/mult1(7) -radix sfixed} {/testbench/DP/mult1(8) -radix sfixed} {/testbench/DP/mult1(9) -radix sfixed} {/testbench/DP/mult1(10) -radix sfixed} {/testbench/DP/mult1(11) -radix sfixed} {/testbench/DP/mult1(12) -radix sfixed} {/testbench/DP/mult1(13) -radix sfixed} {/testbench/DP/mult1(14) -radix sfixed} {/testbench/DP/mult1(15) -radix sfixed} {/testbench/DP/mult1(16) -radix sfixed} {/testbench/DP/mult1(17) -radix sfixed} {/testbench/DP/mult1(18) -radix sfixed} {/testbench/DP/mult1(19) -radix sfixed} {/testbench/DP/mult1(20) -radix sfixed} {/testbench/DP/mult1(21) -radix sfixed} {/testbench/DP/mult1(22) -radix sfixed} {/testbench/DP/mult1(23) -radix sfixed} {/testbench/DP/mult1(24) -radix sfixed} {/testbench/DP/mult1(25) -radix sfixed} {/testbench/DP/mult1(26) -radix sfixed} {/testbench/DP/mult1(27) -radix sfixed} {/testbench/DP/mult1(28) -radix sfixed} {/testbench/DP/mult1(29) -radix sfixed} {/testbench/DP/mult1(30) -radix sfixed} {/testbench/DP/mult1(31) -radix sfixed} {/testbench/DP/mult1(32) -radix sfixed} {/testbench/DP/mult1(33) -radix sfixed} {/testbench/DP/mult1(34) -radix sfixed} {/testbench/DP/mult1(35) -radix sfixed} {/testbench/DP/mult1(36) -radix sfixed} {/testbench/DP/mult1(37) -radix sfixed} {/testbench/DP/mult1(38) -radix sfixed} {/testbench/DP/mult1(39) -radix sfixed} {/testbench/DP/mult1(40) -radix sfixed} {/testbench/DP/mult1(41) -radix sfixed} {/testbench/DP/mult1(42) -radix sfixed} {/testbench/DP/mult1(43) -radix sfixed} {/testbench/DP/mult1(44) -radix sfixed} {/testbench/DP/mult1(45) -radix sfixed} {/testbench/DP/mult1(46) -radix sfixed} {/testbench/DP/mult1(47) -radix sfixed} {/testbench/DP/mult1(48) -radix sfixed} {/testbench/DP/mult1(49) -radix sfixed} {/testbench/DP/mult1(50) -radix sfixed} {/testbench/DP/mult1(51) -radix sfixed} {/testbench/DP/mult1(52) -radix sfixed} {/testbench/DP/mult1(53) -radix sfixed} {/testbench/DP/mult1(54) -radix sfixed} {/testbench/DP/mult1(55) -radix sfixed} {/testbench/DP/mult1(56) -radix sfixed} {/testbench/DP/mult1(57) -radix sfixed} {/testbench/DP/mult1(58) -radix sfixed} {/testbench/DP/mult1(59) -radix sfixed} {/testbench/DP/mult1(60) -radix sfixed} {/testbench/DP/mult1(61) -radix sfixed} {/testbench/DP/mult1(62) -radix sfixed} {/testbench/DP/mult1(63) -radix sfixed} {/testbench/DP/mult1(64) -radix sfixed} {/testbench/DP/mult1(65) -radix sfixed} {/testbench/DP/mult1(66) -radix sfixed} {/testbench/DP/mult1(67) -radix sfixed} {/testbench/DP/mult1(68) -radix sfixed} {/testbench/DP/mult1(69) -radix sfixed}} -subitemconfig {/testbench/DP/mult1(0) {-height 16 -radix sfixed} /testbench/DP/mult1(1) {-height 16 -radix sfixed} /testbench/DP/mult1(2) {-height 16 -radix sfixed} /testbench/DP/mult1(3) {-height 16 -radix sfixed} /testbench/DP/mult1(4) {-height 16 -radix sfixed} /testbench/DP/mult1(5) {-height 16 -radix sfixed} /testbench/DP/mult1(6) {-height 16 -radix sfixed} /testbench/DP/mult1(7) {-height 16 -radix sfixed} /testbench/DP/mult1(8) {-height 16 -radix sfixed} /testbench/DP/mult1(9) {-height 16 -radix sfixed} /testbench/DP/mult1(10) {-height 16 -radix sfixed} /testbench/DP/mult1(11) {-height 16 -radix sfixed} /testbench/DP/mult1(12) {-height 16 -radix sfixed} /testbench/DP/mult1(13) {-height 16 -radix sfixed} /testbench/DP/mult1(14) {-height 16 -radix sfixed} /testbench/DP/mult1(15) {-height 16 -radix sfixed} /testbench/DP/mult1(16) {-height 16 -radix sfixed} /testbench/DP/mult1(17) {-height 16 -radix sfixed} /testbench/DP/mult1(18) {-height 16 -radix sfixed} /testbench/DP/mult1(19) {-height 16 -radix sfixed} /testbench/DP/mult1(20) {-height 16 -radix sfixed} /testbench/DP/mult1(21) {-height 16 -radix sfixed} /testbench/DP/mult1(22) {-height 16 -radix sfixed} /testbench/DP/mult1(23) {-height 16 -radix sfixed} /testbench/DP/mult1(24) {-height 16 -radix sfixed} /testbench/DP/mult1(25) {-height 16 -radix sfixed} /testbench/DP/mult1(26) {-height 16 -radix sfixed} /testbench/DP/mult1(27) {-height 16 -radix sfixed} /testbench/DP/mult1(28) {-height 16 -radix sfixed} /testbench/DP/mult1(29) {-height 16 -radix sfixed} /testbench/DP/mult1(30) {-height 16 -radix sfixed} /testbench/DP/mult1(31) {-height 16 -radix sfixed} /testbench/DP/mult1(32) {-height 16 -radix sfixed} /testbench/DP/mult1(33) {-height 16 -radix sfixed} /testbench/DP/mult1(34) {-height 16 -radix sfixed} /testbench/DP/mult1(35) {-height 16 -radix sfixed} /testbench/DP/mult1(36) {-height 16 -radix sfixed} /testbench/DP/mult1(37) {-height 16 -radix sfixed} /testbench/DP/mult1(38) {-height 16 -radix sfixed} /testbench/DP/mult1(39) {-height 16 -radix sfixed} /testbench/DP/mult1(40) {-height 16 -radix sfixed} /testbench/DP/mult1(41) {-height 16 -radix sfixed} /testbench/DP/mult1(42) {-height 16 -radix sfixed} /testbench/DP/mult1(43) {-height 16 -radix sfixed} /testbench/DP/mult1(44) {-height 16 -radix sfixed} /testbench/DP/mult1(45) {-height 16 -radix sfixed} /testbench/DP/mult1(46) {-height 16 -radix sfixed} /testbench/DP/mult1(47) {-height 16 -radix sfixed} /testbench/DP/mult1(48) {-height 16 -radix sfixed} /testbench/DP/mult1(49) {-height 16 -radix sfixed} /testbench/DP/mult1(50) {-height 16 -radix sfixed} /testbench/DP/mult1(51) {-height 16 -radix sfixed} /testbench/DP/mult1(52) {-height 16 -radix sfixed} /testbench/DP/mult1(53) {-height 16 -radix sfixed} /testbench/DP/mult1(54) {-height 16 -radix sfixed} /testbench/DP/mult1(55) {-height 16 -radix sfixed} /testbench/DP/mult1(56) {-height 16 -radix sfixed} /testbench/DP/mult1(57) {-height 16 -radix sfixed} /testbench/DP/mult1(58) {-height 16 -radix sfixed} /testbench/DP/mult1(59) {-height 16 -radix sfixed} /testbench/DP/mult1(60) {-height 16 -radix sfixed} /testbench/DP/mult1(61) {-height 16 -radix sfixed} /testbench/DP/mult1(62) {-height 16 -radix sfixed} /testbench/DP/mult1(63) {-height 16 -radix sfixed} /testbench/DP/mult1(64) {-height 16 -radix sfixed} /testbench/DP/mult1(65) {-height 16 -radix sfixed} /testbench/DP/mult1(66) {-height 16 -radix sfixed} /testbench/DP/mult1(67) {-height 16 -radix sfixed} /testbench/DP/mult1(68) {-height 16 -radix sfixed} /testbench/DP/mult1(69) {-height 16 -radix sfixed}} /testbench/DP/mult1
add wave -noupdate -radix sfixed /testbench/DP/add1
add wave -noupdate -radix sfixed /testbench/DP/add_with_bias
add wave -noupdate -radix sfixed /testbench/DP/activf1
add wave -noupdate -radix sfixed /testbench/DP/activf1_L
add wave -noupdate -radix sfixed /testbench/DP/mult2
add wave -noupdate -radix sfixed -childformat {{/testbench/DP/add2(0) -radix sfixed} {/testbench/DP/add2(1) -radix sfixed} {/testbench/DP/add2(2) -radix sfixed} {/testbench/DP/add2(3) -radix sfixed} {/testbench/DP/add2(4) -radix sfixed} {/testbench/DP/add2(5) -radix sfixed} {/testbench/DP/add2(6) -radix sfixed} {/testbench/DP/add2(7) -radix sfixed} {/testbench/DP/add2(8) -radix sfixed} {/testbench/DP/add2(9) -radix sfixed}} -subitemconfig {/testbench/DP/add2(0) {-height 16 -radix sfixed} /testbench/DP/add2(1) {-height 16 -radix sfixed} /testbench/DP/add2(2) {-height 16 -radix sfixed} /testbench/DP/add2(3) {-height 16 -radix sfixed} /testbench/DP/add2(4) {-height 16 -radix sfixed} /testbench/DP/add2(5) {-height 16 -radix sfixed} /testbench/DP/add2(6) {-height 16 -radix sfixed} /testbench/DP/add2(7) {-height 16 -radix sfixed} /testbench/DP/add2(8) {-height 16 -radix sfixed} /testbench/DP/add2(9) {-height 16 -radix sfixed}} /testbench/DP/add2
add wave -noupdate -radix sfixed /testbench/DP/add2_with_bias
add wave -noupdate /testbench/DP/maxI_L
add wave -noupdate /testbench/DP/maxI2_L
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {342896 ps} 0}
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
WaveRestoreZoom {0 ps} {39351528 ps}
