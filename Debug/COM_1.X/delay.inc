delay_5ms: 
    movlw 0xff
    movwf delay_count
count:
    nop
    decfsz delay_count
    goto count
    return
    

big_delay:
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    return
