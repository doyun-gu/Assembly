; - get number from left hand switches
; - get number from right hand switches
; - Compare
; - if R>L, flash LED at 1Hz for example


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
 
    ; Basic Setup: Switches, Transistors, LEDs, ADCON1
    
    ; ADCON1
    MOVLW 0XF
    MOVWF ADCON1
    
    ; SWITCHES (INPUT)
    MOVLW B'11111111'
    MOVWF TRISB
    MOVWF TRISH
    MOVWF TRISJ
    
    ; LEDs (OUTPUT)
    MOVLW B'00000000'
    MOVWF TRISF
    
    ; TRANSISTORS (OUTPUT)
    ; Q1 n Q2
    MOVLW B'11110000'
    MOVWF TRISH
    
    ; Q3
    MOVLW B'11101111'
    MOVWF TRISA
    
;------------------------MAIN LOOP STARTS-------------------------------- 
L_MAIN
    ; Call Reading Values
    CALL READ_SWITCHES
    
    ; left Switch - right Switch
    
    MOVF R_SWITCHES, W
    SUBWF L_SWITCHES
    
    BN FLASHLEDs
    
    BRA L_MAIN
   
;-------------------------------READ SWITCHES-----------------------------------
R_SWITCHES equ 0x01
L_SWITCHES equ 0x02
 
READ_SWITCHES
    ; Reading Right side of the Switches (RC2-5)
    MOVFF PORTC, R_SWITCHES
    
    ; Clear the data we don't need
    MOVLW B'00111100'
    
    ANDWF R_SWITCHES
    
    ; Shift Twice
    RRNCF R_SWITCHES, F
    RRNCF R_SWITCHES, F
    
    ; Reading Left side of the Switches (RH4-7)
    MOVFF PORTH, L_SWITCHES
    
    ; Clear the data we don't need
    MOVLW B'11110000'
    ANDWF L_SWITCHES
    
    ; Shift 4 times
    RRNCF L_SWITCHES, F
    RRNCF L_SWITCHES, F
    RRNCF L_SWITCHES, F
    RRNCF L_SWITCHES, F
    
    RETURN
    
;---------------------------------FLASHLEDs-------------------------------------
FLASHLEDs
    ; PATTERN OF LEDs
    MOVLW B'10000000'
    MOVWF LATF
    
    ; TURN OFF Q1  n Q2 TRANSISTORS
    MOVLW B'11111111'
    MOVWF LATH
    
    ; TURN ON Q3 TRANSISTOR
    MOVLW B'00010000'
    MOVWF LATA
    
    ; DELAY
    CALL DELAY_150ms
    
    MOVLW B'11000000'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'11100000'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'11110000'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'11111000'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'11111100'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'111111110'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'11111111'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'01111111'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'00111111'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'00011111'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'00001111'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'00000111'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'00000011'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'00000001'
    MOVWF LATF
    
    CALL DELAY_150ms 
    
    MOVLW B'00000001'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'00000011'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'00000111'
    MOVWF LATF
    
    CALL DELAY_150ms

    MOVLW B'00001111'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'00011111'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'00111111'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'01111111'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    MOVLW B'11111111'
    MOVWF LATF
    
    CALL DELAY_150ms
    
    
    RETURN
    
DC1 equ 0x03
DC2 equ 0x04
DC3 equ 0x05

;------------------------------------DELAY--------------------------------------
DELAY_500us
    MOVLW 178
    MOVWF DC1
    
Inner_L1
    NOP
    NOP
    NOP
    NOP
    DECF DC1
    
    BNZ Inner_L1
    
    RETURN
    
DELAY_50ms
    MOVLW 100
    MOVWF DC2
    
Inner_L2
    CALL DELAY_500us
    
    DECF DC2
    
    BNZ Inner_L2
    
    RETURN
    
DELAY_150ms
    MOVLW 3
    MOVWF DC3
    
Inner_L3
    CALL DELAY_50ms
    
    DECF DC3
    
    BNZ Inner_L3
    
    RETURN
    
    end
     
