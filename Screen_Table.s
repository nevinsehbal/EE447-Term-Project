SSI0_DR				EQU	0x40008008 ; Data 	
GPIO_PORTA_DATA		EQU	0x400043FC


			AREA  Screen_Tablee, READONLY, CODE
			THUMB
			
			EXTERN DELAY_10
			EXTERN DELAY_100
			EXPORT ROW1


ROW1		PROC
			PUSH{LR,R0,R1}
			LDR R1,=SSI0_DR
;;; U ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;						
			MOV 	R0,#0x1F					
			STR 	R0,[R1]					
			MOV 	R0,#0x10						
			STR 	R0,[R1]					
			MOV 	R0,#0x10						
			STR 	R0,[R1]					
			MOV 	R0,#0x1F						
			STR 	R0,[R1]										
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10
;;; p ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;										
			MOV 	R0,#0x7C						
			STR 	R0,[R1]					
			MOV 	R0,#0x14					
			STR 	R0,[R1]
			MOV 	R0,#0x1C					
			STR 	R0,[R1]
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10
;;; p ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x7C						
			STR 	R0,[R1]					
			MOV 	R0,#0x14					
			STR 	R0,[R1]
			MOV 	R0,#0x1C					
			STR 	R0,[R1]
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10
;;; . ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;											
			MOV 	R0,#0x10						
			STR 	R0,[R1]	
			MOV 	R0,#0x00
			STR 	R0,[R1]
;;; F ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x1F						
			STR 	R0,[R1]					
			MOV 	R0,#0x05					
			STR 	R0,[R1]
			MOV 	R0,#0x01					
			STR 	R0,[R1]
			MOV 	R0,#0x00
			STR 	R0,[R1]	
			BL		DELAY_10
;;; r ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x1C						
			STR 	R0,[R1]					
			MOV 	R0,#0x04					
			STR 	R0,[R1]					
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10
;;; q ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x1C						
			STR 	R0,[R1]					
			MOV 	R0,#0x14					
			STR 	R0,[R1]
			MOV 	R0,#0x7C					
			STR 	R0,[R1]
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10
;;; . ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;											
			MOV 	R0,#0x10						
			STR 	R0,[R1]
			MOV 	R0,#0x00
			STR 	R0,[R1]
;;; T ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x01						
			STR 	R0,[R1]					
			MOV 	R0,#0x1F					
			STR 	R0,[R1]
			MOV 	R0,#0x01					
			STR 	R0,[R1]
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10
			
;;; h ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x1F						
			STR 	R0,[R1]					
			MOV 	R0,#0x04					
			STR 	R0,[R1]
			MOV 	R0,#0x1C					
			STR 	R0,[R1]
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10					
;;; = ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x14						
			STR 	R0,[R1]					
			MOV 	R0,#0x14					
			STR 	R0,[R1]
			MOV 	R0,#0x14					
			STR 	R0,[R1]
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DISPLAY NUMBER ;;;;;;;;;;;;;;;;	

			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			BIC 	R0,R0,#0x40			;DC=0 (command)
			STR 	R0,[R1]					
			LDR 	R1,=SSI0_DR 
			MOV 	R0,#0x20		;H=0
			STR 	R0,[R1]
			MOV 	R0,#0xB2		;horizontal
			STR 	R0,[R1]
			BL		DELAY_10
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			ORR 	R0,R0,#0x40			;DC=1 (data)
			STR 	R0,[R1]					
			LDR 	R1,=SSI0_DR	
;;; 6 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x1F					
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x15						
			STR 	R0,[R1]					
			MOV 	R0,#0x1D						
			STR 	R0,[R1]										
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10	
;;; 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x1F					
			STR 	R0,[R1]					
			MOV 	R0,#0x11						
			STR 	R0,[R1]					
			MOV 	R0,#0x11						
			STR 	R0,[R1]					
			MOV 	R0,#0x1F						
			STR 	R0,[R1]										
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10	
;;; 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x1F					
			STR 	R0,[R1]					
			MOV 	R0,#0x11						
			STR 	R0,[R1]					
			MOV 	R0,#0x11						
			STR 	R0,[R1]					
			MOV 	R0,#0x1F						
			STR 	R0,[R1]										
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			BIC 	R0,R0,#0x40			;DC=0 (command)
			STR 	R0,[R1]					
			LDR 	R1,=SSI0_DR 
			MOV 	R0,#0x20		;H=0
			STR 	R0,[R1]
			MOV 	R0,#0xC6		;horizontal
			STR 	R0,[R1]
			BL		DELAY_10
			LDR 	R1,=GPIO_PORTA_DATA 
			LDR 	R0,[R1]
			ORR 	R0,R0,#0x40			;DC=1 (data)
			STR 	R0,[R1]					
			LDR 	R1,=SSI0_DR	
;;; H ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x1F						
			STR 	R0,[R1]					
			MOV 	R0,#0x04					
			STR 	R0,[R1]
			MOV 	R0,#0x04					
			STR 	R0,[R1]
			MOV 	R0,#0x1F						
			STR 	R0,[R1]
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10	
;;; z ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
			MOV 	R0,#0x12						
			STR 	R0,[R1]					
			MOV 	R0,#0x1A					
			STR 	R0,[R1]
			MOV 	R0,#0x16					
			STR 	R0,[R1]
			MOV 	R0,#0x12						
			STR 	R0,[R1]
			MOV 	R0,#0x00
			STR 	R0,[R1]
			BL		DELAY_10
			POP {LR,R0,R1}
			BX LR
			ENDP	

			ALIGN
			END