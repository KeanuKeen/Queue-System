initInterrupt:
    bcf INTCON, RBIF
    bcf INTCON, INT0IF	    ; clear ext. int. flag bit (RB0)
    bsf INTCON, INT0IE	    ; enable ext. int. (RB0)
    bsf PIE1, RCIE	    ; enable receive UART int. flag bit (RX)
    bsf INTCON, PEIE	    ; enable periphal int. (TX/RX)
    bsf INTCON, RBIE
    bsf INTCON, GIE	    ; enable global int. (All Interrupt bits)
    return
    

    
