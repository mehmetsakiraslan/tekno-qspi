## vcu108.xdc

set_property CFGBVS GND                                [current_design]
set_property CONFIG_VOLTAGE 1.8                        [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true           [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN {DIV-1} [current_design]
set_property BITSTREAM.CONFIG.BPI_SYNC_MODE Type1      [current_design]
set_property CONFIG_MODE BPI16                         [current_design]

set_property -dict {LOC AT32 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {prog_mode_led_o}]

set_property -dict {LOC BC9  IOSTANDARD LVDS} [get_ports clk_p]
set_property -dict {LOC BC8  IOSTANDARD LVDS} [get_ports clk_n]
create_clock -period 8.000 -name clk_125mhz_p [get_ports clk_p]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {<const0>}]
#{clk_IBUF_inst/O}]

set_property -dict {LOC BC40 IOSTANDARD LVCMOS12} [get_ports {rst_ni}]

# PROGRAMLAYICI UART
set_property -dict {LOC BC14 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {program_rx_i}]

# UART
set_property -dict {LOC BE24 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports uart_tx_o]
set_property -dict {LOC BC24 IOSTANDARD LVCMOS18} [get_ports uart_rx_i]

# SPI
set_property -dict {LOC BC13 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {spi_cs_o}]
set_property -dict {LOC BF7 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {spi_sck_o}]
set_property -dict {LOC AW12 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {spi_mosi_o}]
set_property -dict {LOC BC16 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {spi_miso_i}]

# PWM
set_property -dict {LOC BA10 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {pwm0_o}]
set_property -dict {LOC AW16 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {pwm1_o}]

