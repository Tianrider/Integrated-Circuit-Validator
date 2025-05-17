#define __SFR_OFFSET 0x00
#include "avr/io.h"

.section .progmem
malf_msg: 
    .ascii "IC IS MALFUNCTION!"
    .byte 10,13,0

correct_msg: 
    .ascii "IC IS WORKING PROPERLY!"
    .byte 10,13,0

.section .text
.global init_serial
.global print_malf_serial
.global print_normal_serial

init_serial: 
    STS   UCSR0A, R24     ;clear UCSR0A register
    STS   UBRR0H, R24     ;clear UBRR0H register
    LDI   R24, 16        ;& store in UBRR0L 16
    STS   UBRR0L, R24     ;to set baud rate 57600
    LDI   R24, 1<<RXEN0 | 1<<TXEN0
    STS   UCSR0B, R24     ;enable RXB & TXB
    LDI   R24, 1<<UCSZ00 | 1<<UCSZ01
    STS   UCSR0C, R24     ;asynch, no parity, 1 stop, 8 bits

print_malf_serial: 
    LDI R30, lo8(malf_msg)
    LDI R31, hi8(malf_msg)
    RCALL print_msg
    RET

print_normal_serial: 
    LDI R30, lo8(correct_msg)
    LDI R31, hi8(correct_msg)
    RCALL print_msg
    RET

print_msg: 
  read_char: 
    LPM R18, Z+
    CPI R18, 0
    BREQ end_print                    ; If null terminator, end transmission
  l0: 
    LDS R17, UCSR0A
    SBRS R17, UDRE0 ; print LED 1 menyala
    RJMP l0
    STS UDR0, R18 ;send char in R18 to serial monitor
    RJMP read_char  ;loop back & get next character
  end_print:
    RET
  