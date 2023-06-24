; Name: [Doyun GU]
; UID:  [11095970]
    
    processor 18F8722
    config OSC=HS, WDT=OFF, LVP=OFF
    radix decimal
    org 0x00

; Task info.
; - On the LEDs display the binary value of 100 decimal,
; - Every 200 ms count down the value on the LEDs until it reaches 0
; - Then stops
; - Exact accuracy is not required, but it must take between 19.5 to 20.5 seconds to count down.
    
; Solution
    ; Make sure you have set the instruction frequency up in the simulator.
    ; Add the standard header here with the SFR defines for ports A & F (TRIS & LAT)
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
    
    ; Varaibles
var_count_100us equ 0x01
var_count_10ms equ 0x02
var_count_200ms equ 0x03
var_led_value equ 0x04
 
; Set up the SRFs for using the LEDs
   MOVLW 0                ; set the LED pins as outputs
   MOVWF TRISF
   MOVWF TRISA            ; set the LED's transistor pin as output
   
; Set up the initial value for the counter to count down from
   MOVLW 100
   MOVWF var_led_value
   
L_DEC
   MOVF var_led_value, W  ; Put the value of var_led_values into W
   MOVWF LATF              ; Display the vlaue on the LEDs
   
   MOVLW B'00010000'       ; Set RA4 as high
   MOVWF LATA              ; Turn on the transistor for the LEDs
   
   ; Call statement
   CALL SUB_200ms          ; Using the simulator, step over this line to make sure it takes 200 ms
   
   MOVWF B'00000000'       ; Set RA4 as low
   MOVWF LATA              ; Turn off the transistor for the LEDs
   
; Decrease the value in var_led_value. I'll use ADDLW -1, but try DECF
    MOVF var_led_value, W
    ADDLW -1;              ; Reduce the value in W by 1
    MOVWF var_led_value    ; save new led value
    BNZ L_DEC              ; loop again if led value > 0
    
L_END
    BRA L_END              ; led value has reached 0. Stop here forever
    
;------------------------Subroutines defined below------------------------------
SUB_100us                  ; Creates a delay of 100 microseocnds
    MOVLW 35               ; Set the initial value for the var_count_100us variable. 
    MOVWF var_count_100us 
    
L_DELAY
    NOP                    ; Waste some time. Each instruction takes 0.4 us
    NOP                    ; Waste another 0.4 us
    NOP                    ; boring
    NOP                    ; yawn. the choice of the number of NOPs is up to you.
    DECF var_count_100us   ; Reduce the value of the var_count_100us variable
    BNZ L_DELAY            ; if var_count_100us is not yet zero then loop around
    ; THe loop contains 7 instructions cycles of delay (4xNOP+DECF+2forBNZ)
    ; It will be called 35 times, so 35 * 7 * 0.4 = 98 us. Plust the Call/Return + MOVLW and MOVWF, gives 100 us
    
    RETURN                 ; This is not included in the calculation of the loops.
    ; In addition to the loop there is also the delay from 2xMOV_RETURN (1.6 us)
    ; To increase the delay further, well call the SUB_100us subroutine many times
    
SUB_10ms                   ; This subroutine has a delay of approximately 10 ms
    MOVLW 99               ; We will call the SUB_100us approximately 100 times to get a 10 ms delay
    MOVWF var_count_10ms
    
L_innerloop_10ms
    CALL SUB_100us         ; Call that subroutine that wasted 100 us
    DECF var_count_10ms
    
    
    BNZ L_innerloop_10ms
    RETURN
    
; To increae the delay still further, well call the SUB_10ms subroutine in another loop
    
SUB_200ms                   ; This subroutine has a delay of approximately 200 ms
    MOVLW 20                ; The SUB_10ms takes 10 ms plust we have a few extra instructions
    MOVWF var_count_200ms   ; Well call the SUB_10ms nearly 20 times to get an approximately 200 ms delay
     
L_innerloop_200ms
    CALL SUB_10ms
    DECF var_count_200ms
    BNZ L_innerloop_200ms
    RETURN
    
    end
