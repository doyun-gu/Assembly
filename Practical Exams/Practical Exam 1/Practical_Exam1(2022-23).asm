; Name: [Doyun GU]
; Student ID: [11095970]
; Got Mark 100
    
    processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00
    
LATA equ 0xF89 ; Q3 Transistor
TRISA equ 0xF92
LATF equ 0xF8E ; Pattern for LEDs
TRISF equ 0xF97
LATH equ 0xF90 ; Q1 and Q2 Transistors
TRISH equ 0xF99
 
    MOVLW B'11111100' ; Put the binary value which means RH0 and RH1 as output (Q1 and Q2) in the Working Register
    MOVWF TRISH       ; Put the value of the binary value to the TRISH to configure RH0 and RH1 as output (Q1 and Q2 Transistors)
   
    CLRF TRISF ; Clear all TRISF = 0
    CLRF TRISA ; Clear all TRISA = 0
   
    MOVLW B'00000000' ; Put the binary value 0 to the Working Register
    MOVWF 0x03        ; Copy the value to the Data location 0x03
    
    BSF 0x03, 0       ; Set bit 0 to 1 of the 0x03
    BSF 0x03, 1       ; Set bit 1 to 1 of the 0x03
    BSF 0x03, 2	      ; Set bit 2 to 1 of the 0x03
    BSF 0x03, 3       ; Set bit 3 to 1 of the 0x03
    BSF 0x03, 4       ; Set bit 4 to 1 of the 0x03
    BSF 0x03, 5       ; Set bit 5 to 1 of the 0x03
    BSF 0x03, 6       ; Set bit 6 to 1 of the 0x03
    BSF 0x03, 7       ; Set bit 7 to 1 of the 0x03
    BTG 0x03, 6       ; Toggle bit 6 of the 0x03
    
L_Main                ; BRA will jump back to this line
    
    MOVF 0x03, W      ; Copy the value in the 0x03 to the Working Register
    MOVWF LATF        ; Put the value to the LATF (to display LEDs)
    MOVLW B'00010000' ; Set RA4 as high
    MOVWF LATA        ; Turn on Q3
    MOVLW B'00000000' ; Set All RA4 as low
    MOVWF LATA        ; Turn off Q3
    
    MOVLW B'01100100' ; Put the binary value to the Working Register (symbol of 3)
    MOVWF LATF        ; Put the value to the LATF (to display on left segment LEDs)
    MOVLW B'11111101' ; Put the binary value to the Working Reigster
    MOVWF LATH        ; Turn on Q2 (RH1)
    MOVLW B'11111111' ; Put the binary value to the Working Register
    MOVWF LATH        ; Turn off Q2 (RH1)
    
    MOVLW B'10000101' ; Put the binary value to the Working Register (symbol of U)
    MOVWF LATF        ; Put the vlaue to the LATF (to display on right segment LEDs)
    MOVLW B'11111110' ; Put the binary value to the Working Register
    MOVWF LATH        ; Turn on Q1 (RH0)
    MOVLW B'11111111' ; Put the binary value to the Working Register
    MOVWF LATH        ; Turn off Q1 (RH0)
     
    BRA L_Main        ; Loop back to the line L_Main
    end               ; Tell the compiler that the code is ended
