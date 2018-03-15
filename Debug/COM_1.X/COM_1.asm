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
	keypad_meta
	lcd_col
	lcd_meta
	logic_meta
	key_input
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
    clrf keypad_meta
    clrf logic_meta
    clrf key_input
   
    call big_delay
    
    bsf logic_meta, 0 ; refresh serve que
    bsf logic_meta, 2
    bsf logic_meta, 3
    bsf logic_meta, 4
    
    bsf keypad_meta, 0	; enable keypad
    bcf keypad_meta, 1 ; enable read of key input
    call serve_queue
    call big_delay
    call big_delay
    call big_delay
main:
;    MAGIC!
    
;    call init_keypad

; </////// SERVE QUEUE ///////> ;
    
    btfss logic_meta, 0
    goto skip_serve_queue
serve_queue_loop:
    call clear_lcd
    call serve_queue
    bcf logic_meta, 0
    call set_home
;    goto serve_queue_loop
skip_serve_queue:
    
    
keypad:
    bsf INTCON, RBIE
    clrf key_input
;    bcf keypad_meta,1
;    call set_home
    call init_keypad
    
    movlw 0x23
    cpfseq key_input
    goto keypad

; </------ SERVE QUEUE ------/> ;
 

; </////// ASK NUM ///////> ;
    
;    goto skip_ask_num
    btfss logic_meta, 2
    goto skip_ask_num
ask_num_loop:
    call clear_lcd
    call ask_num

    bcf logic_meta, 2 
skip_ask_num:
    
keypad_ask_num:
    bsf INTCON, RBIE
    clrf key_input
    call init_keypad
    
    movlw 0x23
    cpfseq key_input
    goto keypad_ask_num
    
; </------ ASK NUM ------/> ;
    

; </////// INPUT NUM ///////> ;
    
    btfss logic_meta, 3
    goto skip_input_num
input_num_loop:
    call clear_lcd
    call input_num

    bcf logic_meta, 3
    
skip_input_num:
    
keypad_input_num:
    bsf INTCON, RBIE
    clrf key_input
    call init_keypad
    
    movlw 0x23
    cpfseq key_input
    goto keypad_input_num
    
; </------ INPUT NUM ------/> ;
    
    
    
; </////// CHECK-OUT ///////> ;
    
    btfss logic_meta, 4
    goto skip_checkout
checkout_loop:
    call clear_lcd
    call check_out

    bcf logic_meta, 4
    
skip_checkout:
    
keypad_checkout:
    bsf INTCON, RBIE
    clrf key_input
    call init_keypad
    
    movlw 0x23
    cpfseq key_input
    goto keypad_checkout
    
; </------ CHECK-OUT ------/> ;
    
    goto main
   

; </////// ISR ///////> ;
    
interrupt_service_routine:
    movwf isr_temp
    btg LATA, 4
    btfsc INTCON, INT0IF    ; check if RB0 triggered the interrupt or not
    goto test_uart	    ; if RB0 did not, it's the RX UART
;    btfsc INTCON, RBIF
    goto isr_keypad
;    btg LATA, 5
;    bsf LATC, 1
;    btg LATC, 0
;    movlw 0x61		    ; send 'a'
;    call writeUART	    ; write to UART
isr_stop:
;    bcf INTCON, RBIF
    bcf INTCON, INT0IF
    bcf INTCON, RBIF	    ; clear (RB0) interrupt flag bit
    movf isr_temp, W    
    retfie		    ; return to current prog.
    
; </------ ISR ------/> ;

    
    
; </////// INT. AT UART RX ///////> ;
    
int_uart:
    call readUART	    
    call output_lcd
    call writeUART
    bcf INTCON, INT0IF
    
    goto isr_stop

; </------ INT. AT UART RX ------/> ;  

test_uart:
    btg LATA, 5
    movlw 0x61
    call writeUART
    
    goto isr_stop
    
  
    
    
    
; </////// INITIALIZATION ///////> ;
    
initPort:
    movlw 0X06
    movwf ADCON1
    bcf TRISA, 0
    bcf TRISA, 1
    bcf TRISA, 4
    bcf TRISA, 5
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
#INCLUDE <string_output.inc>	

; </------ INITIALIZATION ------/> ;
    
    
    END