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
    call output_lcd
    call writeUART
    bcf INTCON, INT0IF
    goto isr_stop

    
