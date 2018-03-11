    LIST P=18f4550
 INCLUDE "P18F4550.INC" 
 
    CONFIG  CCP2MX = ON           ; CCP2 MUX BIT (CCP2 INPUT/OUTPUT IS MULTIPLEXED WITH RC1)
    CONFIG  PBADEN = ON           ; PORTB A/D ENABLE BIT (PORTB<4:0> PINS ARE CONFIGURED AS ANALOG INPUT CHANNELS ON RESET)
    CONFIG  LPT1OSC = OFF         ; LOW-POWER TIMER 1 OSCILLATOR ENABLE BIT (TIMER1 CONFIGURED FOR HIGHER POWER OPERATION)
    CONFIG  MCLRE = ON            ; MCLR PIN ENABLE BIT (MCLR PIN ENABLED; RE3 INPUT PIN DISABLED)
    CONFIG  WDT = ON              ; WATCHDOG TIMER ENABLE BIT (WDT ENABLED)
    CONFIG  PWRT = OFF            ; POWER-UP TIMER ENABLE BIT (PWRT DISABLED)
    CONFIG  LVP = OFF 
 
    DELAY_COUNT
    
ORG 0x00 
   
    clrf TRISC ; Configuration of PORT B as output (Data pins LCD)
    clrf TRISD ; Configuration of PORT D as output (RD0-R/S, RD1-E)

    clrf LATC; Setting PORTB to "0000000"
    clrf LATD ; Setting PORTD to "0000000"

    call initiateLCD
 
LOOP2:
    call PRINTCHAR
    goto LOOP2
 
initiateLCD: 
    call command_mode
    call DELAY_5ms
    
    movlw b'00000001' ; Clearing display
    call write_lcd

    MOVLW b'00111000' ; Funtion set
    call write_lcd

    MOVLW b'00001111' ; Display on off
    call write_lcd

    MOVLW b'00000110' ; Entry mod set blinking
    call write_lcd
    
    call DELAY_5ms

    RETURN
 
PRINTCHAR: 
    call command_mode

    MOVLW 0x80 ; Set cursor home
    call write_lcd
 
    call write_mode
    
    MOVLW 0x20 ; Print character "I"
    call write_lcd
    
    MOVLW d'73' ; Print character "I"
    call write_lcd

    MOVLW d'39' ; Print character "'"
    call write_lcd

    MOVLW d'77' ; Print character "M"
    call write_lcd 

    MOVLW d'0' ; Print character " "
    call write_lcd 

    MOVLW d'70' ; 
    call write_lcd 

    MOVLW d'65' ; 
    call write_lcd

    MOVLW d'89' ; 
    call write_lcd

    MOVLW d'33' ; 
    call write_lcd

    MOVLW d'33' ; 
    call write_lcd

    MOVLW d'33' ; Print character "!"
    call write_lcd

    MOVLW d'63' ; Print character "?"
    call write_lcd

    MOVLW d'63' ; Print character "?"
    call write_lcd

    MOVLW d'63' ; Print character "?"
    call write_lcd 

    MOVLW d'63' ; Print character "?"
    call write_lcd
    
    call command_mode
    
    MOVLW 0xC0 ; Set cursor next row
    call write_lcd

    call write_mode

    MOVLW d'63' ; Print character "?"
    call write_lcd

RETURN
 
Enable: 
    BSF LATC,1 ; E pin is high, (LCD is processing the incoming data)
    NOP
    BCF LATC,1 ; E pin is low, (LCD does not care what is happening)
    call DELAY_5ms
    RETURN

DELAY_5ms: 
    MOVLW 0xff
    MOVWF DELAY_COUNT
COUNT:
    NOP
    DECFSZ DELAY_COUNT
    GOTO COUNT
    RETURN
 
write_lcd:
    MOVWF LATD 
    CALL Enable
    CALL DELAY_5ms
    RETURN
    
command_mode:
    BCF LATC, 0 ; Setting RS as 0 (Sends commands to LCD)
    call DELAY_5ms
    
    return

write_mode:
    BSF LATC, 0 ; Setting RS as 0 (Sends data to LCD)
    call DELAY_5ms  
    
    return
 
END