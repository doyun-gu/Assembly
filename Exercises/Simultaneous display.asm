    processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00
    
TRISA equ 0xF92
LATA equ 0xF89
TRISC equ 0xF94   ; Lower 4 switches RC3-0
PORTC equ 0xF82
TRISF equ 0xF97   ; LEDs
LATF equ 0xF8E
TRISH equ 0xF99   ; Transistors (RH1-0) & switches (RH7-4)
LATH equ 0xF90    ; Transistors Q1, Q2 for 7-segment U1, U2, RH0, RH1
PORTH equ 0xF87   ; Upper four switches (RH7-4)
ADCON1  equ 0xFC1 ; 
 
   ;First we set up the tristate registers to set the pins as inputs/outputs
    MOVLW B'11110000' ; RH7-4 as Inputs, and RH3-0 as Outputs
    MOVWF TRISH       ; MAKING SWITCHES INPUTS AND THE TRANSISTOR PIN OUTPUT
    MOVLW B'11101111'
    MOVWF TRISA       ; TRANSISTOR (RA4: Q3) FOR LEDS AS OUTPUT
    MOVLW B'11111111'
    MOVWF TRISC       ; SWITCHES (RC3-0) AS INPUTS
    MOVLW B'00000000' ; SET all of port F as OUTPUT
    MOVWF TRISF       ; LEDS AS OUTPUTS
    MOVLW 0x0F        ; Value for ADCON1, see the section above for details
    MOVWF 0xFC1       ; ADCON1 MAKES INPUTS DIGITAL
   
    ; SET the start-up state for the outputs (high or low) to turn the two 7-segment displays off
    MOVLW B'11111111' ; Set the RH pin high for the two transistors
    MOVWF LATH        ; Transistors for SEVEN SEGMENT DISPLAY OFF -active low
    MOVLW B'00000000'
    MOVWF LATA        ; Transistor (RA4) for LEDS OFF

; Now we write the main programme loop
L_MAIN                ; label placed in the first column. We will BRA back to here at the end
    
    MOVF PORTC, W
    ANDLW B'00111100' ; mask - set to zero the bits we don't need
    MOVWF LATF        ; Set the values as the outputs (latch)
    MOVLW B'00010000' 
    MOVWF LATA        ; Transistor (RA4) ON for LEDs
    MOVWF B'00000000'
    MOVWF LATA        ; Transistor (RA4) OFF for LEDs

    ; Read the switches values from PORTH, mask the ones we want, invert htem, and set them to the 7-segment
    MOVF PORTH, W     ; read the values from the left 4 switches
    ANDLW B'11110000' ; mask - set to zero the bits we don't need
    MOVWF 0x1         ; well temporally put the value in data memory location 0x1 so that we can use COMF to complement (invert) the values of PORTH
   

    COMF 0x1, W       ; COMPLEMENTS (invert) the bits. WE do this since the 7-segment is active low.
    MOVWF LATF        ; Set the values as the outputs (latch)
    MOVLW B'11111110'
    MOVWF LATH        ; Turn on for 7-segment display - RH0 transistor low
    MOVLW B'11111111' 
    MOVWF LATH        ; Turn off for 7-segment display - RH0 transistor high
   
    BRA L_MAIN        ; Jump back to the start of the program to loop around again
    end               ; end is not an assembly instruction, it just tells the compiler not to compile anything after this point
