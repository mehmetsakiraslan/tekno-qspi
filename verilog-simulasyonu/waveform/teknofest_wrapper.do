onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /teknofest_wrapper/soc/clk_i
add wave -noupdate /teknofest_wrapper/soc/rst_i
add wave -noupdate -divider coz
add wave -noupdate /teknofest_wrapper/soc/cek/coz_yazmacoku_dut/ddb_bosalt_i
add wave -noupdate /teknofest_wrapper/soc/cek/coz_yazmacoku_dut/ddb_durdur_i
add wave -noupdate /teknofest_wrapper/soc/cek/coz_yazmacoku_dut/gtr_buyruk_i
add wave -noupdate -radix hexadecimal /teknofest_wrapper/soc/cek/coz_yazmacoku_dut/debug_ps
add wave -noupdate -radix ascii /teknofest_wrapper/soc/cek/coz_yazmacoku_dut/coz_str
add wave -noupdate -divider yurut
add wave -noupdate -radix ascii /teknofest_wrapper/soc/cek/yurut_dut/micro_str
add wave -noupdate /teknofest_wrapper/soc/cek/yurut_dut/cyo_deger1_i
add wave -noupdate /teknofest_wrapper/soc/cek/yurut_dut/cyo_deger2_i
add wave -noupdate /teknofest_wrapper/soc/cek/yurut_dut/bib/basla_i
add wave -noupdate /teknofest_wrapper/soc/cek/yurut_dut/bib/adr_i
add wave -noupdate /teknofest_wrapper/soc/cek/yurut_dut/bib/deger_i
add wave -noupdate /teknofest_wrapper/soc/cek/yurut_dut/bib/bib_yaz_gecerli_o
add wave -noupdate -divider gy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13645000 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {48168751 ps}
