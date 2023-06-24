; Name: [Doyun Gu]
; UID:  [11095970]
    
    ; Standard Header
    processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00
    
; Declare the variables for the locations
LATA equ 0xF89 
TRISA equ 0xF92 
PORTA equ 0xF80
LATB equ 0xF8A 
TRISB equ 0xF93 
PORTB equ 0xF81
LATC equ 0xF8B 
TRISC equ 0xF94 
PORTC equ 0xF82
LATF equ 0xF8E 
TRISF equ 0xF97 
PORTF equ 0xF85
LATH equ 0xF90 
TRISH equ 0xF99 
PORTH equ 0xF87
LATJ equ 0xF91 
TRISJ equ 0xF9A 
PORTJ equ 0xF88
ADCON1 equ 0xFC1    

; Declare the variable
var_count_200us equ 0X04

; Basic:
; 1. Create a soubroutine that contains 4 NOPs, loops 71 times, and uses DECF to decrease the loop counter. 
;    In simulator mode, use a stopwatch to determine how long the subroutine takes to execute.
;    Name the subroutine with that time to the nearest microsecond. e.g. _sub_350us.
;
; 2. Store the varible used in the subroutine in memocy address 0x400.
;    Hint: You will need to use the MOVLB command and the bank selection flag.
;    Remember to set the bank flag in MOVWF and DECF commands.
 
; Medium:
; 1. Use the code you created in the Basic task.
; 2. THe 7-segment displays should be off.
; 3. Create a sound subroutine that has a delay of 40 ms. This new subroutine should call the subroutine from the Basic task.
; 4. Use the stopwatch to ensure the timing is within 5%

; Advanced:
; 1. Nothing happens until PB2 is pressed.
; 2. Once PB2 is pressed, start the following sequence.
; 3. Use the code you created in the Medium task to turn the right-most LED on for 40 ms, then off for 40 ms and repeat.
; 4. However, if the PB1 is pressed, then instead pause for 400 ms LED on and 400 ms off.
 
 
    MOVLB 0X4
    MOVF var_count_200us, 0
    
    CALL _sub_200us_
    
 
;---------------------------------------------------Subroutine--------------------------------------------------------------------
_sub_200us_

    MOVLW 71
    MOVWF var_count_200us
    
L_DELAY
    NOP   ; 1 CYCLE: 0.4 us
    NOP   ; 1 CYCLE: 0.4 us
    NOP   ; 1 CYCLE: 0.4 us
    NOP   ; 1 CYCLE: 0.4 us
    
    DECF var_count_200us    ; 1 CYCLE: 0.4 us
    
    BNZ L_DELAY             ; 2 CYCLE: 0.8 us
    ; Total Delayed Time = 71 * 0.4 * 7 = 198.8 us (200 us) 
    
    RETURN 
    
    end
