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
	var1
	TableLength1
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
    movwf temp		    ; store receive byte
    call write_mode	    ; set lcd transmission to write mode
    movf temp, W	    ; pop receive byte
    call write_lcd	    ; Output to console
    call delay_5ms
    goto readDB		    ; Next char
    
    
    goto main
    
initInterrupt:
    bcf INTCON, INT0IF	    ; clear ext. int. flag bit (RB0)
    bsf INTCON, INT0IE	    ; enable ext. int. (RB0)
    bsf PIE1, RCIE	    ; enable receive UART int. flag bit (RX)
    bsf INTCON, PEIE	    ; enable periphal int. (TX/RX)
    bsf INTCON, GIE	    ; enable global int. (All Interrupt bits)
    
    return
    
interrupt_service_routine:
    btfss INTCON, INT0IF    ; check if RB0 triggered the interrupt or not
    goto int_uart	    ; if RB0 did not, it's the RX UART
    btg LATA, 1
    movlw 0x61		    ; send 'a'
    call writeUART	    ; write to UART
isr_stop:
    bcf INTCON, INT0IF	    ; clear (RB0) interrupt flag bit
    retfie		    ; return to current prog.
    
int_uart:
    btg LATA, 0
    call readUART	    
    movwf temp		    ; store receive byte
    call write_mode	    ; set lcd transmission to write mode
    movf temp, W	    ; pop receive byte
    call write_lcd
    movf temp, W
    call writeUART
    bcf INTCON, INT0IF
    goto isr_stop
    
initUART:
    bcf TXSTA, TXEN	    ; disable UART transmission
    bcf TXSTA, SYNC	    ; set as Asynchronous 
    bsf TXSTA, BRGH	    ; use high-speed mode
    movlw d'25'		    ; config baud rate as 9600
    movwf SPBRG		    ; set baud rate
    bsf RCSTA, SPEN	    ; enable serial port (TX/RX)
    return
    
initTX:
    bcf TXSTA, TX9	    ; use 8-bit transmission
    bsf TXSTA, TXEN	    ; enable UART transmission
    return
    
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

initRX:
    bcf RCSTA, RX9	    ; use 8-bit receiver
    bsf RCSTA, CREN	    ; enable continuous receive
    return
    
writeUART:
    movwf TXREG		    ; register buffer to transmit
checkTXIF:
    btfss PIR1, TXIF	    ; check if all data has been transmitted
    goto checkTXIF
    return
    
readUART:
    btfss PIR1, RCIF	    ; check if all data has been received
    goto readUART
    movf RCREG, W	    ; move received data to W reg
    return

displayLCD:
    call command_mode
    
    movlw 0x80
    call write_lcd
    
    call write_mode
    
    movlw 0x41
    call write_lcd
    
    movlw 0x42
    call write_lcd
    
    call command_mode
    
    movlw 0xC0 
    call write_lcd
    
    call write_mode
    
    movlw 0x41
    call write_lcd
    
    movlw 0x42
    call write_lcd
    
    return
    
    
initLCD:
    call command_mode
    call delay_5ms
    
    movlw b'00000001' ; Clearing display
    call write_lcd

    movlw b'00111000' ; Funtion set
    call write_lcd

    movlw b'00001111' ; Display on off
    call write_lcd

    movlw b'00000110' ; Entry mod set blinking
    call write_lcd
    
    movlw 0x38
    call write_lcd
    
    call delay_5ms
    
    return
    
Enable: 
    bsf LATC,1 ; E pin is high, (LCD is processing the incoming data)
    nop
    bcf LATC,1 ; E pin is low, (LCD does not care what is happening)
    call delay_5ms
    
    return

command_mode:
    bcf LATC, 0 ; Setting RS as 0 (Sends commands to LCD)
    call delay_5ms
    
    return

write_mode:
    bsf LATC, 0 ; Setting RS as 1 (Sends commands to LCD)
    call delay_5ms
    
    return
    
write_lcd:
    movwf LATD 
    call Enable
    
    return
    
delay_5ms: 
    movlw 0xff
    movwf delay_count
count:
    nop
    decfsz delay_count
    goto count
    return    
    
stringDB:
    db     "Hello World!", 0
    db	    "Test", 0
    
 	
TableRead1:
 	addwf	PCL, F
	dt "Hi", 0x00
; 	retlw	'H'
; 	retlw	'e'
; 	retlw	'l'
; 	retlw	'l'
; 	retlw	'o'
    
    END