; Doyun GU, UID:11095970
; Date: 24 Feb 2023
; Question 4 (Display two segment)

    processor 18F8722
    config OSC = HS, WDT = OFF, LVP = OFF
    radix decimal
    org 0x00
    
TRISA equ 0xF92
LATA equ 0xF89
TRISH equ 0xF99
LATH equ 0xF90
TRISF equ 0xF97
LATF equ 0xF8E

    CLRF TRISH
    CLRF TRISA ; Port A as output since RA4 controls Q3 which powers LEDs
    CLRF TRISF
    
L_MAIN
    ; First we flash on/off the bit pattern for the LEDs
    MOVLW B'10101010' ; The required bit pattern for the LEDs
    MOVWF LATF
    MOVWF B'00010000'
    MOVWF LATA ; Transistor (RA4) ON For LEDs
    MOVLW B'00000000'
    MOVWF LATA ; Transistor (RA4) OFF for LEDs
    
    ; The we flash on/off the bit pattern for the 7-segment
    MOVLW B'00001111' ; The ''t bit pattern for the 7-segment
    MOVWF LATF ; Set that bit pattern as the high/low output levels of Port F
    MOVLW B'11111110'
    MOVWF LATH ; Turn on U1 7-segment (RH0)
    MOVLW B'11111111'
    MOVWF LATH ; Turn off U1 7-segment (RH0)
    BRA L_Main ; Loop back to the L_Main label
    
    end
    
