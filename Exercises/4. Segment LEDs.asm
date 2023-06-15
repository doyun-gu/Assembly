; Author = Doyun GU UID 11095970
; Date 20 Feb 2023
; Program = Display the symbol 'F' on the 7-segment display U1.
    
    Processor 18F8722
    config OSC = HS, WDT = OFF, LVP = OFF
    radix decimal
    org 0x00

; SFR definitions - USE defines for these addresses - much easier to read
; The 7-segment Q1, Q2 trasistors are connected to RH0, RH1. These PNP transistors are active low.
    
; In this example we will use DEFINES (equ) to represent the LAT and TRIS memory address since this makes the code easier to read
    
    LATH equ 0xF90 ; Control the GPIO high/low output level of port H.
    TRISH equ 0xF99 ; Control the GPIO direction of port H.
    LATF equ 0xF9E ; GPIO high/low level of Port F.
    TRISF equ 0XF97 ; GPIO direction of port F.
 
; Step 1: CONFIGURE the pins to be digital INPUT or OUTPUT using TRIS
    MOVLW B'11111100' ; Put this bit pattern into the WReg
    MOVWF TRISH ; Copy the WReg Value to TRISH to configure pins RH0, RH1 (PORTH) as outputs - for 7 segment transistors Q1, Q2
    
; Now we set up Port F to control the voltages on the individual LEDs. We first configure the pins to be outputs.
    CLRF TRISF; CLeaR - all TRISF = 0, i.e. set all port F as outputs
    
; Step 2: Set the high/low level of the outputs pins using LAT
    
    MOVLW B'11111110' ; Put this bit pattern into the WReg
    MOVWF LATH ; Copy the WReg value to LATH which sets pin RH0 low (port H). This turns on transistors Q1 for 7-segment U1. RH1 is high which turns off Q2 for 7-segment U2.
    
; The set up for the transistors on RH0 and RH1 has now been completed
; Now
    
    MOVLW B'00011110' ; Put this bit pattern into the WReg
    MOVWF LATF ; Copy the WReg value to LATF to set pins RF0, RF5, RF6 & RF7 to display the symbol ''F on U1
    
L_F BRA L_F ; loop on this line forever, i.e. end of programme
    
end
