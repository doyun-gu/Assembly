; Name: [Doyun GU]
; UID:  [11095970]

    processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00
    
    ; This code is for building the subroutine for switches
    
SWITCHES equ 0X01
    
READ_SWITCHES
    
    ; READ THE VALUE FROM THE SWITCHES
    MOVFF PORTB, 0X06    ; STORE THE DATA FROM THE PB2 IN 0x06
    MOVF PORTJ, W        ; MOVE THE DATA FROM THE PB1 IN WORKING REGISTER
    
    ; IF STATEMENT FOR PB2
    BTFSC 0X06, 0        ; PRSSED (0): SKIP/IF NOT PRESSED (1): CONTINUE
    
    ; CASE 1: PB2 IS NOT PRESSED, EXECUTE FROM THE CODE BELOW
    MOVLW B'00100000'    ; PB1 IS DEACTIVATED
    
    ; CASE 2: PB1 IS PRESSED, EXECUTE FROM THE CODE BELOW
    ANDLW B'00100000'    ; AND OPERATION WITH WORKING REGISTER
    
    ; STORE IN THE VARIABLE "SWITCHES"
    MOVF SWITCHES
    
    RETURN
