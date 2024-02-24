;
; Actividad 1.asm
;
; Created: 14/02/2024 12:42:03 a. m.
; Author : Uriel Huerta, Axel Vallejo, Giovanny Orozco
;Programa para generar 4 diferentes señales con frecuencias distintas
;dependiendo de los estados de entrada

.cseg	
.org 0x00
.def temp = r16
.def repeat=r17
.def counter=r18

;Main program
	;Stack init
	lds temp,high(RAMEND) ;High byte
	sts SPH,temp
	lds temp,low(RAMEND) ;Low byte
	sts SPL,temp


;Port configuration
	lds temp,0b00100000 ; PB5->output // input->PB4 y PB3 (por posicion de 0's y 1's) 
	sts DDRB,temp 
	
;Inicializar el TIMER1 de 16 bits Pagina 123 datasheet
	lds repeat,0xFF ; Byte más alto de 0xFFFF
	lds temp,0xFF ; Byte más bajo de 0xFFFF
	sts TCNT1H,repeat
	sts TCNT1L,temp

;Configurar el modo de operación del Timer1
	lds repeat,0x00 ; Modo Normal
	sts TCCR1B,repeat

;Configurar el prescaler
	lds repeat,0x05 ; Prescaler de 1024
	sts TCCR1B,repeat

;Habilitar la interrupción del Timer1
	lds repeat,0x01 ; Habilitar interrupción TOIE1
	sts TIMSK1,repeat

;Subrutinas

  in temp,PINB
	cpi temp,0b00000000
	breq entrada_00

	in temp,PINB
	cpi temp,0b00000001
	breq entrada_01

	in temp,PINB
	cpi temp,0b00000010
	breq entrada_10

	in temp,PINB
	cpi temp,0b00000011
	breq entrada_11

	rjmp start


entrada_00:
	sbi PORTB,PB5
	rcall delay1
	cbi PORTB,PB5
	rcall delay1
	rjmp start

delay1: 
	ldi temp,0
	ldi repeat,0
	sts	TCNT1H,repeat
	sts TCNT1L,temp

ciclo1:
	lds temp,TCNT1L
	cpi temp,0x12
	brne ciclo1
	lds repeat,TCNT1H
	cpi repeat,0x7A
	brne ciclo1
	ret 

entrada_01:
  sbi PORTB,PB5
	rcall delay2
	cbi PORTB,PB5
	rcall delay2
	rjmp start

delay2: 
	ldi temp,0
	ldi repeat,0
	sts	TCNT1H,repeat
	sts TCNT1L,temp

ciclo2:
	lds temp,TCNT1L
	cpi temp,0xD4
	brne ciclo2
	lds repeat,TCNT1H
	cpi repeat,0x30
	brne ciclo2
	ret 


entrada_10:
	sbi PORTB,PB5
	rcall delay3
	cbi PORTB,PB5
	rcall delay3
	rjmp start

delay3: 
	ldi temp,0
	ldi repeat,0
	sts	TCNT1H,repeat
	sts TCNT1L,temp

ciclo3:
	lds temp,TCNT1L
	cpi temp,0x70
	brne ciclo3
	lds repeat,TCNT1H
	cpi repeat,0x02
	brne ciclo3
	ret

entrada_11:
	sbi PORTB,PB5
	rcall delay4
	cbi PORTB,PB5
	rcall delay4
	rjmp start

delay4: 
	ldi temp,0
	ldi repeat,0
	sts	TCNT1H,repeat
	sts TCNT1L,temp

ciclo4:
	lds temp,TCNT1L
	cpi temp,0x03
	brne ciclo4
	lds repeat,TCNT1H
	cpi repeat,0x00
	brne ciclo4
	ret 


