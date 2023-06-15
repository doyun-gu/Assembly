; Mock Exam 1: Display symbol of "U" on the Right Segment LED.

; Name: [Doyun GU]
; Student ID: [11095970]
    
    Processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00


LATA equ 0xF89 ; Controlling the Q3 Transistors
TRISA equ 0xF92
LATF equ 0xF8E ; Pattern for LEDs
TRISF equ 0xF97
LATH equ 0xF90 ; Controlling the Q1 and Q1 Transistors
TRISH equ 0xF99
 
    MOVLW B'11111100' ; Put this pattern into the Working Register
    MOVWF TRISH       ; Copy the WReg value to TRISH to configure pin RH0 and RH1 as outputs - Q1 and Q2 Transistors for Segment LEDs
   
    CLRF TRISF ; Clear all TRISF = 0, Set all port F as outputs
    CLRF TRISA ; Clear all TRISA = 0, Set all port A as outputs - To configure all pins for Port A as outputs
   
    MOVLW B'11111111' ; Put the binary value (-1) to the Working Register
    MOVWF 0x8         ; Copy the value from the Working Register to the data memory 0x8
   
    BTG 0x8, 0    ; toggle bit 0 of memory location 0x8
    BCF 0x8, 7    ; clear bit 7 of memory location 0x8
   
L_Main
   
    MOVF 0x8, W       ; Put this pattern into the Working Register
    MOVWF LATF	     ; Copy the WReg value to LATF to set pins to display the symbol
    MOVLW B'00010000' ; Set RA4 as high as it is an NPN Transistor
    MOVWF LATA        ; Copy the value to the LAT_A Register (Turn Q3 on)
    MOVLW B'00000000' ; Set RA4 as low as it is an NPN Transistor
    MOVWF LATA        ; Copy the value to the LAT_A Register (Turn Q3 off)
   
    MOVLW B'00100110' ; Put this pattern into the Working Register
    MOVWF LATF        ; Copy the WReg value to LATF to set pins to display the sybol (S)
    MOVLW B'11111101' ; Set RH1 as output
    MOVWF LATH        ; Copy the value to the LAT_H Register (Turn Q2 on)
    MOVLW B'11111111' ; Set RH1 as low
    MOVWF LATH        ; Copy the value to the LAT_H Register (Turn Q2 off)
   
    MOVLW B'10000101' ; Put this pattern into the Working Register
    MOVWF LATF        ; Copy the WReg value to LATF to set pins to display the symbol (U)
    MOVLW B'11111110' 
    MOVWF LATH        ; Copy the value to the LAT_H Register (Turn Q1 on)
    MOVLW B'11111111' 
    MOVWF LATH        ; Copy the value to the LAT_H Register (Turn Q1 off)
   
    BRA L_Main        ; Loop back to the L_Main Label
    end               ; tells the compiler it is the end of the text
