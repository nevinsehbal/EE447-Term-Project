
;ADC1 Config & PE2 connect

; ADC Registers 
RCGCADC 		EQU 0x400FE638 ; ADC clock register 
; ADC0 base address EQU 0x40038000 
ADC1_ACTSS 		EQU 0x40039000 ; Sample sequencer (ADC0 base address) 
ADC1_RIS 		EQU 0x40039004 ; Interrupt status 
ADC1_IM 		EQU 0x40039008 ; Interrupt select 
ADC1_EMUX 		EQU 0x40039014 ; Trigger select 
ADC1_PSSI 		EQU 0x40039028 ; Initiate sample 
ADC1_SSMUX3 	EQU 0x400390A0 ; Input channel select 
ADC1_SSCTL3 	EQU 0x400390A4 ; Sample sequence control
ADC1_SSFIFO3 	EQU 0x400390A8 ; Channel 3 results 
ADC1_PC 		EQU 0x40039FC4 ; Sample rate 
ADC1_ISC		EQU 0x4003900C ; Interrupt Status and Clear Register
	
; GPIO Registers 
RCGCGPIO 		EQU 0x400FE608 ; GPIO clock register 
;PORT E base address EQU 0x40024000 
PORTE_DIR		EQU 0x40024400 ; Direction Register
PORTE_DEN 		EQU 0x4002451C ; Digital Enable 
PORTE_PCTL 		EQU 0x4002452C ; Alternate function select 
PORTE_AFSEL 	EQU 0x40024420 ; Enable Alt functions 
PORTE_AMSEL 	EQU 0x40024528 ; Enable analog
	
POT_VAL_ADDR EQU 0x2000081C

; Interrupt Registers
;NVIC_ST_CTRL 	EQU 0xE000E010
;NVIC_ST_RELOAD 	EQU 0xE000E014
;NVIC_ST_CURRENT EQU 0xE000E018
;SHP_SYSPRI3 	EQU 0xE000ED20
	
			AREA potThresh, READONLY, CODE
			THUMB
			EXPORT POT_Threshold_Module_init
			EXPORT POT_Polling

POT_Threshold_Module_init PROC
			PUSH{LR,R0-R1}
			
PORT_E3_config
			; Start clocks for features to be used 
			LDR R1, =RCGCADC ; Turn on ADC clock 
			LDR R0, [R1] 
			ORR R0, R0, #0x02 ; set bit 0 to enable ADC1 clock 
			STR R0, [R1] 
			NOP
			NOP
			NOP ; Let clock stabilize
			
			LDR R1, =RCGCGPIO ; Turn on GPIO clock 
			LDR R0, [R1]
			ORR R0, R0, #0x10 ; set bit 4 to enable port E clock 
			STR R0, [R1] 
			NOP
			NOP
			NOP ; Let clock stabilize
			
			; Setup GPIO to make PE3 input for ADC0 
			; Enable alternate functions 
			LDR R1, =PORTE_AFSEL 
			LDR R0, [R1] 
			ORR R0, R0, #0x04 ; set bit 3 to enable alt functions on PE2 
			STR R0, [R1] 
			; PCTL does not have to be configured 
			; since ADC0 is automatically selected when 
			; port pin is set to analog. 
			; Disable digital on PE3 
			LDR R1, =PORTE_DEN 
			LDR R0, [R1] 
			BIC R0, R0, #0x04 ; clear bit 3 to disable digital on PE2
			STR R0, [R1] 
			
			;Set direction of PE2
			LDR R1, =PORTE_DIR 
			LDR R0, [R1] 
			BIC R0, R0, #0x04 ; clear bit 2 input
			STR R0, [R1]

			; Enable analog on PE3 
			LDR R1, =PORTE_AMSEL 
			LDR R0, [R1] 
			ORR R0, R0, #0x04 ; set bit 2 to enable analog on PE3 
			STR R0, [R1]
			
ADC1_config
			
			; Disable sequencer while ADC setup 
			LDR R1, =ADC1_ACTSS 
			LDR R0, [R1] 
			BIC R0, R0, #0x08 ; clear bit 3 to disable seq 3 
			STR R0, [R1] 
			
			; Select trigger source 
			LDR R1, =ADC1_EMUX 
			LDR R0, [R1] 
			BIC R0, R0, #0xF000 ; clear bits 15:12 to select SOFTWARE 
			STR R0, [R1] ; trigger
			
			; Select input channel 
			LDR R1, =ADC1_SSMUX3 
			LDR R0, [R1] 
			BIC R0, R0, #0x000F ; clear bits 3:0 to select AIN0 
			ORR R0, R0, #0x0001 ; clear bits 3:0 to select AIN0 
			STR R0, [R1]
			
			; Config sample sequence 
			LDR R1, =ADC1_SSCTL3 
			LDR R0, [R1] 
			ORR R0, R0, #0x06 ; set bits 2:1 (IE0, END0) IE0 is set since we want RIS to be set
			STR R0, [R1] 
			
			; Set sample rate 
			LDR R1, =ADC1_PC
			LDR R0, [R1] 
			ORR R0, R0, #0x01 ; set bits 3:0 to 1 for 125k sps 
			STR R0, [R1] 

			; Done with setup, enable sequencer 
			LDR R1, =ADC1_ACTSS 
			LDR R0, [R1] 
			ORR R0, R0, #0x08 ; set bit 3 to enable seq 3 
			STR R0, [R1] ; sampling enabled but not initiated yet
			
			;Disable Interrupt
			LDR R1, =ADC1_IM
			LDR R0, [R1] 
			BIC R0, R0, #0x08 ; disable interrupt
			STR R0, [R1]

			POP{LR,R0-R1}
			BX LR
			ENDP
				
POT_Polling PROC
			PUSH{LR,R0-R9}
			
			LDR R1, =ADC1_RIS ; interrupt address
			LDR R2, =ADC1_SSFIFO3 ; result address
			LDR R3,= ADC1_ISC ;interrupt status clear reg
			LDR R4,= POT_VAL_ADDR;
Cont 		LDR R0, [R1]
			ANDS R0, R0, #8
			BEQ Cont ;if flag is 0
			;branch fails if the flag is set so data can be read and flag is cleared
			LDR R9,[R2]
			;SUB R9,#0x610 ;substract 1552 == 1.25V
			LSR R9, #2
			STR R9,[R4] ;store the data
			MOV R0, #8
			STR R0, [R3] ; clear flag
			POP{LR,R0-R9}
			BX LR
			ENDP
			ALIGN
			END