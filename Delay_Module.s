


			AREA delaymodulee, READONLY, CODE
			THUMB
			EXPORT DELAY_10
			EXPORT DELAY_100


DELAY_10	PROC
			PUSH {LR,R0}
			LDR		     R0,=0x1770
; Total loop cycle is 4			
loop1	    SUBS		 R0,#0x1 		; approximately 20ms	
            NOP                 		; approximately 20ms		
			BNE			 loop1  			; approximately 60ms
			POP {LR,R0}
			BX LR
			ENDP
			

DELAY_100	PROC
			PUSH {LR,R0}
			LDR		     R0,=0x3AD68
; Total loop cycle is 4			
loop	    SUBS		 R0,#0x1 		; approximately 20ms	
            NOP                 		; approximately 20ms		
			BNE			 loop 
			POP {LR,R0}
			BX LR
			ENDP

			ALIGN
			END