  LIST P=18f4550
 INCLUDE "P18F4550.INC" 
 
  CONFIG  CCP2MX = ON           ; CCP2 MUX BIT (CCP2 INPUT/OUTPUT IS MULTIPLEXED WITH RC1)
    CONFIG  PBADEN = ON           ; PORTB A/D ENABLE BIT (PORTB<4:0> PINS ARE CONFIGURED AS ANALOG INPUT CHANNELS ON RESET)
    CONFIG  LPT1OSC = OFF         ; LOW-POWER TIMER 1 OSCILLATOR ENABLE BIT (TIMER1 CONFIGURED FOR HIGHER POWER OPERATION)
    CONFIG  MCLRE = ON            ; MCLR PIN ENABLE BIT (MCLR PIN ENABLED; RE3 INPUT PIN DISABLED)
    CONFIG  WDT = ON              ; WATCHDOG TIMER ENABLE BIT (WDT ENABLED)
    CONFIG  PWRT = OFF            ; POWER-UP TIMER ENABLE BIT (PWRT DISABLED)
    CONFIG  LVP = OFF 
    
    cblock 0x20
    column
    row
    delay_count
    temp_w
    endc
    
    org 0x00
    movlw 0x06
    movwf ADCON1
    goto main
    
    org 0x08
    goto isr
    
main:
    call init_port
    call init_interrupt
    CALL InitiateLCD
    CALL Enable
    CALL delay
    
wait:
    call enable_keypad
    goto wait
    
init_port:
    bsf STATUS, 5
    clrf TRISD
    bcf TRISB, 0
    bcf TRISB, 1
    
    bcf TRISC, 0
    bcf TRISC, 1
    bcf TRISC, 2
    bcf TRISC, 4
    
    bcf STATUS,5
    
    bcf LATB, 0
    bcf LATB, 1
    
    bcf LATC, 0
    bcf LATC, 1
    bcf LATC, 2
    bcf LATC, 4
    
    clrf LATD
    
    
    movlw 0x1F
    movwf row
    movwf LATC
    
    return
    
init_interrupt:
    bcf INTCON, RBIF
    bsf INTCON, RBIE
    bsf INTCON, GIE
		
		
    return
    
enable_keypad:
    BSF LATB, 0
    call generate_delay
    movf row, W
    movwf LATC
    
next_row:
    btfsc row, 7
    goto reset_row
    bsf STATUS, C
    rlcf row
    movf row, W
    movwf LATC
    
    goto next_row

reset_row:
    movlw 0x10
    movwf row
    movwf LATC
    
    goto next_row

    return

generate_delay:
    call delay
    call delay

    return

delay:
    movlw 0xFF
    movwf delay_count

count:
    nop
    decfsz delay_count
    goto count

    return

isr:
    movwf temp_w
    btfsc PORTB, 4
    goto column_1_code
    btfsc PORTB, 5
    goto column_2_code
    btfsc PORTB, 6
    goto column_3_code
    goto exit_isr

column_1_code:
    call get_column_1_code
;    CALL Enable
;    movwf LATD
    call output_lcd
    goto exit_isr
column_2_code:
    call get_column_2_code
    call output_lcd
    goto exit_isr
    
column_3_code:
    call get_column_3_code
    call output_lcd
    goto exit_isr
    
exit_isr:
    movf temp_w, W
    bcf INTCON, RBIF
 
    retfie

get_column_1_code:
    btfsc row, 0
    retlw 0x31
    btfsc row, 1
    retlw 0x34
    btfsc row, 2
    retlw 0x37
    btfsc row, 4
    retlw 0x2A
    retlw 0x00

get_column_2_code:
    btfsc row, 0
    retlw 0x32
    btfsc row, 1
    retlw 0x35
    btfsc row, 2
    retlw 0x38
    btfsc row, 4
    retlw 0x30
    
    retlw 0x00

get_column_3_code:
    btfsc row, 0
    retlw 0x33
    btfsc row, 1
    retlw 0x36
    btfsc row, 2
    retlw 0x39
    btfsc row, 4
    retlw 0x23
    
    retlw 0x00

    return
    
;InitiateLCD:
;    BCF LATB, 0 ; Setting RS as 0 (Sends commands to LCD)
;    CALL delay
; 
;    MOVLW b'00000001' ; Clearing display
;    MOVWF LATD 
;    CALL Enable
;    CALL delay
; 
;    MOVLW b'00111000' ; Funtion set
;    MOVWF LATD 
;    CALL Enable
;    CALL delay
; 
;    MOVLW b'00001111' ; Display on off
;    MOVWF LATD
;    CALL Enable
;    CALL delay
; 
;    MOVLW b'00000110' ; Entry mod set blinking
;    MOVWF LATD
;    CALL Enable
;    CALL delay
; 
;    RETURN
    
Enable: 
 BSF LATB,1 ; E pin is high, (LCD is processing the incoming data)
 NOP
 BCF LATB,1 ; E pin is low, (LCD does not care what is happening)
 RETURN
 
#INCLUDE <lcd.inc>
    end