;
; Actividad 1.asm
;
; Created: 14/02/2024 12:42:03 a. m.
; Author : Uriel Huerta, Axel Vallejo, Giovani Orozco
;Programa para generar 4 diferentes señales con frecuencias distintas
;dependiendo de los estados de entrada

.cseg	
.org 0x00
.def temp = r16


;Main program
	;Stack init
	lds temp,high(RAMEND) ;High byte
	sts SPH,temp
	lds temp,low(RAMEND) ;Low byte
	sts SPL,temp


;Port configuration
	lds temp,0b00100000 ; PB5->output // input->PB4 y PB3 (por posicion de 0's y 1's) 
	sts DDRB,temp 
	sbi PORTB,PB4 ;activa la resistencia de pull-up en puerto 4
	sbi PORTB,PB3 ;activa la resistencia de pull-up en puerto 3 
;PORTB coloca el puerto en modo escritura
;En estos momentos ambos puertos estarían con un 1 lógico
	
;Inicializar el TIMER1 de 16 bits Pagina 123 datasheet
	lds r17,0xFF ; Byte más alto de 0xFFFF
	lds r16,0xFF ; Byte más bajo de 0xFFFF
	sts TCNT1H,R17 
	sts TCNT1L,R16

;Configurar el modo de operación del Timer1
	lds r17,0x00 ; Modo Normal
	sts TCCR1B,R17

;Configurar el prescaler
	lds r17,0x05 ; Prescaler de 1024
	sts TCCR1B,R17

;Habilitar la interrupción del Timer1
	lds r17,0x01 ; Habilitar interrupción TOIE1
	sts TIMSK1,R17

;Subrutinas
entrada_00:
	in temp,PB3
	andi temp,0b00000000 ;verifica si está en ceros
	brne freq1 ;si está en 00 salta a la frecuencia 1 
	cbi PORTB,PB3

entrada_11:
	in temp,PB3
	andi temp,0b00001100 ;verifica si está en ceros
	brne freq4 ;si está en 4 salta a la frecuencia 4 
	cbi PORTB,PB3

freq1:
	sbi PORTB,PB3
	rjmp entrada_00

freq4:
	sbi PORTB,PB3
	rjmp entrada_11

