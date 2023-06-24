; Q1
; Name: [Doyun GU]
; UID:  [11095970]

processor 18F8722
config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
org 0x00

p equ 121

    CALL sub_1, 0
    
L1 BRA L1
sub_1

    MOVLW p
    MOVWF 0x5, 0
    MOVWF 0x0, 0
loop

    RRNCF 0x0, F, 0
    ADDWF 0x5, F, 0
    BNZ loop

    RETURN 0

    end
