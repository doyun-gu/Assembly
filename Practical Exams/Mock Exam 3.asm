; Mock Exam 3 Tasks:
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
    ; LEDs
    MOVLW B'00000000';for anything all output
    MOVWF TRISF
    
    ; Switches
    MOVLW B'11111111' ; Anything all input
    MOVWF TRISB
    MOVWF TRISJ
 
    ; Q1 and Q2 Transistors (Segment LEDs)
    MOVLW B'11110000'; First pins for transistors, last for switches
    MOVWF TRISH
 
    ; Q3 Transistor (LEDs)
    MOVLW B'11101111';For controlling LED transistor - RA4 
    MOVWF TRISA
    
    ; Access Bank
    MOVLB 4; Set BSR
    
; Main Loop Starts
Main 
    
    ; Subroutine for Switches
    CALL ReadSwitch        ; CHECK FOR PUSHBUTTON
    
    ; LEDs PATTERN
    MOVLW B'11111111'
    MOVWF LATF            ; SET LEDs PATTERN DATA
    
    ; Turn off Q1 and Q2 Transistors
    MOVLW B'000000011'   
    MOVWF LATH            ; BOTH SEGMENTS ARE OFF
    
    ; Turn on Q3 Transistor
    MOVLW B'00010000'     
    MOVWF LATA            ; SET RA4 AS HIGH SO THAT Q3 TRANSISTOR IS TURNED ON
    
    ; Delay for before the LEDs Turned off
    ; IF STATEMENTS FOR PB1 SWITCH
    BTFSS Switches, 5    ; IF STATEMENT PUSHED (0): CONTINUE, NOT PUSHED (1): SKIP
    
    ; PB1 IS NOT PUSHED
    CALL DelaySub400ms   ; 400ms - Not pushed
    
    ; PB1 IS PUSHED
    BTFSC Switches, 5    ; IF STATEMENT PUSHED (0): SKIP, NOT PUSHED (1): CONTINUE
    
    ; PB1 IS PUSHED
    CALL DelaySub40ms    ; DELAY 40ms
    
    ; PB1 IS NOT PUSHED
    
    ; TURN OFF Q3 TRANSISTOR
    MOVLW B'00000000';leds off
    MOVWF LATA; RA4 set to low
    
    ; Delay for after the LEDs Turned off
    ; IF STATEMENT FOR PB1 SWITCH
    BTFSS Switches, 5    ; IF STATEMENT PUSHED (0)= CONTINUE, NOT PUSHED (1)= SKIP
    
    ; PB1 IS NOT PUSHED
    CALL DelaySub400ms   ; DELAY 400ms
    ; PB1 IS PUSHED
    BTFSC Switches, 5    ; IF STATEMENT: PUSHED (0)= SKIP, NOT PUSHED (1)= CONTINUE
    ; PB1 IS PUSHED
    CALL DelaySub40ms    ; DELAY 40ms
    ; PB1 IS NOT PUSHED
    BRA Main             ; JUMP TO THE LINE Main 
    
;-----------------------SUBROUTINE STARTS----------------------------

; DELAY 200us
Delay_Sub_200us
    MOVLW 71
    MOVWF DelayCounter1,1    ; SET COUNTER, BSR (Bank Select Register) used
    
InnerLoop1
    NOP                      ; 1 Cycle: 0.4 us 
    NOP                      ; 1 Cycle: 0.4 us
    NOP                      ; 1 Cycle: 0.4 us
    NOP                      ; 1 Cycle: 0.4 us
    DECF DelayCounter1,1,1   ; 1 Cylce, Decrease counter, BSR used 
    BNZ InnerLoop1           ; 2 Cycle, Jump back to the Line "InnerLOOP1" until the value is not 0 
    RETURN

; DELAY 40ms
DelaySub40ms
    MOVLW 200                ; 200us * 200 = 40 ms
    MOVWF DelayC2
    
InnerLoop2
    CALL Delay_Sub_200us     ; Call 200us delay
    DECF DelayC2             ; Decrease counter
    BNZ InnerLoop2           ; If counter not yet zero, Jump Back to the Line "InnerLOOP2"
    RETURN   
    
; Delay 400ms
DelaySub400ms
    MOVLW 10                 ; 40 ms * 10 = 400 ms
    MOVWF DelayC3
    
InnerLoop3
    CALL DelaySub40ms        ; Call 40ms delay 
    DECF DelayC3             ; Decrease counter
    BNZ InnerLoop3           ; If counter not yet zero, Jump Back to the Line "InnerLOOP3"
    RETURN
 
; Switches
ReadSwitch
    
    MOVFF PORTB, 0x06    ; MOVE THE READING VALUE (PORTB-PB2 (RB0) TO 0x06 
    MOVF PORTJ, W        ; READ PORTJ (PB1) AND MOVE IT TO WORKING REGISTER
    
    BTFSC 0x06,0         ; IF STATEMENT: PB2 IS NOT PRESSED (1) = CONTINUE, PB2 IS PRESSED (0) = SKIP
    
    ; PB2 IS NOT PRESSED - DEACTIVATE THE PB1
    MOVLW B'00100000'    ; Clear the WORKING REGISTER - Same as PB1 not being pressed (RJ5 IS HIGH)
    
    ; PB2 IS PRESSED - DEACTIVATE THE EFFECT OF PB1
    ANDLW B'00100000'    ; Only bit 5 needed
    
    MOVWF Switches       ; STORE THE DATA OF SWITCHES VALUE IN THE SWITCHES
    RETURN
    
    end
