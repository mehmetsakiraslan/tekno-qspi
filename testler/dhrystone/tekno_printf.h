
///////////////////////////////////////////////////////////////////////////////////////////////////
// Company:     TUTEL
// Project:     Teknofest Chip Competition 2023
//***********************************************************************************************// 
// Create Date: 13/01/2023
// Module Name: uart_driver.c
// Description: UART driver for teknofest.
//
///////////////////////////////////////////////////////////////////////////////////////////////////

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdbool.h>

char heap_memory2[1024];
int heap_memory_used2 = 0;

char *malloc(int size)
{
	char *p = heap_memory2 + heap_memory_used2;
	// printf("[malloc(%d) -> %d (%d..%d)]", size, (int)p, heap_memory_used, heap_memory_used + size);
	heap_memory_used2 += size;
	if (heap_memory_used2 > 1024)
		asm volatile ("ebreak");
	return p;
}

char *strcpy(char* dst, const char* src)
{
	char *r = dst;

	while ((((uint32_t)dst | (uint32_t)src) & 3) != 0)
	{
		char c = *(src++);
		*(dst++) = c;
		if (!c) return r;
	}

	while (1)
	{
		uint32_t v = *(uint32_t*)src;

		if (__builtin_expect((((v) - 0x01010101UL) & ~(v) & 0x80808080UL), 0))
		{
			dst[0] = v & 0xff;
			if ((v & 0xff) == 0)
				return r;
			v = v >> 8;

			dst[1] = v & 0xff;
			if ((v & 0xff) == 0)
				return r;
			v = v >> 8;

			dst[2] = v & 0xff;
			if ((v & 0xff) == 0)
				return r;
			v = v >> 8;

			dst[3] = v & 0xff;
			return r;
		}

		*(uint32_t*)dst = v;
		src += 4;
		dst += 4;
	}
}

extern long time();


#define TIMER_LOW        (*(volatile uint32_t*)0x30000000)
#define TIMER_HIGH       (*(volatile uint32_t*)0x30000004)

long time()
{
	return TIMER_LOW;
}

#define UART_CTRL        (*(volatile uint32_t*)0x20000000)
#define UART_STATUS      (*(volatile uint32_t*)0x20000004)
#define UART_RDATA       (*(volatile uint32_t*)0x20000008)
#define UART_WDATA       (*(volatile uint32_t*)0x2000000c)

static void printf_c(int c)
{
	UART_WDATA = c;
}

static void printf_s(char *p)
{
	while (*p)
		UART_WDATA = *(p++);
}

static void printf_d(int val)
{
	char buffer[32];
	char *p = buffer;
	if (val < 0) {
		printf_c('-');
		val = -val;
	}
	while (val || p == buffer) {
		*(p++) = '0' + val % 10;
		val = val / 10;
	}
	while (p != buffer)
		printf_c(*(--p));
}

int t_printf(const char *format, ...)
{
	int i;
	va_list ap;

	va_start(ap, format);

	for (i = 0; format[i]; i++)
		if (format[i] == '%') {
			while (format[++i]) {
				if (format[i] == 'c') {
					printf_c(va_arg(ap,int));
					break;
				}
				if (format[i] == 's') {
					printf_s(va_arg(ap,char*));
					break;
				}
				if (format[i] == 'd') {
					printf_d(va_arg(ap,int));
					break;
				}
			}
		} else
			printf_c(format[i]);

	va_end(ap);
}

#define CPU_CLK 60000000  // 50 Mhz 
#define BAUD_RATE 115200

typedef union
{
	struct {
		unsigned int tx_en    : 1;
		unsigned int rx_en 	  : 1;
		unsigned int null	  : 14;
		unsigned int baud_div : 16;
	} fields;
	uint32_t bits;
}uart_ctrl;

typedef union
{
	struct {
		unsigned int tx_full  : 1;
		unsigned int rx_full  : 1;
		unsigned int tx_empty : 1;
		unsigned int rx_empty : 1;
		unsigned int null	  : 28;
	} fields;
	uint32_t bits;
}uart_status;

//-----------------------------------------------
// print a single character.
//-----------------------------------------------
int uart_txfull(){
	uart_status uart_stat;
	uart_stat.bits = UART_STATUS;
	return uart_stat.fields.tx_full;
}

void zputchar(char c)
{
	while(uart_txfull());
	if (c == '\n')
		zputchar('\r');
	UART_WDATA = c;
}

//-----------------------------------------------
// print a string (char*).
//-----------------------------------------------

void print(const char *p)
{
	while (*p)
		zputchar(*(p++));
}

void tekno_printf(const char *fmt, ...)
{
	va_list vl;
	bool is_format, is_long, is_char;
	char c, string_buf[11];

	va_start(vl, fmt);
	is_format = false;
	is_long = false;
	is_char = false;
	while ((c = *fmt++) != '\0') {
		if (is_format) {
			switch (c) {
			case 'l':
				is_long = true;
				is_format = true;
				is_char = false;
				continue;
			case 'h':
				is_char = true;
				is_format = false;
				is_long = false;
				continue;
			case 'f': 	
			case 'x': {
				unsigned long n;
				long i;
				if (is_long) {
					n = va_arg(vl, unsigned long);
					i = (sizeof(unsigned long) << 3) - 4;
				} else {
					n = va_arg(vl, unsigned int);
					i = is_char ? 4 : (sizeof(unsigned int) << 3) - 4;
				}
				for (; i >= 0; i -= 4) {
					long d;
					d = (n >> i) & 0xF;
					zputchar(d < 10 ? '0' + d : 'a' + d - 10);
				}
				is_format = false;
				is_long = false;
				is_char = false;
				break;
			}
			case 'd': {
                long num = is_long ? va_arg(vl, long) : va_arg(vl, int);
                if (num < 0) {
                    num = -num;
                        zputchar( '-');
                }
                long digits = 1;
                char digit_array[20];
                for (long nn = num; nn /= 10; digits++)
                    ;
                for (int i = digits-1; i >= 0; i--) {
                    digit_array[i] = '0' + (num % 10);                
                    num /= 10;
                }
                for(int i = 0; i<digits; i++){
                  zputchar(digit_array[i]);
                }
				is_format = false;
				is_long = false;
				is_char = false;
                break;
            }
			case 'u': {
                long unsigned num = is_long ? va_arg(vl, long) : va_arg(vl, int);
                long digits = 1;
                for (long nn = num; nn /= 10; digits++)
                    ;
                for (int i = digits-1; i >= 0; i--) {
                    zputchar('0' + (num % 10));                    
                    num /= 10;
                }
				is_format = false;
				is_long = false;
				is_char = false;
                break;
            }				
			case 's':
				print(va_arg(vl, const char *));
				is_format = false;
				is_long = false;
				is_char = false;
				break;
			case 'c':
				zputchar(va_arg(vl, int));
				is_format = false;
				is_long = false;
				is_char = false;
				break;
			case '0':
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
			case '8':
			case '9':
				break;			
			default:
				print(" unknown instruction ");
				is_format = false;
				is_long = false;
				is_char = false;
				break;
			}
		} else if (c == '%') {
			is_format = true;
		} else {
			zputchar(c);
			//if(c == '\n'){
			//	zputchar('\r');
			//}
		}
	}
	va_end(vl);
}

//-----------------------------------------------
// scan a single character.
//-----------------------------------------------

int uart_rxempty(){
	uart_status uart_stat;
	uart_stat.bits  = UART_STATUS;
	return uart_stat.fields.rx_empty;
}

char zgetchar()
{
	while(1){
		if (!uart_rxempty()){
			return(char)UART_RDATA;
		}
	}
}

//-----------------------------------------------
// scan multiple characters.
//-----------------------------------------------

int zscan(char *buffer, int max_size, int echo) 
{
  char c = 0;
  int length = 0;

  while (1) {
    c = zgetchar();
    if (c == '\b') { // BACKSPACE
      if (length != 0) {
        if (echo) {
          print("\b \b"); // delete last char in console
        }
        buffer--;
        length--;
      }
    }
    else if (c == '\r') // carriage return
      break;
    else if ((c >= ' ') && (c <= '~') && (length < (max_size-1))) {
      if (echo) {
        zputchar(c); // echo
      }
      *buffer++ = c;
      length++;
    }
  }
  *buffer = '\0'; // terminate string
  print("\n");

  return length;
}

//-----------------------------------------------
// string compare.
// compares all chars in two strings.
//-----------------------------------------------

int strcmp(const char *p1, const char *p2)
{
	const unsigned char *s1 = (const unsigned char *) p1;
	const unsigned char *s2 = (const unsigned char *) p2;
	unsigned char c1, c2;
	do{
		c1 = (unsigned char) *s1++;
		c2 = (unsigned char) *s2++;
		if(c1 == '\0')
			return c1 - c2;
	}
	while(c1 == c2);
	return c1 - c2;
}

//-----------------------------------------------
// strlen
//-----------------------------------------------

size_t strlen(const char *s)
{
  const char *p = s;
  while (*p)
    p++;
  return p - s;
}

void init_uart(){
    uart_ctrl uart_control;
    uart_control.fields.tx_en = 0x1;
    uart_control.fields.tx_en = 0x1;
    uart_control.fields.baud_div = CPU_CLK/BAUD_RATE;
    UART_CTRL = uart_control.bits;
}
