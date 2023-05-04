onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {TOP}
add wave -noupdate /tb/DUT/rst
add wave -noupdate /tb/DUT/clk
add wave -noupdate /tb/DUT/EA
add wave -noupdate /tb/DUT/start_f
add wave -noupdate /tb/DUT/start_t
add wave -noupdate /tb/DUT/stop_f_t
add wave -noupdate -divider {DCM}
add wave -noupdate /tb/DUT/DCM_inst/update
add wave -noupdate -radix unsigned /tb/DUT/prog
add wave -noupdate -radix unsigned /tb/DUT/DCM_inst/prog_reg
add wave -noupdate /tb/DUT/DCM_inst/clk_1
add wave -noupdate /tb/DUT/DCM_inst/clk_2
add wave -noupdate -divider {FIB}
add wave -noupdate /tb/DUT/clk_1
add wave -noupdate /tb/DUT/FIB_inst/f_en
add wave -noupdate /tb/DUT/FIB_inst/f_valid
add wave -noupdate -radix unsigned /tb/DUT/FIB_inst/f_out
add wave -noupdate -divider {TIMER}
add wave -noupdate /tb/DUT/clk_1
add wave -noupdate /tb/DUT/TIM_inst/t_en
add wave -noupdate /tb/DUT/TIM_inst/t_valid
add wave -noupdate -radix unsigned /tb/DUT/TIM_inst/t_out
add wave -noupdate -divider {WRAPPER}
add wave -noupdate /tb/DUT/WRP_inst/clk_1
add wave -noupdate /tb/DUT/WRP_inst/clk_2
add wave -noupdate /tb/DUT/WRP_inst/buffer_empty
add wave -noupdate /tb/DUT/WRP_inst/buffer_full
add wave -noupdate /tb/DUT/WRP_inst/data_1_en
add wave -noupdate -radix unsigned /tb/DUT/WRP_inst/data_1
add wave -noupdate /tb/DUT/WRP_inst/data_2_valid
add wave -noupdate -radix unsigned /tb/DUT/WRP_inst/data_2
add wave -noupdate -radix unsigned /tb/DUT/WRP_inst/buffer_wr
add wave -noupdate -radix unsigned /tb/DUT/WRP_inst/buffer_rd
add wave -noupdate -radix unsigned /tb/DUT/WRP_inst/buffer_reg
add wave -noupdate -divider {DM}
add wave -noupdate -radix unsigned /tb/DUT/DM_inst/prog
add wave -noupdate -radix unsigned /tb/DUT/DM_inst/module
add wave -noupdate -radix unsigned /tb/DUT/DM_inst/data_2
add wave -noupdate -radix hexadecimal /tb/DUT/DM_inst/an
add wave -noupdate -radix hexadecimal /tb/DUT/DM_inst/dec_ddp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {300 ns}