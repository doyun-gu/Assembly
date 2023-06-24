; Program to move 3 values into 3 memory locations
; Comments start with a ';'. The comiler ignores them
; The following lines are compiler directives, not assembly language cmds

	processor 18F8722
	config OSC = HS, WDT = OFF, LVP = OFF
	radix decimal
	org 0x00

  ; Assembly language commands start in the 2nd column
	MOVLW 22            ; Store a value (22) in the Working Register
	MOVWF 10            ; Copy the value (22) in the Working Register to data memory (10)
	MOVLW B'00101001'   ; Store a value (Binary value '00101001') in the Working Register
	MOVWF 11            ; Copy the value (Binary value '00101001') in the Working Register to data memory (11)
	MOVLW 0x15          ; Store a value (Hexadecimal value 15) in the Working Register
	MOVWF 12            ; Copy the value (Hexadecimal value 15) in the Working Register to data memory (12)

L_FOREVER             ; lables are placed in the first colum.
	BRA L_FOREVER

	end                 ; This not an assembler command, it just tells the comiler to stop reading the source code.
