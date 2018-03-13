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
    


