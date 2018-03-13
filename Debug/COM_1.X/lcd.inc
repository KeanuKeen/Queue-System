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

output_lcd:		    ; param(W reg), result: output to LCD
    movwf temp		    ; store receive byte
    call write_mode	    ; set lcd transmission to write mode
    movf temp, W	    ; pop receive byte
    call write_lcd
    movf temp, W
    return
   