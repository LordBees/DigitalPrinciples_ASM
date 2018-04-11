; PIC18F45K20 buggycodes starter.asm

; *******************************************************************

;DON'T  FORGET TO REMEMBER TO OUTPUT 00000000 TO PORT D IF YOU STOP THE PROGRAM. 
;THE PORT AND MOTORS WILL HAVE ONE OF THE 4 CODES ON IT AND MAYBE OVERHEAT!

;************************************************************************
	
#include <p18f45k20.inc>

;WE CAN SET UP THE CONFIGURATION HERE INSTEAD OF BY SETTING 'configuration bits' AS WE DID BEFORE. 
;BUT HAVE A LOOK AT THEM:    click on 'Configure' at the top when you have assembled your code.
 
	config FOSC = INTIO67
	config FCMEN = OFF
	config IESO = OFF
	config PWRT = OFF, BOREN = SBORDIS, BORV = 30                      	
	config WDTEN = OFF, WDTPS = 32768                                 	
 	config MCLRE = OFF, LPT1OSC = OFF, PBADEN = ON, CCP2MX = PORTC     	
	config STVREN = ON, LVP = OFF, XINST = OFF                        	
 	config CP0 = OFF, CP1 = OFF, CP2 = OFF, CP3 = OFF                  	
	config CPB = OFF, CPD = OFF                                       	
 	config WRT0 = OFF, WRT1 = OFF, WRT2 = OFF, WRT3 = OFF             	
 	config WRTB = OFF, WRTC = OFF, WRTD = OFF                          
 	config EBTR0 = OFF, EBTR1 = OFF, EBTR2 = OFF, EBTR3 = OFF          
 	config EBTRB = OFF  	


    cblock     0x20  	;THIS SAYS LEAVE 20 BYTES (FOR THE DELAY ROUTINES) JUST AFTER THE PROGRAM
			;INSTRUCTIONS WHEREVER IT FINISHES

	;Register names defined For the delay routine

	TIMINNER	
	TIMOUTER
	endc
     
     org 0x0			;Start assembling the program code at address 0

;****************************SET UP REGISTERS****************************
	    
;NOTE THAT WITH THIS PIC WE DO NOT HAVE TO CHANGE BANKS TO ACCESS THESE REGISTERS

INNER	EQU H'0020'
OUTER	EQU H'0021'
outval	EQU H'0020'
inval	EQU H'0020'

;movlw targdel
;movwf dMov
targdel EQU H'0008'
dMov	EQU H'0022';;addr 0x0022

Start movlw     0xFF         ;DON'T FORGET TO COMMENT EACH LINE TO SHOW YOU 
                             ;UNDERSTAND.

     movwf    TRISA       	; (Port A is connected to the potentiometer but we do not need this for the 
							; project).
     clrf	TRISD                
     ;movlw	B'00101111';'1110100';'00101111';0x01
	 movlw  0x0E;B'00001011'     			
     movwf	TRISB               	
     movlw	0x1F              ; PIC18F45K20 Data sheet see page 136 for ANSEL Bits 1= Analog 0 = Digital
     movwf	ANSEL         ; PortA pins are all analog, PortE pins are digital
     movlw	0x00	  ; see page 137 ANSELH bits 0 for Digital
     movwf	ANSELH      ; PortB pins are digitial (important as RB0 is switch)

									

;*********** THIS SECTION WILL ROTATE BOTH MOTORS VERY  SLOWLY **********
;DON'T FORGET TO COMMENT EVERY LINE TO SHOW YOU UNDERSTAND
;AND THESE NEED TO BE SHOWING ON YOUR LISTING FILE



;--main
main
	;;

		;movf PORTB,0;;to keep leds on or bitmask on leds
		;iorlw B'00101111';0x2F
		;goto main
	;call Forward
		call	lsense;poll each set of sensors to see what to do
		call	rsense
		call	bsense
		call	Forward;;go forward
	;;
	goto main

;------------------movement routines---------------------
Backward 
       	movlw  H'00C6';1100 0110	     
   		movwf  PORTD	    
       	call delay 

       	movlw  H'0093';1001 0011
     	movwf  PORTD
		call delay

       	movlw  H'0039';0011 1001
     	movwf   PORTD
		call delay 
             
       	movlw  H'006C';0110 1100
     	movwf  PORTD 
       	call delay

       	return;goto Forward   

Leftb	nop
		movlw  H'0006';0000 0110	     
   		movwf  PORTD	    
       	call delay 

       	movlw  H'0003';0000 0011
     	movwf  PORTD
		call delay

       	movlw  H'0009';0000 1001
     	movwf   PORTD
		call delay 
             
       	movlw  H'000C';0000 1100
     	movwf  PORTD 
       	call delay
		
		return;goto Left

Rightb	nop
		movlw  H'00C0';1100 0000	     
   		movwf  PORTD	    
       	call delay 

       	movlw  H'0090';1001 0000
     	movwf  PORTD
		call delay

       	movlw  H'0030';0011 0000
     	movwf   PORTD
		call delay 
             
       	movlw  H'0060';0110 0000
     	movwf  PORTD 
		call delay
		
		return;goto Right

Forward 				;R|L
       	movlw  H'006C';	     
   		movwf  PORTD	    
       	call delay 

       	movlw  H'0039';
     	movwf  PORTD
		call delay

       	movlw  H'0093';
     	movwf   PORTD
		call delay 
             
       	movlw  H'00C6';
     	movwf  PORTD 
       	call delay

       	return;goto Forward   

Leftf	nop
		movlw  H'000C';	     
   		movwf  PORTD	    
       	call delay 

       	movlw  H'0009';
     	movwf  PORTD
		call delay

       	movlw  H'0003';
     	movwf   PORTD
		call delay 
             
       	movlw  H'0006';
     	movwf  PORTD 
       	call delay
		
		return;goto Left

Rightf	nop
		movlw  H'0060'	     
   		movwf  PORTD	    
       	call delay 

       	movlw  H'0030'
     	movwf  PORTD
		call delay

       	movlw  H'0090'
     	movwf   PORTD
		call delay 
             
       	movlw  H'0060'
     	movwf  PORTD 
		call delay
		
		return;goto Right

;--------- quick routines
SRB nop;stop right back
	call Rightb
;	call delayMove
;	call Backward
	;call delayMove
	decfsz dMov,F
	goto SRB
	movlw targdel
	movwf dMov
SRB2 nop
	call Backward
	decfsz dMov,F
	goto SRB2
	return

SLB nop;stop left back
	call Leftb
	decfsz dMov,F
	goto SLB

	movlw targdel
	movwf dMov
SLB2 nop
	call Backward
	decfsz dMov,F
	goto SLB2
	return

SBB nop;stop Back forward
	call Forward
	call Rightf
	return
;----------checking routine

;lsense
lsense 
		;btfsc
		;movf PORTB,0
		movlw targdel
		movwf dMov
		btfsc PORTB,1;5
		return
		call SRB
;rsense
rsense 	nop
		movlw targdel
		movwf dMov
		btfsc PORTB,2;3
		return
		call SLB
		
;bsense
bsense	nop
		btfsc PORTB,3;6
		call SBB
		return
		             
    
 ;*************************DELAY ROUTINE*****************    

delay 	movlw outval;load register outer
		movwf OUTER
delayx 	movlw inval;load register inner
		movwf INNER
delayin decfsz INNER,F
		goto delayin
		decfsz OUTER,F
		goto delayx
		return

delayMove 	movlw targdel
			movwf dMov
delayMove1 	decfsz INNER,F
			goto delayMove1
			return
		


;**********************************************************************************		
end