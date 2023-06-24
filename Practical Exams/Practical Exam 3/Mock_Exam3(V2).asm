; Name: [Doyun GU]
; UID:  [11095970]

; Basic:
; 1. Create a soubroutine that contains 4 NOPs, loops 71 times, and uses DECF to decrease the loop counter. 
;    In simulator mode, use a stopwatch to determine how long the subroutine takes to execute.
;    Name the subroutine with that time to the nearest microsecond. e.g. _sub_350us.
;
; 2. Store the varible used in the subroutine in memocy address 0x400.
;    Hint: You will need to use the MOVLB command and the bank selection flag.
;    Remember to set the bank flag in MOVWF and DECF commands.
 
; Medium:
; 1. Use the code you created in the Basic task.
; 2. The 7-segment displays should be off.
; 3. Create a sound subroutine that has a delay of 40 ms. This new subroutine should call the subroutine from the Basic task.
; 4. Use the stopwatch to ensure the timing is within 5%

; Advanced:
; 1. Nothing happens until PB2 is pressed.
; 2. Once PB2 is pressed, start the following sequence.
; 3. Use the code you created in the Medium task to turn the right-most LED on for 40 ms, then off for 40 ms and repeat.
; 4. However, if the PB1 is pressed, then instead pause for 400 ms LED on and 400 ms off.

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
    CALL GetSwitch       ; check for pushbutton
    
    MOVLW B'00000001'
    MOVWF LATF           ;set data - all LEDs will be on
    
    MOVLW B'000000011'   ;both segments off - does not need changing.
    MOVWF LATH
    
    MOVLW B'00010000'    ;leds on
    MOVWF LATA           ; RA4 set to high
    
    BTFSS Switches, 5    ;if switch pressed
    CALL DelaySub400ms   ;400ms
    
    BTFSC Switches, 5    ; if switch not pressed
    CALL DelaySub40ms    ;delay 40ms
    
    MOVLW B'00000000'    ;leds off
    MOVWF LATA           ; RA4 set to low
    
    BTFSS Switches, 5    ;if switch pressed
    CALL DelaySub400ms   ;400ms
    
    BTFSC Switches, 5    ; if switch not pressed
    CALL DelaySub40ms    ;delay 40ms
    
    BRA Main             ; loop to start
    
Delay_Sub_200us
    MOVLW 71
    MOVWF DelayCounter1,1;set counter, BSR used
InnerLoop1
    NOP                   ;waste a load of time
    NOP
    NOP
    NOP
    DECF DelayCounter1,1,1 ; decrease counter, BSR used 
    BNZ InnerLoop1         ;if counter not yet zero, loop
    RETURN
    
DelaySub40ms
    MOVLW 200;40ms/200us = 200 iterations
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
    
GetSwitch
    MOVFF PORTB, 0x06;pb2 is RB0
    MOVF PORTJ, W           ; read in PortJ for PB1
    
    BTFSC 0x06,0            ;if pb2 not pressed
    MOVLW B'00100000'       ;clear working reg - same as pb1 not being pressed
    ;effectively deactivated the effect of PB1
    
    ANDLW B'00100000'       ;only bit 5 needed
    MOVWF Switches
    RETURN
    
    end    ; do not forget the end statement!
