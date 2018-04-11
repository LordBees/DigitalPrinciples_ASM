;Delay.asm. This is a PIC assembly language source file for a time delay
; Author: Your Name
;Date

;**********************************SETUP***************************
include"P16F877.INC"	;This tells the assembler to 'include' 
				;another source file
;TIMREG  EQU   	 H'0020' 	;This tells the assembler that                                                  					             ;register 20 is named (or equates to) 
delval	     EQU	 H'0005'	;this is the delay time value 5
					;to allow you to single step around.
INNER EQU H'0020'
OUTER EQU H'0021'
outval EQU H'0000'
inval EQU H'0000'

;*******************************PORT SETUP*************************


		Banksel 	TRISD		;change register bank (page)
		clrf	 PORTD		;make PORTD an output port
		banksel	 PORTD	;change back to original bank
;************************************MAIN**************************
start	movlw 0			;move 'literal'value 0 into the W register
		movwf	  PORTD		;clear LEDs on PORTD
loop	incf PORTD,F		;update the LEDs by incrementing them 
		;;start loop
		call delay
		nop				;do nothing at all for one machine cycle except increment the program counter		
		;;end of loop		
		goto loop			;go back to the instruction labelled 'loop'
;******************************DELAY SUBROUTINE****************


delay 	movlw outval;load register outer
		movwf OUTER
delayx 	movlw inval;load register inner
		movwf INNER
delayin decfsz INNER,F
		goto delayin
		decfsz OUTER,F
		goto delayx
		return

;delayi 	decfsz INNER;;decrement inner to 0 then return
;		call delayi
;		return




end				;this tells the assembler that we're done.
