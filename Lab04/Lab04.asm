
			include "p16f877.inc"

INNER 		EQU H'0020'
OUTER 		EQU H'0021'
outval 		EQU H'0000';changed untilll i can fix the dregister loading for this
inval 		EQU H'0000'

UPCOUNT 	EQU H'0022'
DOWNCOUNT 	EQU H'0023'

check 		EQU H'0024'


	;banksel TRISD
	;clrf    TRISD;;warning caused by this could be portd instead
	;banksel PORTD
	;clrf	PORTD

		banksel 	TRISD;set ports to output
		clrf 		TRISD

		banksel 	PORTD;clear output
		clrf 		PORTD
;		movlw 		H'0000';0x00
		movwf 		PORTD;,0x00;//changed from clrf

;		banksel 	TRISB;set input from button
;		movlw       0xFF
;		movwf 		TRISB
		

start   movlw 0x0A
		movwf DOWNCOUNT;;move 10
		movlw 0x00
		movwf UPCOUNT;movwf PORTD;clear output and Upcount ;;not/Dn count
		;;movwf DOWNCOUNT
;loop 	incf PORTD,F
;		movf UPCOUNT, 0;load upcount into working register
		;call ldsm



main	nop
		btfsc PORTB,0;1;0
		goto btn2
		call delay
		btfsc PORTB,0;1;0
		goto btn2
		call inc7seg
		;goto main
btn2	nop
		btfsc PORTB,1;0
		goto main
		call delay
		btfsc PORTB,1;0
		goto main
		call dec7seg
		goto main
;;main 	movlw 0x01;;left switch
;;		movwf check
;;		movf PORTB,0;move portb input to working register
;;		movwf check
;;		;xorlw check;xorlw check;xorlw check;;xor w with check
;;		;movwf PORTD
;;		btfsc check,0;check,1;check if zero flag set, skip if clear
;;		call inc7seg
;;		;btfss PORTB,0
;;goto main;;debug testing first button
;;	
;;		movlw 0x02; right button
;;		movwf check
;;		movf PORTB,0;move portb input to working register
;;		
;;		xorlw check;;xor w with check
;;		btfsc STATUS,F;check if zero flag set, skip if clear
;;		call inc7seg
;;		goto main


;inc7seg	
		
		;;call delay;delay from Lab2
;		incf UPCOUNT, 1;update upcounter and copy to W
;		movf UPCOUNT, 0;working register
;		decfsz DOWNCOUNT,F
;		call Table;call table sub
;		movwf PORTD;;update leds with 7 seg
;		;goto loopsub
;		;goto start
;;		return

inc7seg	nop;;increment 7 sec
		call Tableupd
		;;call delay;delay from Lab2
		incf UPCOUNT, 1;update upcounter and copy to W
		movf UPCOUNT, 0;working register
		;;decfsz DOWNCOUNT,F
		;call Table;call table sub
		
		decfsz DOWNCOUNT,F;;test to see if max reached if so call reset
		return
		call rst7seg
		return

dec7seg	nop;;decrement 7 seg
		call Tableupd
		;call Table;call table sub
		incf DOWNCOUNT,1
		movf DOWNCOUNT,0
		
		decfsz UPCOUNT,F;;test to see if max reached if so call reset
		return
		call rst7segt
		
		
		return

;dec7seg	nop;;decrement 7 seg
;		movf UPCOUNT,0
;		call Table;call table sub
;		movwf PORTD;;update leds with 7 seg
;		;;call delay;delay from Lab2
;		;decf UPCOUNT, 1;update upcounter and copy to W
;		;movf UPCOUNT, 0;working register
;		;;decfsz DOWNCOUNT,F
;		;call Table;call table sub
;		incf DOWNCOUNT,1
;		
;		decfsz UPCOUNT,F;;test to see if max reached if so call reset
;		return
;		call rst7segt
;		return

;dec7seg	nop;;decrement 7 seg
;		movf UPCOUNT,0
;		call Table;call table sub
;		movwf PORTD;;update leds with 7 seg
;		;;call delay;delay from Lab2
;		decf UPCOUNT, 1;update upcounter and copy to W
;		movf UPCOUNT, 0;working register
;		;;decfsz DOWNCOUNT,F
;		;call Table;call table sub
;		
;		incfsz DOWNCOUNT,F;;test to see if max reached if so call reset
;		
;		return
;		call rst7segt
;		return

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
		return;10
		return;11
		return;12
		return;13
		return;14
		return;15

Tableupd nop;
		movf UPCOUNT,0
		call Table;call table sub
		movwf PORTD;;update leds with 7 seg
		return

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
		;;movf outval
		;;movf inval
		movwf OUTER
		movwf INNER
		return

ldlg	movlw H'0000';;loadlarge delay
		movf outval
		movf inval
		return

rst7seg nop
		movlw 0x0A
		movwf DOWNCOUNT;;move 10
		;movwf check 
		movlw 0
		;movwf PORTD;clear output and Upcount ;;not/Dn count
		movwf UPCOUNT
		;;movwf DOWNCOUNT
		return

rst7segt nop
		movlw 0x0
		movwf DOWNCOUNT;;move 10
		;movwf check 
		movlw 0x09;test finish downcount
		;movwf PORTD;clear output and Upcount ;;not/Dn count
		movwf UPCOUNT
		;;movwf DOWNCOUNT
		call Table;update table
		movwf PORTD;;update leds with 7 seg
		return
;;end program
		end