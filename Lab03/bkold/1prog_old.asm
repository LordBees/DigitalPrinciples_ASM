;first asm file
;include "P16F877.INC";include register names
					 ;from another source file
include "p16f877.inc"

banksel TRISD
clrf TRISD

banksel PORTD
;****
start movlw 0
loop addlw 1
movwf PORTD;
nop
goto loop
end