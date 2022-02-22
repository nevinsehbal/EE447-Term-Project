SSI0_DR				EQU	0x40008008 ; Clock Prescale
GPIO_PORTA_DATA		EQU	0x400043FC

			AREA  Screen_Modulee, READONLY, CODE
			THUMB
			EXTERN DELAY_10
			EXPORT digit
			EXPORT Disp_Amplitude
			EXPORT Disp_Thresh
			EXPORT Disp_Frequency
				
digit		PROC
			PUSH{LR,R0,R1}
								
			TEQ		R10,#0
			BEQ		zero
			TEQ		R10,#1
			BEQ		one
			TEQ		R10,#2
			BEQ		two
			TEQ		R10,#3
			BEQ		three
			TEQ		R10,#4
			BEQ		four
			TEQ		R10,#5
			B		cont
			
zero		MOV 	R0,#0x1F					
			STR 	R0,[R1]					
			MOV 	R0,#0x11						
			STR 	R0,[R1]					
			MOV 	R0,#0x11						
			STR 	R0,[R1]					
			MOV 	R0,#0x1F						
			STR 	R0,[R1]										
;					MOV 	R0,#0x00
;					STR 	R0,[R1]
			BL		DELAY_10					
			B		FINISH
			
one					MOV 	R0,#0x00					
			STR 	R0,[R1]					
			MOV 	R0,#0x00						
			STR 	R0,[R1]					
			MOV 	R0,#0x00						
			STR 	R0,[R1]					
			MOV 	R0,#0x1F						
			STR 	R0,[R1]										
;					MOV 	R0,#0x00
;					STR 	R0,[R1]
			BL		DELAY_10						
			B		FINISH
			
two					MOV 	R0,#0x1D					
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x17						
			STR 	R0,[R1]										
;					MOV 	R0,#0x00
;					STR 	R0,[R1]
			BL		DELAY_10					
			B		FINISH
			
three				MOV 	R0,#0x15					
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x1F						
			STR 	R0,[R1]										
;					MOV 	R0,#0x00
;					STR 	R0,[R1]
			BL		DELAY_10					
			B		FINISH
			
four				MOV 	R0,#0x07					
			STR 	R0,[R1]					
			MOV 	R0,#0x04						
			STR 	R0,[R1]					
			MOV 	R0,#0x04						
			STR 	R0,[R1]					
			MOV 	R0,#0x1F						
			STR 	R0,[R1]										
;					MOV 	R0,#0x00
;					STR 	R0,[R1]
			BL		DELAY_10					
			B		FINISH
			
five				MOV 	R0,#0x17					
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x1D						
			STR 	R0,[R1]										
;					MOV 	R0,#0x00
;					STR 	R0,[R1]
			BL		DELAY_10						
			B		FINISH
			
cont				BEQ		five
			TEQ		R10,#6
			BEQ		six
			TEQ		R10,#7
			BEQ		seven
			TEQ		R10,#8
			BEQ		eight					
			TEQ		R10,#9
			BEQ		nine
			
six					MOV 	R0,#0x1F					
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x1D						
			STR 	R0,[R1]										
;					MOV 	R0,#0x00
;					STR 	R0,[R1]
			BL		DELAY_10					
			B		FINISH
			
seven				MOV 	R0,#0x01					
			STR 	R0,[R1]					
			MOV 	R0,#0x01						
			STR 	R0,[R1]					
			MOV 	R0,#0x01						
			STR 	R0,[R1]					
			MOV 	R0,#0x1F						
			STR 	R0,[R1]										
;					MOV 	R0,#0x00
;					STR 	R0,[R1]
			BL		DELAY_10					
			B		FINISH
			
eight				MOV 	R0,#0x1F					
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x1F						
			STR 	R0,[R1]										
;					MOV 	R0,#0x00
;					STR 	R0,[R1]
			BL		DELAY_10				
			B		FINISH
			
nine				MOV 	R0,#0x17					
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x1F						
			STR 	R0,[R1]										
;					MOV 	R0,#0x00
;					STR 	R0,[R1]
			BL		DELAY_10							
FINISH
			POP {LR,R0,R1}
			BX LR
			ENDP
				
Disp_Thresh    PROC
			PUSH	{LR, R0, R1,R2,R3,R4,R11,R8,R6,R10,R12}
					
			MOV		R11,#14				
;cursor ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;					
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			BIC 	R0,R0,#0x40			;DC=0 (command)
			STR 	R0,[R1]					
			LDR 	R1,=SSI0_DR 
			MOV 	R0,#0x20		;H=0
			STR 	R0,[R1]
			BL		DELAY_10
			MOV 	R0,#0x42		;3rd row
			STR 	R0,[R1]
			MOV 	R0,#0xB2
			STR 	R0,[R1]
			BL		DELAY_10
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			ORR 	R0,R0,#0x40			;DC=1 (data)
			STR 	R0,[R1]
			LDR 	R1,=SSI0_DR		
			
clr2		MOV 	R0,#0x00
			STR 	R0,[R1]					
			SUBS	R11,#1
			BNE		clr2					
			
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			BIC 	R0,R0,#0x40			;DC=0 (command)
			STR 	R0,[R1]					
			LDR 	R1,=SSI0_DR 
			MOV 	R0,#0x20		;H=0
			STR 	R0,[R1]
			BL		DELAY_10
			MOV 	R0,#0x42		;3rd row
			STR 	R0,[R1]
			MOV 	R0,#0xB2
			STR 	R0,[R1]
			BL		DELAY_10
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			ORR 	R0,R0,#0x40			;DC=1 (data)
			STR 	R0,[R1]
			LDR 	R1,=SSI0_DR		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; R4 keeps amplitude_thresh					
			MOV		R8,#100
			UDIV 	R10,R4,R8 	;first digit
			BL	 	digit				 
			MOV 	R0,#0x00
			STR 	R0,[R1]
			
			MUL 	R3,R10,R8 
			SUB 	R2,R4,R3					
			MOV 	R6,#10
			UDIV 	R10,R2,R6		;second digit				 
			BL	 	digit
			MOV 	R0,#0x00
			STR 	R0,[R1]
			
			MUL 	R12,R10,R6
			SUB 	R10,R2,R12 			;third digit								
			BL	 	digit					
			
			POP		{LR, R0, R1,R2,R3,R4,R11,R8,R6,R10,R12}
			BX LR
			ENDP

Disp_Amplitude    PROC
			PUSH	{LR, R0, R1,R2,R3,R11,R8,R6,R10,R12}
					
			MOV		R11,#14				
;cursor ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;					
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			BIC 	R0,R0,#0x40			;DC=0 (command)
			STR 	R0,[R1]					
			LDR 	R1,=SSI0_DR 
			MOV 	R0,#0x20		;H=0
			STR 	R0,[R1]
			BL		DELAY_10
			MOV 	R0,#0x45		;5th row
			STR 	R0,[R1]
			MOV 	R0,#0xB2
			STR 	R0,[R1]
			BL		DELAY_10
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			ORR 	R0,R0,#0x40			;DC=1 (data)
			STR 	R0,[R1]
			LDR 	R1,=SSI0_DR						
			
clr1		MOV 	R0,#0x00
			STR 	R0,[R1]					
			SUBS	R11,#1
			BNE		clr1					
			
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			BIC 	R0,R0,#0x40			;DC=0 (command)
			STR 	R0,[R1]					
			LDR 	R1,=SSI0_DR 
			MOV 	R0,#0x20		;H=0
			STR 	R0,[R1]
			BL		DELAY_10
			MOV 	R0,#0x45		;5th row
			STR 	R0,[R1]
			MOV 	R0,#0xB2
			STR 	R0,[R1]
			BL		DELAY_10
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			ORR 	R0,R0,#0x40			;DC=1 (data)
			STR 	R0,[R1]
			LDR 	R1,=SSI0_DR		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; R7 keeps amplitude					
			MOV		R8,#100
			UDIV 	R10,R7,R8 	;first digit
			BL	 	digit				 
			MOV 	R0,#0x00
			STR 	R0,[R1]
			
			MUL 	R3,R10,R8 
			SUB 	R2,R7,R3					
			MOV 	R6,#10
			UDIV 	R10,R2,R6		;second digit				 
			BL	 	digit
			MOV 	R0,#0x00
			STR 	R0,[R1]
			
			MUL 	R12,R10,R6
			SUB 	R10,R2,R12 			;third digit								
			BL	 	digit					
			
			POP		{LR, R0, R1,R2,R3,R11,R8,R6,R10,R12}
			BX LR
			ENDP

Disp_Frequency   PROC
			PUSH	{LR, R0, R1,R2,R3,R4,R8,R6,R10,R12}
					
			MOV		R4,#14				
;cursor ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;					
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			BIC 	R0,R0,#0x40			;DC=0 (command)
			STR 	R0,[R1]					
			LDR 	R1,=SSI0_DR 
			MOV 	R0,#0x20		;H=0
			STR 	R0,[R1]
			BL		DELAY_10
			MOV 	R0,#0x44		;5th row
			STR 	R0,[R1]
			MOV 	R0,#0xB2
			STR 	R0,[R1]
			BL		DELAY_10
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			ORR 	R0,R0,#0x40			;DC=1 (data)
			STR 	R0,[R1]
			LDR 	R1,=SSI0_DR						
			
clr					MOV 	R0,#0x00
			STR 	R0,[R1]					
			SUBS	R4,#1
			BNE		clr					
			
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			BIC 	R0,R0,#0x40			;DC=0 (command)
			STR 	R0,[R1]					
			LDR 	R1,=SSI0_DR 
			MOV 	R0,#0x20		;H=0
			STR 	R0,[R1]
			BL		DELAY_10
			MOV 	R0,#0x44		;5th row
			STR 	R0,[R1]
			MOV 	R0,#0xB2
			STR 	R0,[R1]
			BL		DELAY_10
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			ORR 	R0,R0,#0x40			;DC=1 (data)
			STR 	R0,[R1]
			LDR 	R1,=SSI0_DR		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; R9 keeps the number					
			MOV		R8,#100
			UDIV 	R10,R9,R8 	;first digit
			BL	 	digit				 
			MOV 	R0,#0x00
			STR 	R0,[R1]
			
			MUL 	R3,R10,R8 
			SUB 	R2,R9,R3					
			MOV 	R6,#10
			UDIV 	R10,R2,R6		;second digit				 
			BL	 	digit
			MOV 	R0,#0x00
			STR 	R0,[R1]
			
			MUL 	R12,R10,R6
			SUB 	R10,R2,R12 			;third digit								
			BL	 	digit					
			
			POP		{LR, R0, R1,R2,R3,R4,R8,R6,R10,R12}
	BX LR
			ENDP
				
			ALIGN
			END