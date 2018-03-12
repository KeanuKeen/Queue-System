;
 
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
   
 BCF STATUS,6 ; Selection of memory bank 1
 BSF STATUS,5
 CLRF TRISC ; Configuration of PORT B as output (Data pins LCD)
 CLRF TRISD ; Configuration of PORT D as output (RD0-R/S, RD1-E)
 
    BCF STATUS,5 ; Selection of memory bank 0
    CLRF LATC; Setting PORTB to "0000000"
    CLRF LATD ; Setting PORTD to "0000000"
 
    CALL InitiateLCD
 
LOOP2 
 
 CALL PRINTCHAR
 
 GOTO LOOP2
 

 
InitiateLCD 
 BCF LATC, 0 ; Setting RS as 0 (Sends commands to LCD)
 
 CALL DELAY_5ms
 
    MOVLW b'00000001' ; Clearing display
 MOVWF LATD 
 CALL Enable
 CALL DELAY_5ms
 
    MOVLW b'00111000' ; Funtion set
 MOVWF LATD 
 CALL Enable
 CALL DELAY_5ms
 
    MOVLW b'00001111' ; Display on off
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms
 
    MOVLW b'00000110' ; Entry mod set blinking
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 RETURN
 
PRINTCHAR 
 BCF LATC, 0 ; Setting RS as 0 (Sends commands to LCD)
 
MOVLW 0x80 ; Set cursor home
 MOVWF LATD 
 CALL Enable
 CALL DELAY_5ms
 
 BSF LATC, 0 ; Setting RS as 1 (Sends information to LCD)
 CALL DELAY_5ms
 
 MOVLW d'73' ; Print character "I"
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms
 
MOVLW d'39' ; Print character "'"
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'77' ; Print character "M"
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'0' ; Print character " "
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'70' ; 
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'65' ; 
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms
 
MOVLW d'89' ; 
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'33' ; 
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'33' ; 
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'33' ; Print character "!"
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'63' ; Print character "?"
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms
 
 MOVLW d'63' ; Print character "?"
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'63' ; Print character "?"
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'63' ; Print character "?"
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms
 
BCF LATC, 0 ; Setting RS as 0 (Sends commands to LCD)
 CALL Enable
 CALL DELAY_5ms
MOVLW 0xC0 ; Set cursor home
 MOVWF LATD 
 CALL Enable
 CALL DELAY_5ms
 
 BSF LATC, 0 ; Setting RS as 1 (Sends information to LCD)
 CALL DELAY_5ms
 
 
 MOVLW d'65' ; Print character "?"
 MOVWF LATD
 CALL Enable
 CALL DELAY_5ms 
 
 
 
 RETURN
 
Enable 
 BSF LATC,1 ; E pin is high, (LCD is processing the incoming data)
 NOP
 BCF LATC,1 ; E pin is low, (LCD does not care what is happening)
 RETURN
 
DELAY_5ms 
    MOVLW 0XFF
    MOVWF DELAY_COUNT

COUNT:
    NOP
    DECFSZ DELAY_COUNT
    GOTO COUNT

    RETURN
 
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
END