;author:robert painter
;button counter for 7 seg display with debounce

			include "p16f877.inc";include

INNER 		EQU H'0020';setup delay values
OUTER 		EQU H'0021'
outval 		EQU H'0000'
inval 		EQU H'0000'

UPCOUNT 	EQU H'0022'
DOWNCOUNT 	EQU H'0023'

check 		EQU H'0024'



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



main	nop					;debounce for increment button
		btfsc PORTB,0;1;0	;bit test bit 0 of register PORTB, if 0 skip next instruction
		goto btn2
		call delay
		btfsc PORTB,0;1;0	;bit test bit 0 of register PORTB, if 0 skip next instruction
		goto btn2			;test twice to ensure button is still held down and press was intentional and not bounced
		call inc7seg
		;goto main
btn2	nop				;debounce for decrement button
		btfsc PORTB,1;0	;bit test bit 0 of register PORTB, if 0 skip next instruction
		goto main
		call delay
		btfsc PORTB,1;0	;bit test bit 0 of register PORTB, if 0 skip next instruction
		goto main		;test twice to ensure button is still held down and press was intentional and not bounced
		call dec7seg
		goto main


inc7seg	nop;;increment 7 sec
		call Tableupd	;update 7seg value using lookup table
		;;call delay;delay from Lab2
		incf UPCOUNT, 1	;update upcounter and copy to W
		movf UPCOUNT, 0	;working register
		;;decfsz DOWNCOUNT,F
		;call Table;call table sub
		
		decfsz DOWNCOUNT,F	;;test to see if max reached if so call reset
		return
		call rst7seg ;if overflowed reset display to 0
		return

dec7seg	nop;;decrement 7 seg
		call Tableupd
		;call Table;call table sub
		incf DOWNCOUNT,1
		movf DOWNCOUNT,0
		
		decfsz UPCOUNT,F;;test to see if max reached if so call reset
		return
		call rst7segt ;if underflowed reset display to 9
		return


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

Tableupd nop;updates 7seg with the value stored in the working register
		movf UPCOUNT,0
		call Table;call table sub
		movwf PORTD;;update leds with 7 seg
		return

;delay subroutine
delay 	movlw outval;load register outer
		movwf OUTER
delayx 	movlw inval;load register inner
		movwf INNER
delayin decfsz INNER,F;decrement, if 0, skip next instruction
		goto delayin
		decfsz OUTER,F;decrement, if 0, skip next instruction
		goto delayx
		return

rst7seg nop;resets the 7 segment to 0
		movlw 0x0A
		movwf DOWNCOUNT;;move 10 to register
		;movwf check 
		movlw 0
		;movwf PORTD;clear output and Upcount ;;not/Dn count
		movwf UPCOUNT;move 0 to register
		;;movwf DOWNCOUNT
		return

rst7segt nop;resets the 7 segment display to 9
		movlw 0x0
		movwf DOWNCOUNT;;move 0
		;movwf check 
		movlw 0x09
		;movwf PORTD;clear output and Upcount ;;not/Dn count
		movwf UPCOUNT;moves 9 to upcount
		;;movwf DOWNCOUNT
		call Table;update table
		movwf PORTD;;update leds with 7 seg
		return
;;end program
		end