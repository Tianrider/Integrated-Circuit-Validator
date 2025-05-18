#define __SFR_OFFSET 0x00
#include "avr/io.h"

.section .text
.global LCD_init
.global disp_ok
.global disp_fault

;================================================================
LCD_init:
      CBI   PORTB, 0          ;EN = 0
      RCALL delay_ms          ;wait for LCD power on
      LDI   R16, 0x33         ;init LCD for 4-bit data
      RCALL command_wrt       ;send to command register
      RCALL delay_ms
      LDI   R16, 0x32         ;init LCD for 4-bit data
      RCALL command_wrt
      RCALL delay_ms
      LDI   R16, 0x28         ;LCD 2 lines, 5x7 matrix
      RCALL command_wrt
      RCALL delay_ms
      LDI   R16, 0x0C         ;disp ON, cursor OFF
      RCALL command_wrt
      LDI   R16, 0x01         ;clear LCD
      RCALL command_wrt 
      RCALL delay_ms
      LDI   R16, 0x06         ;shift cursor right
      RCALL command_wrt
      RET  
;================================================================
command_wrt:
      MOV   R27, R16
      ANDI  R27, 0xF0         ;mask low nibble & keep high nibble
      OUT   PORTD, R27        ;o/p high nibble to port D
      CBI   PORTB, 1          ;RS = 0 for command
      SBI   PORTB, 0          ;EN = 1
      RCALL delay_short       ;widen EN pulse
      CBI   PORTB, 0          ;EN = 0 for H-to-L pulse
      RCALL delay_us          ;delay in micro seconds
      ;----------------------------------------------------
      MOV   R27, R16
      SWAP  R27               ;swap nibbles
      ANDI  R27, 0xF0         ;mask low nibble & keep high nibble
      OUT   PORTD, R27        ;o/p high nibble to port D
      SBI   PORTB, 0          ;EN = 1
      RCALL delay_short       ;widen EN pulse
      CBI   PORTB, 0          ;EN = 0 for H-to-L pulse
      RCALL delay_us          ;delay in micro seconds
      RET
;================================================================
data_wrt:
      MOV   R27, R16
      ANDI  R27, 0xF0         ;mask low nibble & keep high nibble
      OUT   PORTD, R27        ;o/p high nibble to port D
      SBI   PORTB, 1          ;RS = 1 for data
      SBI   PORTB, 0          ;EN = 1
      RCALL delay_short       ;make wide EN pulse
      CBI   PORTB, 0          ;EN = 0 for H-to-L pulse
      RCALL delay_us          ;delay in micro seconds
      ;----------------------------------------------------
      MOV   R27, R16
      SWAP  R27               ;swap nibbles
      ANDI  R27, 0xF0         ;mask low nibble & keep high nibble
      OUT   PORTD, R27        ;o/p high nibble to port D
      SBI   PORTB, 0          ;EN = 1
      RCALL delay_short       ;widen EN pulse
      CBI   PORTB, 0          ;EN = 0 for H-to-L pulse
      RCALL delay_us          ;delay in micro seconds
      RET
;================================================================
disp_ok: 
      RCALL clear_lcd
      LDI   R16, 'O'          ;display characters
      RCALL data_wrt          ;via data register
      LDI   R16, 'K'
      RCALL data_wrt
      RET
;================================================================
disp_fault: 
      RCALL clear_lcd
      LDI   R16, 'F'          ;display characters
      RCALL data_wrt          ;via data register
      LDI   R16, 'A'
      RCALL data_wrt
      LDI   R16, 'U'
      RCALL data_wrt
      LDI   R16, 'L'
      RCALL data_wrt
      LDI   R16, 'T'
      RCALL data_wrt
      LDI   R16, 'Y'
      RCALL data_wrt
      LDI   R16, '!'
      RCALL data_wrt
      RET
;================================================================
delay_short:
      NOP
      NOP
      RET
;------------------------
delay_us:
      LDI   R20, 90
lcd_l3:   RCALL delay_short
      DEC   R20
      BRNE  lcd_l3
      RET
;-----------------------
delay_ms:
      LDI   R21, 40
lcd_l4:   RCALL delay_us
      DEC   R21
      BRNE  lcd_l4
      RET
;================================================================
delay_seconds:        ;nested loop subroutine (max delay 3.11s)
    LDI   R20, 255    ;outer loop counter 
lcd_l5: LDI   R21, 255    ;mid loop counter
lcd_l6: LDI   R22, 20     ;inner loop counter to give 0.25s delay
lcd_l7: DEC   R22         ;decrement inner loop
    BRNE  lcd_l7          ;loop if not zero
    DEC   R21         ;decrement mid loop
    BRNE  lcd_l6          ;loop if not zero
    DEC   R20         ;decrement outer loop
    BRNE  lcd_l5          ;loop if not zero
    RET               ;return to caller

clear_lcd: 
    LDI   R16, 0x01         ;clear LCD
    RCALL command_wrt       ;send command code
    RCALL delay_ms
    RET
