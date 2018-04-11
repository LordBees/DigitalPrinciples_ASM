;first asm file
;include "P16F877.INC";include register names
					 ;from another source file
include "p16f877.inc"

start movlw 0;

loop addlw 1;
	 nop;
	 goto loop;
	 end;