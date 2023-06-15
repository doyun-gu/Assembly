    processor 18F8722
    config WDT=OFF, LVP=OFF, OSC=HS
    radix decimal
    org 0x00
  
; Remember the range of 8-bit twos-complement is -128 to +127
a_val equ 250
b_val equ 3
   ; b_val equ 8
   MOVLW b_val
   ADDLW a_val
   NOP           ; Have a loot at WREG in the watch window
   ; Check if the result is wrong! (Overflow occurred)
   
   BC a_plus_b_greaterthan_255
   NOP           ; If here then a+b result is ok
   
a_plus_b_greaterthan_255
   NOP           ; If here then a+b result is in error
   
   end
