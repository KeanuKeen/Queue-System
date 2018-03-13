string_out:   
    tblrd*+		    ; read into TABLAT and increment   
    movf TABLAT, W	    ; get data
    btfsc STATUS, Z	    ; zero if end of message
    return		    ; get out if End of message
    call output_lcd	    ; if there's a msg, output to lcd
    call delay_5ms
    goto string_out		    ; Next char

set_upper_table:
    movwf TBLPTRU   
    return
    
set_higher_table:
    movwf TBLPTRH   
    return
    
set_lower_table:
    movwf TBLPTRL   
    return