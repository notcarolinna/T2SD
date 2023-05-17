onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TOP
add wave -noupdate /tb/DUT/rst
add wave -noupdate /tb/DUT/clk
add wave -noupdate /tb/DUT/EA
add wave -noupdate /tb/DUT/start_f
add wave -noupdate /tb/DUT/start_t
add wave -noupdate /tb/DUT/stop_f_t
add wave -noupdate -divider DCM
add wave -noupdate /tb/DUT/dcm_arq/update
add wave -noupdate -radix unsigned /tb/DUT/prog
add wave -noupdate -radix unsigned /tb/DUT/dcm_arq/prog_reg
add wave -noupdate /tb/DUT/dcm_arq/clk_1
add wave -noupdate /tb/DUT/dcm_arq/clk_2
add wave -noupdate -divider FIB
add wave -noupdate /tb/DUT/clk_1
add wave -noupdate /tb/DUT/fibonacci_arq/f_en
add wave -noupdate /tb/DUT/fibonacci_arq/f_valid
add wave -noupdate /tb/DUT/fibonacci_arq/t1
add wave -noupdate /tb/DUT/fibonacci_arq/t2
add wave -noupdate -radix unsigned /tb/DUT/fibonacci_arq/f_out
add wave -noupdate -divider TIMER
add wave -noupdate /tb/DUT/clk_1
add wave -noupdate /tb/DUT/timer_arq/t_en
add wave -noupdate /tb/DUT/timer_arq/t_valid
add wave -noupdate -radix unsigned /tb/DUT/timer_arq/t_out
add wave -noupdate -divider WRAPPER
add wave -noupdate /tb/DUT/wrapper_arq/clk_1
add wave -noupdate /tb/DUT/wrapper_arq/clk_2
add wave -noupdate /tb/DUT/wrapper_arq/buffer_empty
add wave -noupdate /tb/DUT/wrapper_arq/buffer_full
add wave -noupdate /tb/DUT/wrapper_arq/data_1_en
add wave -noupdate -radix unsigned /tb/DUT/wrapper_arq/data_1
add wave -noupdate /tb/DUT/wrapper_arq/data_valid_2
add wave -noupdate -radix unsigned /tb/DUT/wrapper_arq/data_2
add wave -noupdate -radix unsigned /tb/DUT/wrapper_arq/buffer_wr
add wave -noupdate -radix unsigned /tb/DUT/wrapper_arq/buffer_rd
add wave -noupdate -radix unsigned /tb/DUT/wrapper_arq/buffer_reg
add wave -noupdate -divider DM
add wave -noupdate -radix unsigned /tb/DUT/dm_arq/prog
add wave -noupdate -radix unsigned /tb/DUT/dm_arq/data_2
add wave -noupdate -radix hexadecimal /tb/DUT/dm_arq/an
add wave -noupdate -radix hexadecimal /tb/DUT/dm_arq/dec_ddp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {827 ns} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ns} {6564 ns}
