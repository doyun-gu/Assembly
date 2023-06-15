Mock Exam 4 tasks:
; Create a project and assembly program in the c:\work directory (You will use the S: drive in the real exam). Make sure your name and ID are written at the top of this program.
; Write an assembly language program to perform the following tasks repeatedly:
; • read an 8-bit two’s complement value x from the eight toggle switches (SW1A)
; • Turn on LED LD7 if x < 44
; • Turn on LED LD8 if x = -2
; • Flash LED LD1 at 1 Hz if x > 23
; Note: If x = -2 then you should illuminate both LD7 and LD8
; You should check for twos complement overflow (BOV) as well as the negative flag (BN).
; All displays should be off unless otherwise stated.
; Upload your .asm file to Blackboard from the c:\work directory before the end of the exam. You only have one attempt for this upload.

; Name: [Doyun GU]
; UID : [11095970]

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
 
; Display switches 0-7 as an 8 bit unsigned binary number
; If x>40, display '4' on display U2, toggling on and off every 500ms
 
    ; Basic Setup
    ; SWITCHES - INPUT
    MOVLW B'11111111'
    MOVWF TRISC
    MOVWF TRISH
    MOVWF TRISJ
    
    ; LEDs - OUTPUT
    MOVLW B'00000000'
    MOVWF TRISF
    
    ; TRANSISTORS - OUTPUT
    ; Q1 & 2 (RH0-1)
    MOVLW B'11110000'
    MOVWF TRISH
    
    ; Q3 (RA4)
    MOVLW B'11101111'
    MOVWF TRISA
    
    ; DIGITAL - ANALOGUE
    MOVLW 0x0F
    MOVWF ADCON1
    
;------------------------------MAIN LOOP STARTS---------------------------------
L_MAIN
    ; CALL READING VALUES
    CALL READING_SWITCHES
    
    MOVF ALLSWITCHES, W
    
    ; SWITCH VALUE - 40
    SUBLW 40
    
    ; WHEN SWITCH VALUE > 40
    BNC FLASHLEDs
    
    BRA L_MAIN
    
; -----------------------------READING SWITCHES---------------------------------
RSWITCHES equ 0X00
LSWITCHES equ 0x01
ALLSWITCHES equ 0x02
 
READING_SWITCHES
 
    ; RIGHT SIDE OF SWITCHES
    MOVF PORTC, W
    MOVWF RSWITCHES
    
    RRNCF RSWITCHES, F
    RRNCF RSWITCHES, W
    
    ANDLW B'00001111'
    
    MOVWF RSWITCHES
    
    ; LEFT SIDE OF SWITCHES
    MOVF PORTH, W
    MOVWF LSWITCHES
    
    IORWF RSWITCHES
    
    MOVF RSWITCHES, W
    MOVWF ALLSWITCHES
    
    RETURN

;----------------------------------FLASH LEDs-----------------------------------
    ; LEDs PATTERN (4)
FLASHLEDs
    MOVLW B'00110101'
    MOVWF LATF
    
    ; TURN OFF Q3 TRANSISTOR
    MOVLW B'00000000'
    MOVWF LATA
    
    ; TURN ON Q2 TRANSISTOR
    MOVLW B'11111101'
    MOVWF LATH
    
    ; CALL DELAY
    CALL sub_500ms
    
    ; TURN OFF TRANSISTOR Q2
    MOVLW B'11111111'
    MOVWF LATH
    
    CALL sub_500ms
    
    BRA L_MAIN
    
;------------------------------DELAY SUBROUTINE---------------------------------
DC1 equ 0x03
DC2 equ 0X04
DC3 equ 0x05
 
sub_500us
    MOVLW 176
    MOVWF DC1
    
INNER_L1
    NOP
    NOP
    NOP
    NOP
    
    DECF DC1
    BNZ INNER_L1
    
    RETURN
    
sub_50ms
    MOVLW 100
    MOVWF DC2
    
INNER_L2
    
    CALL sub_500us
    
    DECF DC2
    
    BNZ INNER_L2
    
    RETURN
    
sub_500ms
    MOVLW 10
    MOVWF DC3
    
INNER_L3
    
    CALL sub_50ms
    
    DECF DC3
    
    BNZ INNER_L3
    
    RETURN
    
    end
