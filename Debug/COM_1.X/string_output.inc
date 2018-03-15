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

    
clear_row1:
    movlw  UPPER clr_row
    call set_upper_table
    movlw  HIGH clr_row
    call set_higher_table
    movlw  LOW clr_row
    call set_lower_table
    call set_home
    call string_out
    
    return

clear_row2:
    movlw  UPPER clr_row
    call set_upper_table
    movlw  HIGH clr_row
    call set_higher_table
    movlw  LOW clr_row
    call set_lower_table
    call set_second
    call string_out
    
    return

clear_lcd:
    call clear_row1
    call clear_row2
    
    return
    
serve_queue:
    movlw  UPPER serve_screen1
    call set_upper_table
    movlw  HIGH serve_screen1
    call set_higher_table
    movlw  LOW serve_screen1
    call set_lower_table
    call set_home
    call string_out
    
    movlw  UPPER serve_screen2
    call set_upper_table
    movlw  HIGH serve_screen2
    call set_higher_table
    movlw  LOW serve_screen2
    call set_lower_table
    call set_second
    call string_out
    
    return
    
ask_num:
    movlw  UPPER ask_num1
    call set_upper_table
    movlw  HIGH ask_num1
    call set_higher_table
    movlw  LOW ask_num1
    call set_lower_table
    call set_home
    call string_out
    
    movlw  UPPER ask_num2
    call set_upper_table
    movlw  HIGH ask_num2
    call set_higher_table
    movlw  LOW ask_num2
    call set_lower_table
    call set_second
    call string_out
    
    return
    
input_num:
    movlw  UPPER input_num1
    call set_upper_table
    movlw  HIGH input_num1
    call set_higher_table
    movlw  LOW input_num1
    call set_lower_table
    call set_home
    call string_out
    
    movlw  UPPER input_num2
    call set_upper_table
    movlw  HIGH input_num2
    call set_higher_table
    movlw  LOW input_num2
    call set_lower_table
    call set_second
    call string_out
    
    
    return
    
check_out:
    movlw  UPPER checkout1
    call set_upper_table
    movlw  HIGH checkout1
    call set_higher_table
    movlw  LOW checkout1
    call set_lower_table
    call set_home
    call string_out
    
    movlw  UPPER checkout2
    call set_upper_table
    movlw  HIGH checkout2
    call set_higher_table
    movlw  LOW checkout2
    call set_lower_table
    call set_second
    call string_out
    
    return
    
    
; </////// STRING DB ///////> ;
    
clr_row:
    db "                ", 0
    
stringDB:
    db "Hello World!", 0
    
bootUpDB1:
    db "Queue System", 0
bootUpDB2:
    db "Booting up...", 0
    
serve_screen1:
    db "Queue no.:", 0
serve_screen2:
    db "Proceed to serve", 0
    
ask_num1:
    db "Send SMS Update?", 0
ask_num2:
    db "No    |  Proceed", 0
    
input_num1:
    db "ENTER NUMBER: ", 0
input_num2:
    db "Back   | Proceed", 0
    
checkout1:
    db "YOUR QUEUE # IS:", 0
checkout2:
    db "       | Proceed", 0

; </------ STRING DB ------/> ;  