
;SAMPLE_ADDR EQU 0x20000400
ADC0_RIS EQU 0x40038004 ; Interrupt status
ADC0_PSSI EQU 0x40038028 ; Initiate sample	
ADC1_PSSI EQU 0x40039028 ; Initiate sample
ADC0_SSFIFO3 EQU 0x400380A8 ; Channel 3 results
ADC0_ISC	EQU	0x4003800C	
SAMPLE_ADDR EQU 0x20000400
SSI0_DR				EQU	0x40008008 ; Data 	
GPIO_PORTA_DATA		EQU	0x400043FC
	
RELOAD_VALUE_ADDR EQU 0x20000400

			AREA  mainn, READONLY, CODE
			THUMB
			EXTERN LedModule_init ;PORTF(1,2,3) config
			EXTERN MicrophoneModule_init ;ADC0 Config & SysTick Config & PE3 connect
			EXTERN ScreenModule_init ;PORTA & SSI Config
			EXTERN MotorModule_init ;PORTF(0,4) config & PORTD(0,1,2,3) Config & GPTM(Timer0A) Config
			EXTERN POT_Threshold_Module_init ;ADC1 Config & PE2 connect
			EXTERN ROW1					
			EXTERN ROW2	
			EXTERN ROW3	
			EXTERN ROW56
			EXTERN POT_Polling
			EXPORT __main


__main		PROC
			BL ScreenModule_init
			BL ROW1					
			BL ROW2	
			BL ROW3	
			BL ROW56
			BL POT_Threshold_Module_init
			BL LedModule_init
			BL MotorModule_init
			BL MicrophoneModule_init
			MOV R11,#256;
			LDR R4,=SAMPLE_ADDR
start1	
			; start sampling routine
			LDR R1, =ADC0_PSSI ; sample sequence initiate address
			; initiate sampling by enabling sequencer 3 in ADC0_PSSI
			LDR R0, [R1]
			ORR R0, R0, #0x08 ; set bit 3 for SS3
			STR R0, [R1]
			LDR R1, =ADC1_PSSI ; sample sequence initiate address
			; initiate sampling by enabling sequencer 3 in ADC0_PSSI
			LDR R0, [R1]
			ORR R0, R0, #0x08 ; set bit 3 for SS3
			STR R0, [R1]
POT_Read	BL POT_Polling
			B 	start1
			ENDP
			ALIGN
			END