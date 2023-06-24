; Name: [Doyun GU]
; UID:  [11095970]

; Is var1 >=< var2?
; Where both numbers, & the result, are to be seen as unsigned representation.
    
; Create a define for a variable
    processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00
    
var1 equ 0x01
var2 equ 0x02

; Modify it to try other numbers for var1 and var2
    MOVLW 5    ; Test with var1=5, Twos-complement representation
    MOVWF var1 ; Put the test value into var1
    MOVWF 0   ; Test with var2=-6. Twos-complement representation
    MOVWF var2 ; Put the vtest value into var2
 
;Move the var1 into the Wreg
    MOVF var1, W  ; This is in twos-complement representation (128 is the maximum value in 8-bit twos-complement)
    
; Since we are comparing the variable agianst a variable, we use SUBWF
    SUBWF var2    ; SUBWF is "Subtract W from F so as W=var1 and F=var2
 
; result=var2-var1
; If var1==var2, then the Zero flag will be set
;var1, var2 result are in twos-complement representation in this example
; If var1<var2, then the result must be positive, but we must also check OV
; If var1>var2, then the result is Negative, but we must also check OV
    
    BZ L_var1_equals_var2       ; Branch to label if Zero Flag is set
    BN L_var1_gt_var2_if_no_0V
    
; If reached here then var1<var2, if no Overflow flag
    
    BOV L_var1_greaterthan_var2 ; If an overflow occurred then the opposite logic is true
    BRA L_var1_less_than_var2   ; No overflow, so var1 < var2 is correct
    
L_var1_gt_var2_if_no_0V         ; If reached here than var1 > var2 is correct
    
    BOV L_var1_less_than_var2   ; If an overflow occured then the opposite logic is true
    BRA L_var1_greaterthan_var2 ; No overflow, so var1 > var2 is correct
    
; ------------------ The comparison Result is given below ---------------    
L_var1_equals_var2
    NOP              ; Breakpoint here for var1 == var2    
L2 BRA L2            ; Stop here
    
L_var1_greaterthan_var2
    NOP              ; Breakpoint here for var1 > var2
L1 BRA L1            ; Stop here
    
L_var1_less_than_var2
    NOP              ; Breakpoint here for var1 < var2
L3 BRA L3            ; Stop here
    
    end


