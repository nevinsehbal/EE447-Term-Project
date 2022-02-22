

;PORTA & SSI Config

;SSI0 base address = 0x40008000	
SYSCTL_RCGCSSI	EQU 0x400FE61C ; ADC clock register
SYSCTL_PRSSI	EQU 0x400FEA1C ; ADC clock register
SSI0_CR0		EQU	0x40008000 ; Control 0
SSI0_CR1		EQU	0x40008004 ; Control 1
SSI0_CPSR		EQU	0x40008010 ; Clock Prescale
SSI0_DR			EQU	0x40008008 ; Clock Prescale

; GPIO Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO clock register
GPIO_PORTA_DIR 		EQU 0x40004400 ; Port direction
GPIO_PORTA_AFSEL	EQU 0x40004420 ; Alternate function select
GPIO_PORTA_DEN 		EQU 0x4000451C ; Enable digital
GPIO_PORTA_AMSEL 	EQU 0x40004528 ; Analog mode select
GPIO_PORTA_PCTL 	EQU 0x4000452C ; Port Control
GPIO_PORTA_PUR 		EQU 0x40004510
GPIO_PORTA_LOCK		EQU	0x40004520		
GPIO_PORTA_CR		EQU	0x40004524	
GPIO_PORTA_DATA		EQU	0x400043FC	

			AREA  initialization3, READONLY, CODE
			THUMB
			EXTERN DELAY_100
			EXPORT ScreenModule_init

ScreenModule_init PROC
			PUSH{LR,R0,R1}

PORT_A_0123567_Config

			LDR R1,=SYSCTL_RCGCGPIO 
			LDR 	R0,[R1]
			ORR 	R0,R0,#0x01
			STR 	R0,[R1] 
			NOP
			NOP
			NOP
			
			LDR 	R1,=GPIO_PORTA_LOCK			
			LDR 	R0,=0x4C4F434B				
			STR 	R0,[R1]
	
			LDR 	R1,=GPIO_PORTA_CR			
			MOV 	R0,#0xFF			
			STR 	R0,[R1]
			
			LDR 	R1,=GPIO_PORTA_DIR 
			LDR 	R0,[R1]
			ORR 	R0,R0,#0xEF ;A_0123567 output
			STR 	R0,[R1]
			
			LDR 	R1,=GPIO_PORTA_AFSEL 
			MOV 	R0,#0x3C ;A_2345_Afsel_select
			STR 	R0,[R1]
			
			LDR 	R1,=GPIO_PORTA_DEN 
			MOV 	R0,#0xFF ;A_01234567_digital_enable
			STR 	R0,[R1]
			
			LDR 	R1,=GPIO_PORTA_PCTL 
			MOV32 	R0,#0x00222200 ;A_2345_SSI0_Select
			STR 	R0,[R1]	

SSI_Config
			LDR	R1,=SYSCTL_RCGCSSI 
			LDR	R0,[R1]
			ORR	R0,R0,#0x01 ;SSI0 clock enable
			STR	R0,[R1] 
			LDR	R1,=SYSCTL_PRSSI 
flag_chk	LDR	R0,[R1]
			AND R0,R0,#0x01 ; ready flag check
			CMP R0,#0x01
			BNE	flag_chk
			LDR R1,=SSI0_CR1 
			LDR R0,[R1]
			BIC R0,R0,#0x02 ;disable
			STR R0,[R1]
			LDR R1,=SSI0_CR0 
			LDR R0,[R1]
			MOV	R2,#0xFF3F
			BIC R0,R0,R2
			MOV	R2,#0x01C7
			ORR R0,R0,R2
			STR R0,[R1]
			LDR R1,=SSI0_CPSR 
			LDR R0,[R1]
			MOV R0,#250
			STR R0,[R1]
			LDR R1,=SSI0_CR1 
			LDR R0,[R1]
			ORR R0,R0,#0x02 ;enable
			STR R0,[R1]

Screen_write_init
			LDR	R1,=GPIO_PORTA_DATA 
			LDR	R0,[R1]
			BIC	R0,R0,#0x80
			STR	R0,[R1]
			BL	DELAY_100
			ORR R0,R0,#0x80
			STR R0,[R1]
			BIC R0,R0,#0x40
			STR R0,[R1]
			LDR R1,=SSI0_DR 
			MOV R0,#0x21
			STR R0,[R1]
			MOV R0,#0xB5
			STR R0,[R1]
			MOV R0,#0x06
			STR R0,[R1]
			MOV R0,#0x13
			STR R0,[R1]
			MOV R0,#0x20 ;H=0
			STR R0,[R1]
			MOV R0,#0x0C
			STR R0,[R1]
			BL	DELAY_100
			MOV R0,#0x40
			STR R0,[R1]
			MOV R0,#0x80
			STR R0,[R1]
			BL	DELAY_100
			LDR R1,=GPIO_PORTA_DATA 
			LDR R0,[R1]
			ORR R0,R0,#0x40
			STR R0,[R1]
			
			POP{LR,R0,R1}
			BX LR
			ENDP
			ALIGN
			END