  LIST  P=18F4550
#INCLUDE <p18f4550.inc>

    CONFIG LVP = OFF
    CONFIG MCLRE = ON
    CONFIG BOR = OFF
 
    org 0x00
    goto main
    
    org 0x08
    goto interrupt_service_routine
    
MAIN CODE
 
main:
    call init_port
    bsf INTCON, INT0IE
    bcf INTCON, INT0IF
    bsf INTCON, GIE

wait:
    goto wait

init_port:
    MOVLW 0X06
    MOVWF ADCON1
    
    bsf TRISB, 0
    bcf TRISD, 0
    bcf TRISD, 1
    bcf TRISD, 2
    bcf TRISD, 3
    clrf PORTD

    return

init_interrupt:
    bsf INTCON, 7
    bsf INTCON, 4
    bcf INTCON, 1
    return

interrupt_service_routine:
    comf LATD, 0
    bcf INTCON, INT0IF
    
    retfie
	
    END
	