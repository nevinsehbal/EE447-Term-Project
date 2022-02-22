MAGNITUDE_AND_FREQ_ADDR			EQU 0x20000810
GPIO_PORTF_DATA_RED 			EQU 0x40025008 ; data address to all pins
GPIO_PORTF_DATA_GREEN 			EQU 0x40025020 ;
GPIO_PORTF_DATA_BLUE			EQU 0x40025010 ;
GPIO_PORTF_DATA_ALL 			EQU 0x400253FC ;		
POT_VAL_ADDR					EQU 0x2000081C
			
			AREA  Led_Modulee, READONLY, CODE
			THUMB
			EXPORT LedModule
			EXPORT Blink_Led
			EXTERN Disp_Thresh
			EXTERN Convrt
			EXTERN Outstr

LedModule	PROC
			PUSH{LR,R0-R8}
			NOP
			POP {LR,R0-R8}
			BX LR
			ENDP

Blink_Led	PROC
			PUSH{LR,R0-R8}
			LDR R0,=MAGNITUDE_AND_FREQ_ADDR
			LDR R1, [R0] ;the magnitude
			ADD R0, R0, #4
			LDR R2, [R0] ;the freq
			LDR R4,=POT_VAL_ADDR
			LDR R4,[R4] ;the threshold amplitude random
			MOV R3,R4
			BL Disp_Thresh
			MOV R8, #300 ;f_low threshold
			MOV R9, #600 ;f_high threshold
			CMP R7, R3 ;compare with the amplitude threshold
			BHI BigAmp ;R1-R2>0 so the amplitude is bigger than threshold
			B led_off

BigAmp							
			CMP R2, R8
			BHI middleorhigh
			B low
			
middleorhigh					
			CMP R2, R9
			BHI high
			B middle
			
high 							;blue led blinks
			MOV R0,#0x0
			LDR R1,=GPIO_PORTF_DATA_RED
			STR R0,[R1]
			MOV R0,#0x0
			LDR R1,=GPIO_PORTF_DATA_GREEN
			STR R0,[R1]
			MOV R0,#0xFFFFFFFF
			LDR R1,=GPIO_PORTF_DATA_BLUE
			STR R0,[R1]
			B finish
			
middle							;green led blinks
			MOV R0,#0x0
			LDR R1,=GPIO_PORTF_DATA_RED
			STR R0,[R1]
			MOV R0,#0x0
			LDR R1,=GPIO_PORTF_DATA_BLUE
			STR R0,[R1]
			MOV R0,#0xFFFFFFFF
			LDR R1,=GPIO_PORTF_DATA_GREEN
			STR R0,[R1]
			B finish
			
low								;red led blinks
			MOV R0,#0x0
			LDR R1,=GPIO_PORTF_DATA_GREEN
			STR R0,[R1]
			MOV R0,#0x0
			LDR R1,=GPIO_PORTF_DATA_BLUE
			STR R0,[R1]
			MOV R0,#0xFFFFFFFF
			LDR R1,=GPIO_PORTF_DATA_RED
			STR R0,[R1]
			B finish
			
led_off							;led_off
			MOV R0,#0x00000000
			LDR R1,=GPIO_PORTF_DATA_ALL
			STR R0,[R1]
			
finish
			POP {LR,R0-R8}
			BX LR
			ENDP

			ALIGN
			END