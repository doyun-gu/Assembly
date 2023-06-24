; NAME: [DOYUN GU]
; UID:  [11095970]
    
    ; Standard Header
    processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00
    
; This code is for the whole structure
    
    ; Declare the variables
    
    ; SETUP: LEDs, PB1,2, Q(1,2,3) TRANSISTORS, ACCESS BANK
    
; Loop Starts
    
    ; CALL SWITCHES
    
    ; LED PATTERNs
    
    ; TURN OFF Q1 AND Q2 TRANSISTORS
    
    ; TURN ON Q3 TRANSISTOR
    
    ; DELAY BEFORE THE LEDs OFF
    
    ; TURN OFF Q3 TRANSISTOR
    
    ; DELAY AFTER THE LEDs OFF
    
    ; BRA Loop Starts
    
;------------------------------------------------------------------------------
; 3 Subroutines
    
    ; 7 * 71 * 0.4 = 200 us
    
    ; 200 * 200 us = 40 ms
    
    ; 10 * 40 ms = 400 ms 
    
    
; Switches
    
    ; Read Inputs: PORT B, J
    
    ; IF STATEMENT
    
    ; DEACTIVATE PB1 IF PB2 IS NOT PRESSED
    
    ; AND OPERATION
    
    ; STORE THE BUTTONS IN THE VARIABLE
    
    ; end
