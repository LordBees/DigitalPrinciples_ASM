
			include "p16f877.inc"

INNER 		EQU H'0020'
OUTER 		EQU H'0021'
outval 		EQU H'0000'
inval 		EQU H'0000'

UPCOUNT 	EQU H'0022'
DOWNCOUNT 	EQU H'0023'

check 		EQU H'0024'


	;banksel TRISD
	;clrf    TRISD;;warning caused by this could be portd instead
	;banksel PORTD
	;clrf	PORTD

;		banksel 	TRISD
		clrf 		TRISD
		banksel 	TRISB
		movf 		TRISB,0xFF
		banksel 	PORTD

start   movlw 0x0A
		movwf DOWNCOUNT;;move 10
		;movwf check 
		movlw 0
		;movwf PORTD;clear output and Upcount ;;not/Dn count
		movwf UPCOUNT
		;;movwf DOWNCOUNT
;loop 	incf PORTD,F
;		movf UPCOUNT, 0;load upcount into working register
		call ldsm



main 	movlw 0x01;;left switch
		movwf check
		movf PORTB,0;move portb input to working register
		movwf check
		;xorlw check;xorlw check;xorlw check;;xor w with check
;movwf PORTD
		btfsc check,0;check,1;check if zero flag set, skip if clear
		call inc7seg
;btfss PORTB,0
goto main;;debug testing first button
	
		movlw 0x02; right button
		movwf check
		movf PORTB,0;move portb input to working register
		
		xorlw check;;xor w with check
		btfsc STATUS,F;check if zero flag set, skip if clear
		call inc7seg
		goto main


inc7seg	call Table;call table sub
		movwf PORTD;;update leds with 7 seg
		;;call delay;delay from Lab2
		incf UPCOUNT, 1;update upcounter and copy to W
		movf UPCOUNT, 0;working register
		decfsz DOWNCOUNT,F
		;goto loopsub
		;goto start
		return

;;ckup	movlw 0x01;;ld 1 to check for up
;;		movwf check

;;		return

;;btnup	movlw 0x01;;ld 1 to check for up
;;		goto btncmp	
;;btndn	movlw 0x02;ld 2 to chk for dn
;;btncmp	movwf check 
;		movf PORTB,0;move portb input to working register
;		xorlw check;;xor w with check
;		btfsc STATUS,F;check if zero flag set, skip if clear
;		goto btncmp
		
		

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

ldsm 	movlw H'0500';load small delay
		movf outval
		movf inval
		return

ldlg	movlw H'0000';;loadlarge delay
		movf outval
		movf inval
		return
;;end program
		end