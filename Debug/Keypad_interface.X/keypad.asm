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
	temp
	isr_temp
    endc
    
    org 0x00
    movlw 0x06
    movwf ADCON1
    goto main
    
    org 0x08
    goto isr
    
main:
    call init_port
    call initInterrupt
    CALL initLCD    
wait:
    call init_keypad
    goto wait

isr:
    goto isr_keypad
isr_stop:
    movf temp_w, W
    bcf INTCON, RBIF
 
    retfie

init_port:
    bsf STATUS, 5
    clrf TRISD
    bcf TRISB, 0
    bcf TRISB, 1
    
    bcf TRISC, 0
    bcf TRISC, 1
    bcf TRISC, 2
    bcf TRISC, 4
    
    bcf TRISA, 0
    bcf TRISA, 1
    bcf TRISA, 2
    bcf TRISA, 3
    
    bsf TRISB, 5
    bsf TRISB, 6
    bsf TRISB, 7
    
    bcf STATUS,5
    
    bcf LATB, 0
    bcf LATB, 1
    
    bcf LATC, 0
    bcf LATC, 1
    bcf LATC, 2
    bcf LATC, 4
    
    clrf LATA
    clrf LATD
    
    movlw 0x10
    movwf row
    movwf LATC
    
    return    
 
#INCLUDE <lcd.inc>
#INCLUDE <delay.inc>
#INCLUDE <interrupt.inc>
#INCLUDE <keypad.inc>
 
    end