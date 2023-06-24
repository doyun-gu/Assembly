; Name: [Doyun GU]
; UID:  [11095970]
    
    processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00
    
LATA equ 0xF89
TRISA equ 0xF92
PORTA equ 0xF80
LATC equ 0xF8B
TRISC equ 0xF94
PORTC equ 0xF82
LATF equ 0xF8E
TRISF equ 0xF97
PORTF equ 0xF85
LATH equ 0xF90
TRISH equ 0xF99
PORTH equ 0xF87
ADCON1 equ 0xFC1
SWITCHES equ 0x00
    
    ; Set switches of two parts as input
    MOVLW B'11110000' ; Set RH7-4 as input and RH3-0 as output
    MOVWF TRISH       ; Upper switches are input now
    MOVLW B'11111111' ; Set RC5-2 as input
    MOVWF TRISC       ; Lower switches are input now
    
    ; Set LEDs as output
    MOVLW B'11101111' ; Set LEDs as output
    MOVWF TRISA       ; Q3 as output
    MOVLW B'00000000' ; Set all the POrt F as Output
    MOVWF TRISF       ; LEDs are output

    ; Invert input into Digital
    MOVLW 0x0F        ; Value for ADCON1
    MOVWF ADCON1      ; Makes input in digital
    
    ; Set the start-up state for outputs
    MOVLW B'11111111' ; Set all the RH pins as high for the two Transistors
    MOVWF LATH        ; Transistors for 7-segment display off - active low
    MOVLW B'00000000' ; Set all the RA pins as low for the LEDs
    MOVWF LATA        ; Transistors for LEDs (RA4) off
    
    ; LEDs
L_MAIN
    MOVLW B'00010000' ; Set RA4 as input to turn on the Transistor Q3
    MOVWF LATA        ; Turn the Transistor Q3 on
    MOVLW B'00000011' ; Set RH1 and RH2 as low to turn off the Transistors Q1 and Q2
    MOVWF LATH        ; Turn the Transistors Q1 and Q2 off
    
    ;Switches for lower side
    MOVF PORTC, W     ; Move the value of Port C to the Working Register
    MOVWF SWITCHES    ; Move the value from the Working Register to SWITCHES
    RRNCF SWITCHES, F ; Shift right the value in the SWITHCES and store in the SWITCHES
    RRNCF SWITCHES, W ; Shift right the value in the SWITCHES and store in the Working Register
    ANDLW B'00001111' ; This will take only lower part of SWITCHES
    
    ; Switches for upper side
    MOVWF SWITCHES    ; MOve the value in the Working Register to the SWITCHES
    ANDLW B'11110000' ; Take only upper part of switches
    MOVF PORTH, W    ; Move the value in the Working Register to Switches
    IORWF SWITCHES, W ; Switches OR Working Reigster
    
    ; Move the value of LEDs pattern to LATF
    MOVWF LATF
    
    BRA L_MAIN
    end
