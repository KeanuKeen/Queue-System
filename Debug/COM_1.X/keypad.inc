; </////// JUGGLE ROWS ///////> ;

 init_keypad:    

    bsf LATC, 4
    bsf row, 4
    call delay_5ms
    bcf LATC, 4
    bcf row, 4

    bsf LATC, 2
    bsf row, 2
    call delay_5ms
    bcf LATC, 2
    bcf row, 2

    bsf LATC, 1
    bsf row, 1
    call delay_5ms
    bcf LATC, 1
    bcf row, 1
    
    bsf LATC, 0
    bsf row, 0
    call delay_5ms
    bcf LATC, 0
    bcf row, 0

    return
    
; </------ JUGGLE ROWS ------/> ;

isr_keypad:
    movwf isr_temp
;    call set_home
;    movlw 0x65		    ; send 'e'
;    call output_lcd
    btfsc PORTB, 5
    goto column_1_code
    btfsc PORTB, 6
    goto column_2_code
    btfsc PORTB, 7
    goto column_3_code
exit_isr:
;    movf isr_temp, W
;    bcf INTCON, RBIF
; 
;    retfies
;    bcf keypad_enabled, 0
;    bsf LATA, 4
    bsf LATA, 5
;    bsf keypad_meta, 1
    bcf INTCON, RBIE
    goto isr_stop


; </////// CHECK COLUMN ///////> ;

column_1_code:
    call get_column_1_code
    
;    call set_home
    movwf key_input
;    call output_lcd
    call writeUART
    
    goto exit_isr
    
column_2_code:
    call get_column_2_code
    
;    call set_home
    movwf key_input
;    call output_lcd
    call writeUART
    
    goto exit_isr
    
column_3_code:
    call get_column_3_code
    
;    call set_home
    movwf key_input
;    call output_lcd
    call writeUART
    
    goto exit_isr

; </------ CHECK COLUMN ------/> ;
    
    
    
; </////// CHECK ROW ///////> ;

get_column_1_code:
    btfsc row, 0
    retlw 0x31			; '1'	    
    btfsc row, 1
    retlw 0x34			; '4'
    btfsc row, 2
    retlw 0x37			; '7'
    btfsc row, 4
    retlw 0x2A			; '*'
    
    retlw 0x00

get_column_2_code:
    btfsc row, 0
    retlw 0x32			; '2'
    btfsc row, 1
    retlw 0x35			; '5'
    btfsc row, 2
    retlw 0x38			; '8'
    btfsc row, 4
    retlw 0x30			; '0'
	
    retlw 0x00

get_column_3_code:
    btfsc row, 0
    retlw 0x33			; '3'
    btfsc row, 1
    retlw 0x36			; '6'
    btfsc row, 2
    retlw 0x39			; '9'
    btfsc row, 4
    retlw 0x23			; '#'
    
    retlw 0x00

; </------ CHECK ROW ------/> ;