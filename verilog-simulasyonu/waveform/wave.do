onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /teknofest_wrapper/soc/clk
add wave -noupdate /teknofest_wrapper/soc/resetn
add wave -noupdate -divider flash
add wave -noupdate /teknofest_wrapper/flash/SI
add wave -noupdate /teknofest_wrapper/flash/SO
add wave -noupdate /teknofest_wrapper/flash/CS
add wave -noupdate /teknofest_wrapper/flash/SCK
add wave -noupdate /teknofest_wrapper/flash/RSTNeg
add wave -noupdate /teknofest_wrapper/flash/HOLDNeg
add wave -noupdate /teknofest_wrapper/flash/WPNeg
add wave -noupdate -divider controller
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/wb_adr_i
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/wb_dat_i
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/wb_we_i
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/wb_stb_i
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/wb_sel_i
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/wb_cyc_i
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/wb_ack_o
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/wb_dat_o
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/io_qspi_data
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/spi_cs_o
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/spi_sck_o
add wave -radix hexadecimal -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/control_register_r
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/read_write_unable
add wave -radix unsigned -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/bit_ctr
add wave -radix unsigned -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/word_ctr
add wave -radix hexadecimal -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/buffer
add wave -noupdate /teknofest_wrapper/soc/isl_blksiz/veriyolu_dut/spi_denetleyici_dut/state

add wave -noupdate /teknofest_wrapper/flash/WREN
add wave -noupdate /teknofest_wrapper/flash/WEL

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {205870500 ps} 0} {{Cursor 2} {205585589 ps} 0}
quietly wave cursor active 2
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
configure wave -timelineunits ps
update
WaveRestoreZoom {205822282 ps} {205935841 ps}
