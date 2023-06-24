;Name: [Doyun GU]
;UID:  [11095970]
 
;Is var1 >=< 10?
;Where both numbers, & the result, are to be seen as unsigned representation.
    
    processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00
; Create a define for data memory address of a varaible    
var1 equ 0x01    

; Modify it to try other numbers for var1
    MOVLW 5                ; Test with var1=5 to see if it is <10
    MOVWF var1             ; Put the test value into var1

; Move the variable into the Wreg
    MOVF var1, W           ; This is in twos-complement representation (128 is the maximum value in 8-bit twos-complement)

; Since we are comparing the variable against a literal, we can use SUBLW
; SUBLW is "Subtract WREG from Literal", i.e. result = LIT - W
    SUBWF 10
; result = 10 - var1
; If var == 0, then the zero flag will be set
; var is in unsigned representation in this example
; If var < 10, then no borrow is required so non-borrow flag (C) is set (1)
; If var > 10, then the result is negative so the result is invaild and not-borrow flag (C) is clear (0)

    BZ L_var_equals_10      ; Branch to L_var_equals_10 if Zero flag is set.
    BC L_var_less_than_10   ; Branch there if not-borrow flag is set (i.e. if no borrow was required)

;If reached here than var > 10
    NOP                      ; Breakpoint here for var > 10
L1 BRA L1                    ; Stop here

L_var_equals_10
    NOP                      ; Breakpoint here for var == 10
    
L2 BRA L2                    ; Stop here
    
L_var_less_than_10
NOP                          ; Breakpoint here for var < 10
    
L3 BRA L3                    ; Stop here
    
end
