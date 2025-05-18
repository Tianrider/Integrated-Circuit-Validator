#define __SFR_OFFSET 0x00
#include "avr/io.h"

.global INT0_vect
.global init_ext_int

.section .text
INT0_vect: 
    RCALL check_input
    RETI

init_ext_int:
    ; Configure INT0 for falling edge trigger
    ldi r16, (1<<ISC01)
    out MCUCR, r16
    ldi r16, (1<<INT0)
    out EIMSK, r16
    sei