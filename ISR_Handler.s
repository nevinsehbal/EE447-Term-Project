ADC0_RIS EQU 0x40038004 ; Interrupt status
ADC0_PSSI EQU 0x40038028 ; Initiate sample	
ADC0_SSFIFO3 EQU 0x400380A8 ; Channel 3 results
ADC0_ISC	EQU	0x4003800C	
SAMPLE_ADDR EQU 0x20000400
NVIC_ST_CTRL 	EQU 0xE000E010	
	
;Nested Vector Interrupt Controller registers
NVIC_EN0_INT19		EQU 0x00080000 ; Interrupt 19 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E410 ; IRQ 16 to 19 Priority Register
	
; 16/32 Timer Registers
TIMER0_CFG			EQU 0x40030000
TIMER0_TAMR			EQU 0x40030004
TIMER0_CTL			EQU 0x4003000C
TIMER0_IMR			EQU 0x40030018
TIMER0_RIS			EQU 0x4003001C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40030024 ; Timer Interrupt Clear
TIMER0_TAILR		EQU 0x40030028 ; Timer interval
TIMER0_TAPR			EQU 0x40030038
TIMER0_TAR			EQU	0x40030048 ; Timer register
	
;GPIO Registers


GPIO_PORTD_DATA		EQU 0x4000703C ; Access BIT2
GPIO_PORTD_DIR 		EQU 0x40007400 ; Port Direction
GPIO_PORTD_AFSEL	EQU 0x40007420 ; Alt Function enable
GPIO_PORTD_DEN 		EQU 0x4000751C ; Digital Enable

GPIO_PORTF_DATA		EQU 0x40025044 ; Access BIT 0&4
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_PUR		EQU 0x40025510 ; PullDown
GPIO_PORTF_IS		EQU 0x40025404 ; Interrupt
GPIO_PORTF_IBE		EQU 0x40025408 ; Interrupt
GPIO_PORTF_IEV		EQU 0x4002540C ; Interrupt
GPIO_PORTF_IM		EQU 0x40025410 ; Interrupt
GPIO_PORTF_RIS		EQU 0x40025414 ; Interrupt Status
GPIO_PORTF_ICR		EQU 0x4002541C ; Interrupt Clear
GPIO_PORTF_LOCK 	EQU 0x40025520	
GPIO_PORTF_OCR		EQU	0x40025524
;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control

;---------------------------------------------------
FREQ_ADR	EQU	0x20000814
PREV_FREQ_ADR EQU 0x20000818
MAG_ADR		EQU	0x20000810
FREQ_CONST	EQU	12000 ; -10x+12000 = y (x:freq, y:tailr val)
Motor_Ctr	EQU 0x20002400	;bit 0: 0=cw,1=ccw
POT_VAL_ADDR EQU 0x2000081C
;---------------------------------------------------

			AREA ISR_Handlerr, READONLY, CODE
			THUMB
			EXTERN FFT_Calculator
			EXPORT Microphone_ISR ;SysTick_Handler
			EXPORT Motor_ISR ;Timer0A_Handler
			EXPORT Switch_ISR ;Switch PF0,PF4 Handler

;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""		

Microphone_ISR	PROC
			PUSH{LR,R1,R2,R3,R9}
			LDR R1, =ADC0_RIS ; interrupt address
			LDR R2, =ADC0_SSFIFO3 ; result address
			LDR R3,= ADC0_ISC ;interrupt status clear reg

Cont 		LDR R0, [R1]
			ANDS R0, R0, #8
			BEQ Cont ;if flag is 0
			;branch fails if the flag is set so data can be read and flag is cleared
			LDR R9,[R2]
			SUB R9,#0x610 ;substract 1552 == 1.25V
			LSL R9, #16
			STR R9,[R4],#4 ;store the data
			MOV R0, #8
			STR R0, [R3] ; clear flag
			
			SUB R11,#1
			CMP R11,#0
			BEQ FFT
			
			BNE Finish
			
FFT			BL FFT_Calculator	
			LDR R4,=SAMPLE_ADDR
			MOV R11,#256
			NOP
Finish
			POP {LR,R1,R2,R3,R9}
			BX LR
			ENDP
;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""		
Motor_ISR	PROC
			PUSH{R0-R8}
			LDR R1, =TIMER0_TAILR
			LDR R2, =FREQ_ADR
			
			LDR R0,=POT_VAL_ADDR
			LDR R0,[R0]
			LDR R3,=MAG_ADR
			LDR R3,[R3]
			CMP R3,R0;#300
			BHI tailor_change
	
no_change	LDR R2,=PREV_FREQ_ADR
			LDR	R2, [R2]
			MOV R3,#FREQ_CONST
			MOV R5,#0x0A			
			MUL R2,R5 ;freq*10
			SUB R2,R3,R2 ;r2 = 12000-10*freq
			STR	R2, [R1]
			B start
			
tailor_change
			LDR R1,=TIMER0_TAILR
			LDR R2,=FREQ_ADR
			LDR R2,[R2]
			LDR	R3,=PREV_FREQ_ADR ;update previous frequency everytime
			STR R2,[R3]
			LDR R2,=FREQ_ADR
			LDR	R2, [R2]
			MOV R3,#FREQ_CONST
			MOV R5,#0x0A
			MUL R2,R5
			SUB R2,R3,R2
			STR	R2, [R1]
			
			; Rotation bit=0 cw, bit=1 ccw
start		LDR R1,=Motor_Ctr
			LDRB R2,[R1]
			AND  R2,#0x01
			CMP R2,#0x01
			BEQ ccw
			BNE is_cw
			
ccw			;write ccw drive here
			LDR R1,=GPIO_PORTD_DATA
			LDR R8,[R1]
			LSR R8,#1
			CMP R8,#0
			MOVEQ R8,#8
			STR R8,[R1] ;write 1000 to D3D2D1D0
			B finish
			
is_cw 		CMP R2,#0x00
			BEQ cw
			B finish

cw			;write cw drive here
			LDR R1,=GPIO_PORTD_DATA
			LDR R8,[R1]
			LSL R8,#1
			CMP R8,#16
			MOVEQ R8,#1
			STR R8,[R1] ;write 0001 to D3D2D1D0
				
finish
			LDR	R1, =TIMER0_ICR
			MOV	R0,#0x01 ;interrupt clear
			STR R0,[R1]
			
			POP {R0-R8}
			BX LR
			ENDP
;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""		
Switch_ISR	PROC
			PUSH{R0-R5}
			;PF4 (SW1) clockwise, PF0 (SW2) counterclockwise
			LDR	R0,=GPIO_PORTF_RIS
			LDR	R1,=GPIO_PORTF_ICR
			LDR	R3,=Motor_Ctr
			LDR	R2, [R0]
			ANDS R10, R2, #0x10	;check if cw
			BEQ	ccw_check
			MOV R4,#0
			STR	R4,[R3]
			LDR	R5, [R1]
			MOV	R5,#0x11	;clear interrupts
			STR	R5, [R1]
ccw_check	ANDS R10, R2, #0x1	;check if ccw
			BEQ	continue
			MOV R4,#1
			STR	R4,[R3]
			LDR	R5, [R1]
			MOV	R5,#0x11	;clear interrupts
			STR	R5, [R1]
continue
			POP {R0-R5}
			BX LR
			ENDP
;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""		

			ALIGN
			END