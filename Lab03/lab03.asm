
	include "p16f877.inc"

INNER EQU H'0020'
OUTER EQU H'0021'
outval EQU H'0000'
inval EQU H'0000'

UPCOUNT 	EQU H'0022'
DOWNCOUNT 	EQU H'0023'

	banksel TRISD
	clrf    TRISD;;warning caused by this could be portd instead
	banksel PORTD
	clrf	PORTD

start   movlw 0x0A
		movwf DOWNCOUNT;;move 10 
		movlw 0
		;movwf PORTD;clear output and Upcount ;;not/Dn count
		movwf UPCOUNT
		;;movwf DOWNCOUNT



;loop 	incf PORTD,F

;		movf UPCOUNT, 0;load upcount into working register
loopsub	call Table;call table sub
		movwf PORTD;;update leds with 7 seg
		call delay;delay from Lab2
		incf UPCOUNT, 1;update upcounter and copy to W
		movf UPCOUNT, 0
		decfsz DOWNCOUNT,F
		goto loopsub
		goto start

;lookup table
Table 	addwf PCL,F;;mov w to pc

		retlw H'0088';0
		retlw H'00ED';1
		retlw H'0094';2
		retlw H'00A4';3
		retlw H'00E1';4
		retlw H'00A2';5
		retlw H'0082';6
		retlw H'00EC';7
		retlw H'0080';8
		retlw H'00E0';9
		;return

;delay subroutine
delay 	movlw outval;load register outer
		movwf OUTER
delayx 	movlw inval;load register inner
		movwf INNER
delayin decfsz INNER,F
		goto delayin
		decfsz OUTER,F
		goto delayx
		return
;;end program
		end