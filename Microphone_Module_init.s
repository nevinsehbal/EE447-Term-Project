
;ADC0 Config & SysTick Config & PE3 connect

; ADC Registers 
RCGCADC 		EQU 0x400FE638 ; ADC clock register 
; ADC0 base address EQU 0x40038000 
ADC0_ACTSS 		EQU 0x40038000 ; Sample sequencer (ADC0 base address) 
ADC0_RIS 		EQU 0x40038004 ; Interrupt status 
ADC0_IM 		EQU 0x40038008 ; Interrupt select 
ADC0_EMUX 		EQU 0x40038014 ; Trigger select 
ADC0_PSSI 		EQU 0x40038028 ; Initiate sample 
ADC0_SSMUX3 	EQU 0x400380A0 ; Input channel select 
ADC0_SSCTL3 	EQU 0x400380A4 ; Sample sequence control
ADC0_SSFIFO3 	EQU 0x400380A8 ; Channel 3 results 
ADC0_PC 		EQU 0x40038FC4 ; Sample rate 
ADC0_ISC		EQU 0x4003800C ; Interrupt Status and Clear Register
	
; GPIO Registers 
RCGCGPIO 		EQU 0x400FE608 ; GPIO clock register 
;PORT E base address EQU 0x40024000 
PORTE_DIR		EQU 0x40024400 ; Direction Register
PORTE_DEN 		EQU 0x4002451C ; Digital Enable 
PORTE_PCTL 		EQU 0x4002452C ; Alternate function select 
PORTE_AFSEL 	EQU 0x40024420 ; Enable Alt functions 
PORTE_AMSEL 	EQU 0x40024528 ; Enable analog

; Interrupt Registers
NVIC_ST_CTRL 	EQU 0xE000E010
NVIC_ST_RELOAD 	EQU 0xE000E014
NVIC_ST_CURRENT EQU 0xE000E018
SHP_SYSPRI3 	EQU 0xE000ED20
	
			AREA  initialization2, READONLY, CODE
			THUMB
			EXPORT MicrophoneModule_init


MicrophoneModule_init PROC
			PUSH{LR,R0-R1}
			
PORT_E3_config
			; Start clocks for features to be used 
			LDR R1, =RCGCADC ; Turn on ADC clock 
			LDR R0, [R1] 
			ORR R0, R0, #0x01 ; set bit 0 to enable ADC0 clock 
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
			ORR R0, R0, #0x08 ; set bit 3 to enable alt functions on PE3 
			STR R0, [R1] 
			; PCTL does not have to be configured 
			; since ADC0 is automatically selected when 
			; port pin is set to analog. 
			; Disable digital on PE3 
			LDR R1, =PORTE_DEN 
			LDR R0, [R1] 
			BIC R0, R0, #0x08 ; clear bit 3 to disable digital on PE3
			STR R0, [R1] 
			
			;Set direction of DE3
			LDR R1, =PORTE_DIR 
			LDR R0, [R1] 
			BIC R0, R0, #0x08 ; clear bit 3 input
			STR R0, [R1]

			; Enable analog on PE3 
			LDR R1, =PORTE_AMSEL 
			LDR R0, [R1] 
			ORR R0, R0, #0x08 ; set bit 3 to enable analog on PE3 
			STR R0, [R1]
			
ADC0_config
			
			; Disable sequencer while ADC setup 
			LDR R1, =ADC0_ACTSS 
			LDR R0, [R1] 
			BIC R0, R0, #0x08 ; clear bit 3 to disable seq 3 
			STR R0, [R1] 
			
			; Select trigger source 
			LDR R1, =ADC0_EMUX 
			LDR R0, [R1] 
			BIC R0, R0, #0xF000 ; clear bits 15:12 to select SOFTWARE 
			STR R0, [R1] ; trigger
			
			; Select input channel 
			LDR R1, =ADC0_SSMUX3 
			LDR R0, [R1] 
			BIC R0, R0, #0x000F ; clear bits 3:0 to select AIN0 
			STR R0, [R1]
			
			; Config sample sequence 
			LDR R1, =ADC0_SSCTL3 
			LDR R0, [R1] 
			ORR R0, R0, #0x06 ; set bits 2:1 (IE0, END0) IE0 is set since we want RIS to be set
			STR R0, [R1] 
			
			; Set sample rate 
			LDR R1, =ADC0_PC
			LDR R0, [R1] 
			ORR R0, R0, #0x01 ; set bits 3:0 to 1 for 125k sps 
			STR R0, [R1] 

			; Done with setup, enable sequencer 
			LDR R1, =ADC0_ACTSS 
			LDR R0, [R1] 
			ORR R0, R0, #0x08 ; set bit 3 to enable seq 3 
			STR R0, [R1] ; sampling enabled but not initiated yet
			
			;Disable Interrupt
			LDR R1, =ADC0_IM
			LDR R0, [R1] 
			BIC R0, R0, #0x08 ; disable interrupt
			STR R0, [R1]
			
SysTick_config
			LDR R1 ,=NVIC_ST_CTRL
			MOV R0,#0
			STR R0,[R1]
			LDR R1,=NVIC_ST_CURRENT
			STR R0,[R1]
			LDR R1,=NVIC_ST_RELOAD
			MOV R0,#2000 ;rel value for 0.5 msec
			STR R0,[R1]
			LDR R1,=SHP_SYSPRI3
			MOV R0,#0x40000000
			STR R0,[R1]
			LDR R1,=NVIC_ST_CTRL
			MOV R0,#0x03
			STR R0,[R1]

			POP{LR,R0-R1}
			BX LR
			ENDP
			ALIGN
			END