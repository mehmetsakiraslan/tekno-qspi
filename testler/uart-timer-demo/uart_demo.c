//#define UART_CTRL        (*(volatile uint32_t*)0x20000000)
//#define UART_STATUS      (*(volatile uint32_t*)0x20000004)
//#define UART_RDATA       (*(volatile uint32_t*)0x20000008)
//#define UART_WDATA       (*(volatile uint32_t*)0x2000000c)

#include "uart_driver.h"

#define uintptr_t unsigned int

//#define uint32_t unsigned int
#define CPU_CLK 50000000  // 50 Mhz 
#define BAUD_RATE 115200

char logo[] = 
"\
                                        .(%##%%%%%#%%%%%##%/                    \n\
                               ./%%%%%%#(*.            ./#%%%%%%#               \n\
                          ,##%%/.                             #%%%%        ,    \n\
             /         ##%,                                     %%#.       %    \n\
          %(        #%(     .                                   #%*       %%    \n\
       .%%        ,%     ,,                             *,     (/       #%%     \n\
      %%%         %     /*                           */.     *       ,%%%.      \n\
     %%%%               ///,                   ,*/*.              (%%%#         \n\
    *%%%%#                 */**/*//*//***//*.                .%%%%%/            \n\
     %%%%%%#                                           .(%%%%%%/                \n\
      ,%%%%%%%%%*                              ,/#%%%%%%%%/                     \n\
         .%%%%%%%%%%%%%%%%%#######%%%%%%%%%%%%%%%%%/.                           \n\
                /%%%%%%%%%%%%%%%%%%%%%%%%/.                                     \n\
                                                                                \n\
                                                                                \n\
(((.                                                                            \n\
%%%,                                                                            \n\
%%%,    ***.   .*((/,        ,(#/.     ***   ,**  .(/    ,##(. .**,     ,/((,   \n\
%%%,  %%%(    %%(//#%%%,   %%%,.*%%.   %%%   /%%(%%%(  %%%%*,(%%%%(   .%#/*(%%%#\n\
%%%,%%%/             %%%   %%%/        %%%   /%%%     %%%      /%%(          (%%\n\
%%%%%%%%     (%%%/,*%%%%     #%%%%%    %%%   /%%,     %%%      *%%(  .%%%#,*#%%%\n\
%%%,  %%%*   %%#     %%%         #%%   %%%   /%%,      %%%(. ,%%%%(  %%%     (%%\n\
%%%,   /%%%  *%%%%%%%%%%  #%%%%%%%%,   %%%   /%%,        (%%%* *%%/   %%%%%%%#%%\n\
                                                       ((     #%%%              \n\
                                                        (%%%%%%,                \n\
";
//#define UART_BASE 0x20000000
/*
//const unsigned int* UART_BASE = 0x20000000;
volatile unsigned int* UART_CTRL = 0x20000000; // UART_BASE + 0x0000;
volatile unsigned int* UART_STAT = 0x20000004; //UART_BASE + 0x0004;
volatile unsigned int* UART_RX_FIFO = 0x20000008; //UART_BASE + 0x0008;
volatile unsigned int* UART_TX_FIFO = 0x2000000c; //UART_BASE + 0x000C;

static inline int rx_has_data()
{
    return ((*UART_STAT) & 0x8) != 0x8;
}

static inline int tx_empty()
{
    return ((*UART_STAT) & 0x4) == 0x4;
}

static inline char read_uart()
{
    return (*UART_RX_FIFO) & 0xff;
}

static inline void write_uart(char wdata)
{
    (*UART_TX_FIFO) = wdata;
}

static void send_string(char* string, int len)
{
    for (int i = 0 ; i < len ; i++)
    {
        while(!tx_empty());
        write_uart(string[i]);
    }
}
*/

//#include <stdio.h>

#define TIMER_LOW        (*(volatile uint32_t*)0x30000000)
#define TIMER_HIGH       (*(volatile uint32_t*)0x30000004)

//volatile unsigned int* TIMER_LOW = 0x30000000;
//volatile unsigned int* TIMER_HIGH = 0x30000004;

uint32_t get_timer_low(){
    return TIMER_LOW; //& 0xff;
}
uint32_t get_timer_high(){
    return TIMER_HIGH; //& 0xff;
}
// TODO ust bitlere bakacaksak hem bura hem core_portme.hda degisiklik gerek
uint32_t /*uint64_t*/ get_timer(){
    //return (get_timer_high() << 5) + get_timer_low();
    return (get_timer_high() << 32) + get_timer_low();
    //return get_timer_low();
}

static int __strcmp(char* s1, char* s2, int len)
{
    for(int i = 0 ; i < len ; i++)
    {
        if (s1[i] != s2[i])
            return 0;
    }
    return 1;
}

char cmd_buf[8];

int main()
{
	uart_ctrl uart_control;
	uart_control.fields.tx_en = 0x1; 
	uart_control.fields.tx_en = 0x1; 
	uart_control.fields.baud_div = CPU_CLK/BAUD_RATE; 
	UART_CTRL = uart_control.bits;

    //(*UART_CTRL) = 0x01b20003; //0x03640001; // bauddiv 868, baudrate 115200 // 4340 / 5 cunku 500de ve 100de diye, o zaman 50de 434 olması lazım
    //send_string(logo, sizeof(logo));
    //asm volatile("li x27, 4123425342");
    //while(1)
    //print(logo);
    //char str[100];
    //sprintf(str, "%d", get_timer());
    //print(str);
    //tekno_printf("%lu\n", get_timer());
    tekno_printf("%lu\n", (get_timer_high() << 32) + get_timer_low());
    int i = 0;
    while(i != 100000){
    //print("a");
    //tekno_printf("%lu\n", (get_timer_high() << 32) + get_timer_low());
    //tekno_printf("%lu\n", (get_timer_high() << 32));
    tekno_printf("%lf\n", get_timer_low() / CPU_CLK);
    i++;
    }
    tekno_printf("%lu\n", (get_timer_high() << 32) + get_timer_low());
    //send_string("KASIRGA", sizeof("KASIRGA"));
/*
    while(1)
    {
        // butun komutlarin 8 bayta
        // sigdigini varsayiyoruz
        for (int i = 0 ; i < 8 ; i++)
        {
            while((UART_STATUS & 0x8) == 0x8);
            cmd_buf[i] = UART_RDATA;
        }
        
        if (__strcmp(cmd_buf,"logo",sizeof("logo")-1))
        {
            print(logo);
        }

    }
     */
    return 0;
}
