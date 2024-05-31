#include "spi_driver.h"


int main(){
    //|13|00000001|x03
    // QSPI_ADR = 0x000f0f00;
    // QSPI_DR0 = 0xaaaaaaaa;
    // write
    //    ccr |prescale |veri boyutu | 0000 01 01 | 0000 0010
    //    0 000001 | 0 |00 | 0000 01 01 | 0000 0010
    // QSPI_CCR = 0x3030502;
    // read
    //    00000010000000110 / 00001010 / 0000010
    // QSPI_CCR = 0x02030103;



    qspi_ccr ccr;
    ccr.fields.inst_value = CMD_RDID;
    ccr.fields.prescale = 1;
    ccr.fields.veri_boyutu = 2;
    ccr.fields.flash_yaz = 0;
    ccr.fields.veri_mod = 1;
    ccr.fields.clear_status_reg = 0;
    ccr.fields.dummy_cycle = 0;

    for(int k=0; k<1000; k++)
        QSPI_CCR = ccr.bits;
    
    // SPI_WDATA = 0x98;
    // SPI_CTRL = 0x000F0001;
    // SPI_CMD = 0x00002000;
    // while(!((SPI_STATUS>>1)%2));
    // SPI_WDATA = 0x98;
    // SPI_CTRL = 0x000F0005;
    // SPI_CMD = 0x00002000;
    // while(!((SPI_STATUS>>1)%2));
    // SPI_WDATA = 0x98;
    // SPI_CTRL = 0x000F0009;
    // SPI_CMD = 0x00002000;
    // while(!((SPI_STATUS>>1)%2));
    // SPI_WDATA = 0x98;
    // SPI_CTRL = 0x000F000D;
    // SPI_CMD = 0x00002000;
    while(1);
}
