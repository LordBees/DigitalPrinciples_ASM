#include <p16f877.inc>


INNER	EQU H'0020'
OUTER	EQU H'0021'
outval	EQU H'0060'
inval	EQU H'0060'

STEPS	EQU H'0022'
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

main 	nop
		btfsc PORTB,0;1;0
		goto btn2
		call delay
		btfsc PORTB,0;1;0
		goto btn2
		call inc90
		;goto main
btn2	nop
		btfsc PORTB,1;0
		goto main
		call delay
		btfsc PORTB,1;0
		goto main
		call dec90
		goto main

;decrement
;48 steps for 1 rotation
;1 move = 4 steps
;90 degrees = 48/4 = 12 steps
;3 moves for 90

dec90	nop
		movlw STEPSN;load register outer
		movwf STEPS
		call delay
dec90s	call Backward
		decfsz STEPS,F
		goto dec90s
		return


inc90	nop
		movlw STEPSN;load register outer
		movwf STEPS
inc90s	call Forward
		call delay
		decfsz STEPS,F
		goto inc90s
		return
Backward 

       	movlw  H'0009';1100 0110	     
   		movwf  PORTD	    
       	call delay 

       	movlw  H'0005';1001 0011
     	movwf  PORTD
		call delay

       	movlw  H'0006';0011 1001
     	movwf   PORTD
		call delay 
             
       	movlw  H'000A';0110 1100
     	movwf  PORTD 
       	call delay

       	return;goto Forward 


Forward 				;R|L
       	movlw  H'000A';	     
   		movwf  PORTD	    
       	call delay 

       	movlw  H'0006';
     	movwf  PORTD
		call delay

       	movlw  H'0005';
     	movwf   PORTD
		call delay 
             
       	movlw  H'0009';
     	movwf  PORTD 
       	call delay

       	return;goto Forward 

delay 	movlw outval;load register outer
		movwf OUTER
delayx 	movlw inval;load register inner
		movwf INNER
delayin decfsz INNER,F
		goto delayin
		decfsz OUTER,F
		goto delayx
		return
end