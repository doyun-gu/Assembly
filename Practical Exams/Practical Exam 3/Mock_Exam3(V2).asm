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
;variables:
DelayCounter1 equ 0x00
DelayC2 equ 0x01
DelayC3 equ 0x02
Switches equ 0x03

;setup TRIS - non used pins set to input to protect pins

    MOVLW B'00000000'    ;for anything all output
    MOVWF TRISF
 
    MOVLW B'11111111'    ; Anything all input
    MOVWF TRISC
    MOVWF TRISB
    MOVWF TRISJ
 
    MOVLW B'11110000'    ; First pins for transistors, last for switches
    MOVWF TRISH
 
    MOVLW B'11101111'    ;For controlling LED transistor - RA4 
    MOVWF TRISA
    
    MOVLB 4; Set BSR

Main 

    CALL GetSwitch; check for pushbutton
    
    MOVLW B'11111111'
    MOVWF LATF;set data - all LEDs will be on
    
    MOVLW B'000000011'     ;both segments off - does not need changing.
    MOVWF LATH
    
    MOVLW B'00010000'      ;leds on
    MOVWF LATA; RA4 set to high
    
    BTFSS Switches, 5      ;if switch pressed
    CALL DelaySub400ms;400ms
    
    BTFSC Switches, 5      ; if switch not pressed
    CALL DelaySub40ms      ;delay 40ms
    
    MOVLW B'00000000'      ;leds off
    MOVWF LATA             ; RA4 set to low
    
    BTFSS Switches, 5      ;if switch pressed
    CALL DelaySub400ms     ;400ms
    
    BTFSC Switches, 5      ; if switch not pressed
    CALL DelaySub40ms      ;delay 40ms
    
    BRA Main; loop to start
    
Delay_Sub_200us
    MOVLW 71
    MOVWF DelayCounter1,1   ;set counter, BSR used

InnerLoop1
    NOP;waste a load of time
    NOP
    NOP
    NOP
    DECF DelayCounter1,1,1  ; decrease counter, BSR used 
    BNZ InnerLoop1          ;if counter not yet zero, loop
    RETURN
    
DelaySub40ms
    MOVLW 200               ;40ms/200us = 200 iterations
    MOVWF DelayC2

InnerLoop2
    CALL Delay_Sub_200us    ;call 200us delay
    DECF DelayC2            ; decrease counter
    BNZ InnerLoop2          ;if counter not yet zero, loop
    RETURN   
    
DelaySub400ms
    MOVLW 10                ;overflows if using 2000x200us, so instead use 10x40ms
    MOVWF DelayC3

InnerLoop3
    CALL DelaySub40ms       ;call 40ms delay 
    DECF DelayC3            ; decrease counter
    BNZ InnerLoop3          ;if counter not yet zero, loop
    RETURN
    
GetSwitch; Reads PB1
    MOVF PORTJ, W          ; read in PortJ for PB1
    ANDLW B'00100000'      ;only J5 needed
    MOVWF Switches
    RETURN
    
    end ; do not forget the end statement!
