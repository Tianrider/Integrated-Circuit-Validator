;------------------------
; Assembly Code
;------------------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
;------------------------
.global main
;=================================================================
main:
    LDI R17, 0b00110100 ; Output: PB5, PB4, PB2 | Input: PB3, PB1
    ; PB5: D Input
    ; PB4: Clock
    ; PB3: Q Output 1
    ; PB1: Q Output 2
    ; PB0: Button input

    LDI R16, 0b11000000

    OUT DDRB, R17
    OUT DDRD, R16

main_loop: 
    ; Check if button on PB0 is pressed
    SBIC PINB, 0
    RJMP check_input_1
    RJMP main_loop

check_input_1: 
    SBI PORTB, 5
    CBI PORTB, 4
    RCALL delay_20ms
    RCALL delay_20ms

    SBI PORTB, 4
    RCALL delay_20ms

    ; Check if Q is high, jump to is_malfunction
    SBIS PINB, 3
    RCALL is_malfunction

    SBIS PINB, 1
    RCALL is_malfunction

check_input_0:
    CBI PORTB, 5
    CBI PORTB, 4
    RCALL delay_20ms

    SBI PORTB, 4
    RCALL delay_20ms

    ; Check if Q is low, jump to is_malfunction
    SBIC PINB, 3
    RCALL is_malfunction

    SBIC PINB, 1
    RCALL is_malfunction                                

    RCALL is_correct
    RJMP main_loop
    
is_malfunction:
    LDI R20, 6         ; Loop 6 times (for 12 toggles: ON/OFF)
malf_loop:
    SBI PORTB, 2       ; Turn buzzer ON
    RCALL delay_20ms
    CBI PORTB, 2       ; Turn buzzer OFF
    RCALL delay_20ms
    DEC R20
    BRNE malf_loop
    RET

is_correct: 
    ; turn on buzzer
    SBI PORTB, 2
    RCALL delay_20ms
    CBI PORTB, 2
    RCALL delay_20ms
    SBI PORTB, 2
    RCALL delay_20ms
    CBI PORTB, 2
    RET

delay_20ms:             ;delay 20ms
    LDI   R21, 255
l3: LDI   R22, 210
l4: LDI   R23, 2
l5: DEC   R23
    BRNE  l5
    DEC   R22
    BRNE  l4
    DEC   R21
    BRNE  l3
    RET

delay_1s:               ;delay 1s
    LDI   R21, 127
l6: LDI   R22, 255
l7: LDI   R23, 164
l8: DEC   R23
    BRNE  l8
    DEC   R22
    BRNE  l7
    DEC   R21
    BRNE  l6
    RET

end: