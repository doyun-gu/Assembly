
; Author = Doyun GU, UID = 11095970
; Date 20 Feb 2023
; Program: c = a + b + 9 using Data Memory locations DECIMAL 15, 16 and 17.
; Demonstrated using a = 5, b = 21 and put the result on the LEDs. 
; The header and code to perform the calculation c = a + b + 9 is given in the Simulation
; Exercise selection - copy that code here!
    
    processor 18F8722
    config OSC = HS, WDT = OFF, LVP = OFF
    radix decimal
    org 0x00
    
    MOVLW B'00000000'
    MOVWF 0xF97
    
    MOVLW 5
    MOVWF 1
    
    MOVLW 6
    ADDWF 1, W
    
    ADDLW 9
    MOVWF 0x11
    
; The result of the calculation is in 0x11 (the data memory location for the variable c).
; Step 1: CONFIGURE the pins to be digital INPUT or OUTPUT using TRIS
; We need to tell pin RA4 that it is an Output by since by default it is set as an input pin.
    
; The tristate (TRIS) register for port A is data memory location 0xF92
; To Set a pin as an output we need to set its TRIS value to 0. Since the bit for RA4 is the 5th bit from the rgiht, we set
    
    MOVLW B'11101111' ; W = 11101111
    MOVWF 0xF92 ; TRISA = [0xF92] = 11101111
    
; We also configure the whole 8 pins of latch F to be output pins
; We can do this quickly by using the Clear function (CLRF)
; CLRF sets the value contained in the given memory location to be B'00000000'
; The Tristate memory address for Port F is 0xF97
    
    CLRF 0xF98 ; 0XF97 <- 0 (0xF97 = 0)
    
; Step 2: Set the Output pins high (5 V) or low (0 V) using LAT
; Turn on the transistor Q3 that controls the 'LEDs Power.
; Pins RA4 is connected to this transistor, and RA4 is bit 4 of port A.
; Bit counting starts at bit 0 which is the right-most bit so bit 4 is the 5th bit from the right.
    
    MOVLW B'00010000' ; Bit 4 = high
; The Latch (LAT) register for port A is data memory location 0xF89
    MOVWF 0xF89 ; Latch A = [0xF89] = 00010000
; We set the LEDs to the value of the c variable but putting the value of memory location 0x11 onto the pins connected to port F
    
    MOVF 0x11, W ; W = c. We put the value of c into the WReg
    
; The Latch (LAT) register for port F is data memory location 0xF8E
    
    MOVWF 0xF8E ; LATF - [0XF8E] = c Copy the value of c to lATF
    
L_F BRA L_F ; loop_forever
    
end
