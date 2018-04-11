;***********************************************************************************************************
;*                                     This program configures the A/D Module to convert on     
;*                                     A/D channel 3 (the potentiometer) and display the             
;*                                     results on the LEDS on PORTD.                                           
; *                                    Written by Patrick Wraith
;***********************************************************************************************************
	include "p16f877.inc"

COUNTER EQU	H'0020'		 		;Delay value register
		org	0x000				;Originate at address 0000
		clrf	PORTD			;Clear Port D of any left-overs
Start	bsf	STATUS,RP0			;Change to bank 1 for 				  					
								;TRISD/TRISA/OPTION/ADCON1
		clrf	TRISD			;Clear PORTD as outputs for the leds
		movlw	H'003F'			;Set up Port A as inputs
		movwf	TRISA			;
		movlw	H'0002'			;Study the ADCON1 register to see what 
		movwf	ADCON1			;has been set up here.  Note it here!	
		bcf	STATUS, RP0			;What happens here?  Note it here!
		movlw	B'01010001'		;What bits have been set in ADCON0 and why?
		movwf	ADCON0			;Note it here!
Main	bsf	ADCON0, GO_DONE		;Start A/D conversion. How ?
		movlw	10				;The sample and Hold of the A-D converter
		movwf	COUNTER			;Needs a while to settle.
Delay	decfsz COUNTER,F		;What happened here then?
		goto	Delay		
Conv	btfsc	ADCON0, GO_DONE	;Test this bit to check that A/D          
								;conversion is complete
		goto	Conv			;Keep checking until it is.
		;movf	ADRESH,W		;Write A/D result into w. Is this a 10 bit value? 
		;movwf	PORTD			;Send it to the LEDs. 
		rrf ADRESH,1 ;rotate adress
		rrf ADRESH,1 ;rotate adress
		rrf ADRESH,1 ;rotate adress
		rrf ADRESH,0 ;rotate adress
		andlw B'00001111' ; and address so that we get a range of values(the higher ones for better range)
		call Tableupd; update the 7 seg with the data obtained
		goto	Main			;Do it again




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
		return; ensures bounds check as values unimplemented for nibble
		return;
		return;
		return;
		return;
		return;


Tableupd nop;
		;movf UPCOUNT,0
		call Table;call table sub
		movwf PORTD;;update leds with 7 seg
		return

		end
