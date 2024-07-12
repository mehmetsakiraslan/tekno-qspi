#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdbool.h>

#define QSPI_CCR   (*(volatile uint32_t*) 0x20010000)
#define QSPI_ADR   (*(volatile uint32_t*) 0x20010004)
#define QSPI_DR0   (*(volatile uint32_t*) 0x20010008)
#define QSPI_DR1   (*(volatile uint32_t*) 0x2001000c)
#define QSPI_DR2   (*(volatile uint32_t*) 0x20010010)
#define QSPI_DR3   (*(volatile uint32_t*) 0x20010014)
#define QSPI_DR4   (*(volatile uint32_t*) 0x20010018)
#define QSPI_DR5   (*(volatile uint32_t*) 0x2001001c)
#define QSPI_DR6   (*(volatile uint32_t*) 0x20010020)
#define QSPI_DR7   (*(volatile uint32_t*) 0x20010024)
#define QSPI_STA   (*(volatile uint32_t*) 0x20010028)
int spi_miso_empty();

#define CMD_READ 0x03
#define CMD_DOR 0x3B
#define CMD_QOR 0x6B
#define CMD_PP 0x02
#define CMD_QPP 0x32
#define CMD_SE 0xD8
#define CMD_READID 0x90
#define CMD_RDID 0x9F
#define CMD_RES 0xAB
#define CMD_RDSR1 0x05
#define CMD_RDSR2 0x07
#define CMD_RDCR 0x35
#define CMD_WRR 0x01
#define CMD_WRDI 0x04
#define CMD_WREN 0x06
#define CMD_CLSR 0x30
#define CMD_RESET 0xF0

typedef union
{
	struct {
        // En bastaki en anlamsiz
		unsigned int inst_value         : 8;
		unsigned int veri_mod 	        : 2;
		unsigned int flash_yaz	        : 1;
		unsigned int dummy_cycle        : 5;
        // okunacak bayt sayisi: veri boyutu + 1
        unsigned int veri_boyutu        : 9;
        unsigned int prescale           : 6;
        unsigned int clear_status_reg   : 1;
	} fields;
	uint32_t bits;
}qspi_ccr;

typedef union
{
	struct {
        // En bastaki en anlamsiz
		unsigned int address    : 24;
        unsigned int dummy      : 7;
        unsigned int address_en : 1;
	} fields;
	uint32_t bits;
}qspi_adr;


