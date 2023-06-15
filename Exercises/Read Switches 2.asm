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
ADCON1  equ 0xFC1  
  
sw equ 0x0
; Set the ADCON1 to make all inputs digital - see section above
   CLRF TRISF           ; Set the whole of port F as Output with level high
   
   ; To use the LEDs we set RA4 as an Output with level high
   
   MOVLW B'11101111'
   MOVWF TRISA
   MOVLW B'00010000'    ; Turn the LED transistor (RA4) on
   MOVWF LATA
   MOVLW 0x0F
   MOVWF ADCON1
   SETF TRISC          
   SETF TRISH


