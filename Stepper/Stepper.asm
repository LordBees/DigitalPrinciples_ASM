;authors Robert painter, Luke claton
;stepper motor that roteates in 90 degree increments in both directions when a button is pressed
#include <p16f877.inc>	;import standard library


INNER	EQU H'0020'		;assign delay values
OUTER	EQU H'0021'
outval	EQU H'0060'
inval	EQU H'0060'

STEPS	EQU H'0022'		;steps to rotate 
STEPSN 	EQU H'0003'



banksel 	TRISD;set ports to output
		clrf 		TRISD

		banksel 	PORTD;clear output
		clrf 		PORTD
;		movlw 		H'0000';0x00
		movwf 		PORTD;,0x00;//changed from clrf

;		banksel 	TRISB;set input from button
;		movlw       0xFF
;		movwf 		TRISB
		

start   
						  ;button debouncing	
main 	nop
		btfsc PORTB,0;1;0 ;test bit 0 of PORTB if bit is clear skip next instruction
		goto btn2
		call delay
		btfsc PORTB,0;1;0;test bit 0 of PORTB if bit is clear skip next instruction
		goto btn2
		call inc90
		;goto main
btn2	nop
		btfsc PORTB,1;0;test bit 1 of PORTB if bit is clear skip next instruction
		goto main
		call delay
		btfsc PORTB,1;0;test bit 1 of PORTB if bit is clear skip next instruction
		goto main
		call dec90
		goto main

;decrement
;48 steps for 1 rotation
;1 move = 4 steps
;90 degrees = 48/4 = 12 steps
;3 moves for 90

dec90	nop				;decrease by 90 degrees
		movlw STEPSN	;load register with no of steps
		movwf STEPS
		call delay
dec90s	call Backward
		decfsz STEPS,F	;repeat for desired steps
		goto dec90s
		return


inc90	nop				;increase by 90 degrees
		movlw STEPSN	;load register with no of steps
		movwf STEPS
inc90s	call Forward
		call delay
		decfsz STEPS,F	;repeat for desired steps
		goto inc90s
		return

Backward 				;go backward
       	movlw  H'0009'	;1100 0110	     
   		movwf  PORTD	    
       	call delay 		;delay

       	movlw  H'0005'	;1001 0011
     	movwf  PORTD
		call delay		;delay

       	movlw  H'0006'	;0011 1001
     	movwf   PORTD
		call delay 		;delay
             
       	movlw  H'000A'	;0110 1100
     	movwf  PORTD 
       	call delay		;delay

       	return 


Forward 				;R|L go forward
       	movlw  H'000A'	;0110 1100	     
   		movwf  PORTD	    
       	call delay 		;delay

       	movlw  H'0006'	;0011 1001
     	movwf  PORTD
		call delay		;delay

       	movlw  H'0005'	;1001 0011
     	movwf   PORTD
		call delay 		;delay
             
       	movlw  H'0009'	;1100 0110
     	movwf  PORTD 
       	call delay		;delay

       	return 

						;delay sub
delay 	movlw outval	;load register outer
		movwf OUTER
delayx 	movlw inval		;load register inner
		movwf INNER
delayin decfsz INNER,F
		goto delayin
		decfsz OUTER,F
		goto delayx
		return
end