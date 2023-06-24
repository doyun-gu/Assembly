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
var_count_20ms equ 0x041
var_count_40ms equ 0x042
var_count_4000ms equ 0x043
var_count_71 equ 0x044

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
; 2. The 7-segment displays should be off.
; 3. Create a sound subroutine that has a delay of 40 ms. This new subroutine should call the subroutine from the Basic task.
; 4. Use the stopwatch to ensure the timing is within 5%

; Advanced:
; 1. Nothing happens until PB2 is pressed.
; 2. Once PB2 is pressed, start the following sequence.
; 3. Use the code you created in the Medium task to turn the right-most LED on for 40 ms, then off for 40 ms and repeat.
; 4. However, if the PB1 is pressed, then instead pause for 400 ms LED on and 400 ms off.
 
    MOVLW 0
    MOVWF TRISA    ; SET TRANSISTOR Q3 AS OUTPUT SO THAT LEDs CAN BE CONTROLLED
    MOVWF TRISF    ; SET LEDs AS OUTPUT
    MOVWF TRISH    ; TURN OFF THE TRANSISTOR Q1 AND Q2 SO THAT SEGMENT LEDs ARE OFF
    MOVWF TRISJ    ; SET PIEZO SOUNDER AS OUTPUT
    
    MOVLB 0X4
    MOVF var_count_200us, 0
    
    MOVLW 71
    MOVWF var_count_71

    
L_MAIN
    NOP                 ; Do Nothing
    MOVLW 0
    MOVWF LATF          ; Turn off LEDs including Segment LEDs
    
    MOVLW B'00000011'
    MOVWF LATH
    MOVLW B'01000000'
    MOVWF LATJ          ; SET RJ6 AS HIGH TO GIVE VOLTAGE
    
    CALL _sub_200us_
    
    MOVLW B'00000000'
    MOVWF LATJ   
    
    MOVF var_count_71, W
    ADDLW -1
    MOVWF var_count_71
    BNZ L_MAIN
    
;---------------------------------------------------Subroutine--------------------------------------------------------------------
; Subroutine 200 us
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

; Subroutine 20 ms
_sub_20ms_
    
    MOVLW 99
    MOVWF var_count_20ms
    
L_DELAY_20ms
    CALL _sub_200us_
    DECF var_count_20ms
    
    BNZ L_DELAY_20ms
    
    RETURN
    
; Subroutine 40 ms
_sub_40ms_
    
    MOVLW 2
    MOVWF var_count_40ms
    
L_DELAY_40ms
    CALL _sub_20ms_
    
    DECF var_count_20ms
    BNZ L_DELAY_20ms
    
    RETURN
    
_sub_4000ms_
    
    MOVLW 100
    MOVWF var_count_4000ms
    
L_DELAY_4000ms
    CALL _sub_40ms_
    
    DECF var_count_4000ms
    BNZ L_DELAY_4000ms
    
    RETURN
    
    end
