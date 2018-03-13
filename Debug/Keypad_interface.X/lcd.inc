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
    bsf LATA,1 ; E pin is high, (LCD is processing the incoming data)
    nop
    bcf LATA,1 ; E pin is low, (LCD does not care what is happening)
    call delay_5ms
    
    return

command_mode:
    bcf LATA, 0 ; Setting RS as 0 (Sends commands to LCD)
    call delay_5ms
    
    return

write_mode:
    bsf LATA, 0 ; Setting RS as 1 (Sends commands to LCD)
    call delay_5ms
    
    return
    
write_lcd:
    movwf LATD 
    call Enable
    
    return

set_home:
    movwf temp
    call command_mode
    movlw 0x80
    call write_lcd
    movf temp, W
    return
    
set_second:
    movwf temp
    call command_mode
    movlw 0xC0
    call write_lcd
    movf temp, W
    return

output_lcd:		    ; param(W reg), result: output to LCD
    movwf temp		    ; store receive byte
    call write_mode	    ; set lcd transmission to write mode
    movf temp, W	    ; pop receive byte
    call write_lcd
    movf temp, W
    
    return
   