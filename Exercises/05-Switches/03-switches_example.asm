; Name: [Doyun GU]
; UID:  [11095970]
    
; Program to:
; read switches as 8-bit twos complement representation
; Then trun on:
; LED 8 (left most) if number is positive
; LED 7 if number is negative
; Both LEDs if number equals to -2
; First add the standard header including the required SFRs
; Write the code from above section "reading switches a

    processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00

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
SWITCHES equ 0x00

    MOVLW B'11110000'    ; Set RH7-4 as input, RH3-0 as output
    MOVWF TRISH          ; Upper switches are input now and the transistor pins are output
    MOVLW B'11111111'    ; Set RC5-2 as input, can be all 1 because there is no transistor for RC
    MOVWF TRISC          ; Lower switches are input now
    MOVLW B'11101111'    ; RA4:Q3 as output for the LEDs
    MOVWF TRISA	         ; Q3 as output
    MOVLW B'00000000'    ; Set all the PORTF as Output
    MOVWF TRISF          ; LEDs as output
    MOVLW 0x0F           ; Value for ADCON1
    MOVWF ADCON1         ; Makes input in digital
    
    ; Set the start-up state for the outputs
    MOVLW B'11111111' ; Set the RH pins as high for the Two Transistors
    MOVWF LATH        ; Transistors for 7-segment display OFF - active low
    MOVLW B'00000000' ; Set the RA pins as low for the LEDs
    MOVWF LATA        ; Transistors for LEDS (RA4) OFF
    
L_MAIN
    
    BTFSS SWITCHES, 7
    BRA L_LED8_on
    
    MOVF SWITCHES, W
    ADDLW 2
    BZ L_LED78_on
    
    MOVLW B'00010000'
    MOVWF LATA
    
    MOVLW 0x0F
    MOVWF ADCON1
    
    
    
L_LED7_on
    MOVLW B'010000000'
    MOVWF LATF
    BRA L_MAIN
    
L_LED8_on
    MOVLW B'10000000'
    MOVWF LATF
    BRA L_MAIN
    
L_LED78_on
    MOVLW B'11000000'
    MOVWF LATF
    BRA L_MAIN
    
    end
