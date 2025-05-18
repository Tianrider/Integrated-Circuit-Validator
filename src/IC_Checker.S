;------------------------
; Integrated Circuit Validator
;------------------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
;------------------------
.global main
.global check_input

; =================================================================

; Kelompok 14

;=================================================================
; Setup and Main Loop
;=================================================================
.section .text
main:
  init_port: 
    LDI R17, 0b00110111 
    ; Output: PB5, PB4, PB2, PB1, PB0 | Input: PB3
    ; PB5: D Input
    ; PB4: Clock
    ; PB3: Input Q 1
    ; PB1: LCD
    ; PB0: LCD EN

    LDI R16, 0b11110000
    ; PD3: Input Q 2

    OUT DDRB, R17
    OUT DDRD, R16

    RCALL init_serial
    RCALL LCD_init
    RCALL init_ext_int

main_loop: 
    RJMP main_loop

; =================================================================

; =================================================================
; Input Check Logic 
;=================================================================
check_input:
check_input_1: 
    SBI PORTB, 5
    CBI PORTB, 4
    RCALL delay_20ms
    RCALL delay_20ms

    SBI PORTB, 4
    RCALL delay_20ms

    ; Check if Q is high, jump to is_malfunction
    SBIS PINB, 3
    RJMP is_malfunction

    SBIS PIND, 3
    RJMP is_malfunction

check_input_0:
    CBI PORTB, 5
    CBI PORTB, 4
    RCALL delay_20ms

    SBI PORTB, 4
    RCALL delay_20ms

    ; Check if Q is low, jump to is_malfunction
    SBIC PINB, 3
    RJMP is_malfunction

    SBIC PIND, 3
    RJMP is_malfunction                                

    RCALL is_normal
    RET
    
; =================================================================

;=================================================================
; Actions
;=================================================================
is_malfunction:
    LDI R20, 6         ; Loop 6 times (for 12 toggles: ON/OFF)
malf_loop:
    SBI PORTB, 2       ; Turn buzzer ON
    RCALL delay_20ms
    CBI PORTB, 2       ; Turn buzzer OFF
    RCALL delay_20ms
    DEC R20
    BRNE malf_loop

    RCALL print_malf_serial
    RCALL disp_fault

    RJMP check_end

is_normal: 
    ; turn on buzzer
    SBI PORTB, 2
    RCALL delay_20ms
    CBI PORTB, 2
    RCALL delay_20ms
    SBI PORTB, 2
    RCALL delay_20ms
    CBI PORTB, 2

    RCALL print_normal_serial
    RCALL disp_ok

;=================================================================

check_end:
    RET