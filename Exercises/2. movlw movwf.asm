processor 18F8722 ; What microprocessor we are using
    
config OSC = HS, WDT = OFF, LVP = OFF
; These configuration commands meaning:
; Oscillator = HIGH Speed,
; Watch Dog  Timer = OFF,
; Low Voltage Programming = OFF
    
    
radix decimal ; default base is decimal unless we state otherwise
org 0x00      ; set the origin of the programme to 0

    MOVLW 22 ; Move value (literal) 22 into the WReg
    MOVWF 10 ; Move the value stored in WReg in File address 10
    
    MOVLW B'00101001' ; Move binary value 00101001 to the WReg
    MOVWF 11          ; Move the value stored in WReg in File address 11
    
    MOVLW 0x15 ; Move heaxadecimal value 0x15 into WREG
    MOVWF 12   ; Move the value stored in WReg in File address 12
    
    MOVF 10, W ; Move the contents of File memory 10 into WReg
    ADDLW 0x1F ; Add the value (literal) 31 to WReg
    
    ADDWF 11, W ; Add the value in the WReg to the value in File Memory address 11, and put the result into the working register
    
    ADDWF 12, F ; Add the value in the WReg to the value in File Memory address 12, and put the result into File memory address 12
    
L_FOREVER
    BRA L_FOREVER ; Creates an infinite loop
    end           ; tells the compiler it is the end of the text.
    
    
