; NAME: [DOYUN]
; UID:  [11095970]
    
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
 
; LOOP START
L_MAIN

;------------------------------------PB2----------------------------------------
    ; CHANGE ANALOGUE INTO DIGITAL
    MOVLW 0X0D
    MOVWF ADCON1    ; ANALOGUE IS CHANGED INTO DITIAL INPUT
    
    ; SET PB2
    MOVLW B'00000001'    ; SET RB0 AS INPUT
    MOVWF TRISB
    
    MOVLW B'11111110'    ; SET RB0 AS LOW SO PB2 IS ACTIVATED
    MOVWF LATB
    
    ; READ PB2
    MOVF PORTB, W        ; READ THE VALUE OF PORTB AND MOVE THE VALUE TO THE WORKING REGISTER
    MOVWF 0X00
    
    ; IF STATEMENT
    BTFSS 0X00, 0        ; CHECK THE BIT0 OF 0X00. 1: SKIP THE CODE 0: EXECUTE THE RIGHT AFTER CODE
    
    MOVLW B'00100110'    ; LEFT LED PATTERN
    ANDWF 0X00           ; AND OPERATION BETWEEN WORKING REGISTER AND 0X00
        
    MOVLW B'00000000'    ; SET ALL PORT F AS OUTPUT
    MOVWF TRISF
    
    MOVLW B'11111111'
    MOVWF LATF
    
    MOVLW B'11111100'    ; SET RH0 AND RH1 AS OUTPUT
    MOVWF TRISH
    
    MOVLW B'11111101'    ; SET RH1 AS LOW SO THAT Q2 TRANSISTOR IS TURNED ON (LEFT SEGMENT LEDS)
    MOVWF LATH
    
    MOVF 0X00, W         ; MOVE THE VALUE (SEGMENT LEDs PATTERN IF PB2 IS PUSHED) TO LEDs
    MOVWF LATF
    
    MOVLW B'11111111'    ; TURN OFF ALL TRANSISTOR Q2 AND Q1
    MOVWF LATH
    
    MOVLW B'00000000'    ; CLEAR PORTF
    MOVWF LATF

;-------------------------------------LEDs---------------------------------------
    ; SET LEDs
    MOVLW B'11101111'    ; SET RA4 AS OUTPUT (Q3)
    MOVWF TRISA
    
    MOVLW B'00010000'    ; SET RA4 AS LOW SO Q3 IS POWERED
    MOVWF LATA
    
    ; SET SWITCHES 1-3
    MOVLW B'00011100'    ; SET RC2-4 AS INPUT
    MOVWF TRISC
    
    ; READ THE PORTC
    MOVF PORTC, W
    MOVWF 0X02
    
    ; SHIFT TWICE SO THAT SWITCHES CORRESPONDS WITH BIT 0-2
    RRNCF 0X02, F
    RRNCF 0X02, W
    
    ANDLW B'00000111'
    MOVWF LATF
    
    ; TURN OFF Q3
    MOVLW B'11111111'
    MOVWF TRISA
    
    BRA L_MAIN
    end
