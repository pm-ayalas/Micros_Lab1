;
; Encender LED con Arduino Nano
; Micros_Lab1.asm
;

// ENCABEZADO
.include	"M328PDEF.inc"    
.cseg                         // código (no datos)
.org		0x0000            

// Configurar Pila
LDI			R16, LOW(RAMEND)  
OUT			SPL, R16          // pila baja
LDI			R16, HIGH(RAMEND) 
OUT			SPH, R16          // pila alta

// Configurar el microcontrolador
SETUP: 
	// Configuración Pines Entrada,Salida (DDRx, PORTx, PINx)

	// PORTC como entrada || Botones - Pull-Up habilitado
	LDI			R16, 0x00		// entrada
	OUT			DDRC, R16		
	LDI			R16, 0xFF		// Activar Pull-Up 
	OUT			PORTC, R16		

	// PORTB como salida || LEDS Resultado
	LDI			R16, 0x1F		// salida
	OUT			DDRB, R16		
	LDI			R16, 0x00		// iniciar con leds apagados
	OUT			PORTB, R16	
	
	// PORTD como salida || LEDS Contadores
	LDI			R16, 0xFF		// salida
	OUT			DDRD, R16		
	LDI			R16, 0x00		// iniciar con leds apagados
	OUT			PORTD, R16	

MAIN_LOOP:
	IN			R16, PINC		// lectura de btns en PORTC
	CALL		DELAY	
	IN			R16, PINC

	SBRS		R16, 0			// ¿Botón C0 presionado?
	CALL		SUMA			

	SBRS		R16, 1			// ¿Botón C1 presionado?
	CALL		ENCENDER_LED1	
	SBRS		R16, 2			// ¿Botón C2 presionado?
	CALL		APAGAR_LED1		

	SBRS		R16, 3			// ¿Botón C3 presionado?
	CALL		ENCENDER_LED2	
	SBRS		R16, 4			// ¿Botón C4 presionado?
	CALL		APAGAR_LED2		

	RJMP		MAIN_LOOP		

// Función para encender leds1
ENCENDER_LED1:
	IN			R16, PIND		// leer leds

	ANDI		R16, 0x0F		// guardar los 4 bits menos significativos
	ANDI		R17, 0xF0		// guardar los 4 bits mas significativos

	LDI			R18, 0b1111		// referencia con todos los leds encendidos
	CP			R16, R18		// comparar. verificar si todos los leds están encendidos
	BREQ		SALIR			// no hacer nada
	INC			R16				// incrementar valor en R16

	LSL			R16
	LSL			R16
	LSL			R16
	LSL			R16
	OR			R16, R17		// concatenar bits

	OUT			PORTD, R16		// enviar nuevo valor de R16
	RET                        

// Función para apagar leds2
APAGAR_LED1:
	IN			R16, PIND		// leer leds
	ANDI		R16, 0x0F		// guardar los 4 bits menos significativos
	LDI			R18, 0b0000		// referencia con todos los leds apagados
	CP			R16, R18		// comparar. verificar si todos los leds están apagados
	BREQ		SALIR			// no hacer nada
	DEC			R17				// decrementar valor en R16
	OUT			PORTD, R17		// enviar nuevo valor de R16
	RET

ENCENDER_LED2:
	LDI			R17, 0b11110000		; Cargar el valor 1 (enciende el LED conectado a PB0)
	OUT			PIND, R17		; Escribir en PORTB para encender el LED
	RET	

APAGAR_LED2:
	RET	

// Función suma de contadores
SUMA:
	RET	

SALIR:
	RET

// Rutina de retardo
DELAY:
	LDI		R18, 0xFF
SUB_DELAY1:
	DEC		R18
	CPI		R18, 0
	BRNE	SUB_DELAY1
	LDI		R18, 0xFF
SUB_DELAY2:
	DEC		R18
	CPI		R18, 0
	BRNE	SUB_DELAY2
	LDI		R18, 0xFF
SUB_DELAY3:
	DEC		R18
	CPI		R18, 0
	BRNE	SUB_DELAY3
	RET                        

