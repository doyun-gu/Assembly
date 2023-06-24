; Name: [Doyun GU]
; UID:  [11095970]
    
    processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00
    
DELAYC1 equ 0x00
DELAYC2 equ 0x01
DELAYC3 equ 0x02
 
    MOVLB 4    ; ALLOW TO ACCESS THE BANK 4
 
; MAIN CODE
; ...
; ...
; ...
 
; -------------------------------SUBROUTINE------------------------------------
; SUBROUTINE FOR 200 us/ 7 CYCLE * 0.4 us * 71 times = 200 us
 
SUB_200us
    MOVLW 71         ; NO. OF ROUTINE = 71
    MOVWF DELAYC1,1    ; STORE IN THE VALUE (71) IN DELAYC1
    
INNNER_LOOP1

    NOP              ; 1 CYLCE: 0.4 us
    NOP              ; 1 CYLCE: 0.4 us
    NOP              ; 1 CYLCE: 0.4 us
    NOP              ; 1 CYLCE: 0.4 us
    
    DECF DELAYC1     ; 1 CYCLE: 0.4 us, DECREASE THE VALUE OF DELAYC1(71)
    
    BNZ INNER_LOOP1    ; 2 CYCLE: 0.8 us, IF DELAYC1 IS NOT YET 0, JUMP BACK TO THE LINE "SUB_200us"
    
    RETURN
    
; SUBROUTINE FOR 40 ms/200us * 200 = 40 ms
    
SUB_40ms
    MOVLW 200        ; NO. OF ROUTINE = 200
    MOVWF DELAYC2    ; STORE IN THE VALUE (200) IN DELAYC2
    
INNER_LOOP2
    
    CALL SUB_200us   ; CALL DELAY 200 us
    
    DECF DELAYC2     ; DECREASE THE VALUE OF DELAYC2 (200)
    
    BNZ INNER_LOOP2     ; IF DELAYC2 IS NOT YET 0, JUMP BACK TO THE LINE "SUB_40ms"
    
    RETURN
    
; SUBROUTINE FOR 400 ms/40ms * 10 = 400 ms

SUB_400ms    
    
    MOVLW 10
    MOVWF DELAYC3
    
INNER_LOOP3
    
    CALL SUB_40ms
    
    DECF DELAYC3
    
    BNZ INNER_LOOP3
    
    RETURN 
