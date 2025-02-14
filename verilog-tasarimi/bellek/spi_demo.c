#include "spi_driver.h"
#include "uart_driver.h"

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

    // QSPI_ADR = 0x00780000; //0x0000ffff;

    // QSPI_DR0 = 0x0000ffff;
//     QSPI_DR1 = 0xffffffff;
//     QSPI_DR2 = 0xaaaaaaaa;
//     QSPI_DR3 = 0xffffffff;
//     QSPI_DR4 = 0xaaaaaaaa;
//     QSPI_DR5 = 0xffffffff;
//     QSPI_DR6 = 0xaaaaaaaa;
//     QSPI_DR7 = 0xffffffff;



/////
/////
///// Important assumptions: 
///// 1- Value of (Clock divider+1) must be an even number 
///// 2- Signal veri_boyutu should be chosen according to the command used
///// 3- Number of bits to bbe send = (veri_boyutu+1)<<3-1;
///// 4- Address value should be given before every command, even when there is 2 commands executed on same address
/////


    qspi_ccr ccr;
    // ccr.fields.inst_value = CMD_PP;
    // ccr.fields.prescale = 1;
    // ccr.fields.veri_boyutu = 3;
    // ccr.fields.flash_yaz = 1;
    // ccr.fields.veri_mod = 1;
    // ccr.fields.clear_status_reg = 0;
    // ccr.fields.dummy_cycle = 0;

    // for(int k=0; k<1000; k++)
    //     QSPI_CCR = ccr.bits;

/*
    unsigned int ctr = 0;

    while(ctr<10){
        print('c');
        ctr=ctr+1;
    }
ctr = 0;
    while(ctr<10){
        print('c');
        ctr=ctr+1;
    }

ctr = 0;
while(ctr<10){
        print('c');
        ctr=ctr+1;
    }
    */


    

    

    ccr.fields.inst_value = CMD_READ;
    ccr.fields.prescale = 1;
    ccr.fields.veri_boyutu = 3;
    ccr.fields.flash_yaz = 0;
    ccr.fields.veri_mod = 1;
    ccr.fields.clear_status_reg = 0;
    ccr.fields.dummy_cycle = 0;
    
    for(int k=0; k<10000; k++){
        if(k % 2 == 0)
        QSPI_ADR = 0x00FFFFFA;
        else
        QSPI_ADR = 0x00780000;
        QSPI_CCR = ccr.bits;
    }
    
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
