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
main:
;    MAGIC!
    
initTable:
    movlw  UPPER stringDB
    movwf  TBLPTRU
    movlw  HIGH stringDB
    movwf  TBLPTRH   
    movlw  LOW stringDB
    movwf  TBLPTRL
    call command_mode
    movlw 0x80
    call write_lcd
    call readDB
    goto initTable	    ; Loop for ever
    
readDB:   
    tblrd*+		    ; read into TABLAT and increment   
    movf TABLAT, W	    ; get data
    btfsc STATUS, Z	    ; zero if end of message
    return
    call output_lcd	    ; Output to console
;    call delay_5ms
    goto readDB		    ; Next char
    
    goto main
    
    
; <------- STRING DB -------> ;
    
stringDB:
    db "Hello World!", 0
bootUpDB:
    db "Queue System!", 0

; </------ STRING DB ------/> ;    
    
    
; <------- INITIALIZATION -------> ;
    
initPort:
    movlw 0X06
    movwf ADCON1
    bcf TRISA, 0
    bcf TRISA, 1
    bsf TRISB, 1
    bcf TRISC, 0
    bcf TRISC, 1
    bsf TRISC, 7
    
    clrf TRISD
    return
    
#INCLUDE <interrupt.inc>
#INCLUDE <uart.inc>  
#INCLUDE <lcd.inc>
#INCLUDE <delay.inc>  

; </------ INITIALIZATION ------/> ;
    
    
    END