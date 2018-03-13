;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; Author : Gargar			                                            ; 
; Date : Feb. 27, 2018                                                              ; 
; Version: 1                                                                        ; 
; Title: Communicate between PIC and PC v1					    ; 
;                                                                                   ; 
; Description:	Transmit a bit from PIC through MAX232's and UART to TTL 	    ; 
;		to usb port						  	    ; 
;                                                                                   ; 
;                                                                                   ; 
;                                                                                   ; 
;                                                                                   ;  
;                                                                                   ;  
;                                                                                   ;  
;                                                                                   ;  
;                                                                                   ; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

    LIST  P=18F4550
#INCLUDE <p18f4550.inc>

    CONFIG LVP = OFF
    CONFIG MCLRE = ON
    CONFIG BOR = OFF

    CBLOCK 0x20
	temp	
	delay_count
	db_output
	isr_temp
	row
	keypad_enabled
	lcd_col
	lcd_meta
    ENDC

   

MAIN CODE
 
    org 0x00
    goto head

    org 0x08
    goto interrupt_service_routine
 
head:
    call initUART
    call initTX
    call initRX
    call initInterrupt
    call initPort
    call initLCD
    
    movlw  UPPER bootUpDB
    call set_upper_table
    movlw  HIGH bootUpDB
    call set_higher_table
    movlw  LOW bootUpDB
    call set_lower_table
    
    movlw 0x01
    call set_col
    call set_home
    
    call readDB
    
main:
;    MAGIC!
;    btfsc PORTA, 0
;    bsf LATC, 1
;    bcf LATC, 1
    call init_keypad
    
    goto main
    
readDB:   
    tblrd*+		    ; read into TABLAT and increment   
    movf TABLAT, W	    ; get data
    btfsc STATUS, Z	    ; zero if end of message
    return		    ; get out if End of message
    call output_lcd	    ; if there's a msg, output to lcd
    call delay_5ms
    goto readDB		    ; Next char

set_upper_table:
    movwf TBLPTRU   
    return
    
set_higher_table:
    movwf TBLPTRH   
    return
    
set_lower_table:
    movwf TBLPTRL   
    return

; </////// ISR ///////> ;
    
interrupt_service_routine:
    movwf isr_temp
;    btfss INTCON, INT0IF    ; check if RB0 triggered the interrupt or not
;    goto int_uart	    ; if RB0 did not, it's the RX UART
;    btfsc PORTB, 5
    goto isr_keypad
;    bsf LATC, 1
;    btg LATC, 0
;    movlw 0x61		    ; send 'a'
;    call writeUART	    ; write to UART
isr_stop:
;    bcf INTCON, RBIF
    bcf INTCON, RBIF	    ; clear (RB0) interrupt flag bit
    movf isr_temp, W    
    retfie		    ; return to current prog.
    
; </------ ISR ------/> ;

    
    
; </////// INT. AT UART RX ///////> ;
    
int_uart:
;    btg LATA, 0
    call readUART	    
    call output_lcd
    call writeUART
    bcf INTCON, INT0IF
    
    goto isr_stop

; </------ INT. AT UART RX ------/> ;  
    
    
    
; </////// STRING DB ///////> ;
    
stringDB:
    db "Hello World!", 0
bootUpDB:
    db "Queue System!", 0

; </------ STRING DB ------/> ;    
    
    
    
; </////// INITIALIZATION ///////> ;
    
initPort:
    movlw 0X06
    movwf ADCON1
    bcf TRISA, 0
    bcf TRISA, 1
    bcf TRISA, 5
    bsf TRISA, 4
    bsf TRISB, 0
    bsf TRISB, 1
    bsf TRISB, 5
    bsf TRISB, 6
    bsf TRISB, 7
    bcf TRISC, 0
    bcf TRISC, 1
    bcf TRISC, 2
    bcf TRISC, 4
    movlw 0x00
    movwf TRISD
    return
    
#INCLUDE <interrupt.inc>
#INCLUDE <uart.inc>  
#INCLUDE <lcd.inc>
#INCLUDE <delay.inc>  
#INCLUDE <keypad.inc>	

; </------ INITIALIZATION ------/> ;
    
    
    END