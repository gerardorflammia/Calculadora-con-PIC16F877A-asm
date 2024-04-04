LIST p=16f877a
#include p16f877a.inc                ; INCLUIR REGISTRO

; 0x36,0x35 SE USAN PARA GUARDAR NUMEROS RESPECTIVAMENTE
; 0x37  SE USA PARA GUARDAR LA CONDICION 
; 0x38, 0x39 SE USA PARA GUARDAR LAS VARIABLES DEL LOOP

;====================================================================
; VARIABLES
;====================================================================
;====================================================================
; RESET E INTERRUPCIONES VECTORS
;====================================================================

      ; Reset Vector
RST   code  0x0 
      goto  Start

;====================================================================
; CODIGO SEGMENTOS
;====================================================================
PGM   code
Start
;----------------------------------------------------------------------------------------------------------------
; CONFIGURACION PUERTOS DE SALIDA Y ENTRADA
	bsf STATUS, RP0 			;	select bank 1 

	;CONFIG TECLADO
	movlw b'11110000' 			
	movwf TRISB 				

	;CONFIG LCD
	movlw b'11111000'
	movwf TRISD

	;SALIDA LCD
	movlw 0x00					
	movwf TRISC					

	bcf STATUS, RP0 			;	select bank 0
;-----------------------------------------------------------------------------------------------------------------

;MAIN-------------------------------------------------------------------------------------------------
begin:						
	call check_keypad		
goto begin				
;-----------------------------------------------------------------------------------------------------

;SCAN DEL TECLADO-----------------------------------------------------------------------------
 check_keypad					;ESTA RUTINA ESCANEA EL TECLADO PARA CUALQUIER TECLA UTILIZADA

		bsf PORTB, 0			;  ESCANEAR LA PRIMERA COLUMNA		
		;========================================================
		btfsc PORTB, 4			;	LA TECLA ON/OFF FUE PRESIONADA? ENTONCES
		call ON
		BTFSC 0X43,0
		return
	
		btfsc PORTB, 5			;	LA TECLA 1 FUE PRESIONADA? ENTONCES
		call  ONE
		
		btfsc PORTB, 6			;	LA TECLA 4 FUE PRESIONADA? ENTONCES
		call FOUR	
		
		btfsc PORTB, 7			;	LA TECLA 7 FUE PRESIONADA? ENTONCES
		call SEVEN
	
		bcf PORTB, 0			;	TERMINAR COLUMNA 1

	
		bsf PORTB, 1			;	SCAN DE LA 2da COLUMNA DE TECLAS
		;=========================================================
		btfsc PORTB, 4			;	LA TECLA 0 FUE PRESIONADA? ENTONCES
		CALL ZERO				
		
		btfsc PORTB, 5			;	LA TECLA 2 FUE PRESIONADA? ENTONCES
		CALL TWO				
	
		btfsc PORTB, 6			;	LA TECLA 5 FUE PRESIONADA? ENTONCES
		CALL FIVE				
	
		btfsc PORTB, 7			;	LA TECLA 8 FUE PRESIONADA? ENTONCES
		CALL EIGHT				
	
		bcf PORTB, 1			;	TERMINAR COLUMNA  2

	
		bsf PORTB, 2			;	SCAN DE LA 3era COLUMNA DE TECLAS
		;=====================================================
		btfsc PORTB, 4			;	LA TECLA = FUE PRESIONADA? ENTONCES
		CALL EQUAL				
		
		btfsc PORTB, 5			;	LA TECLA 3 FUE PRESIONADA? ENTONCES
		CALL THREE				
		
		btfsc PORTB, 6			;	LA TECLA 6 FUE PRESIONADA? ENTONCES
		CALL SIX				
		
		btfsc PORTB, 7			;	LA TECLA 9 FUE PRESIONADA? ENTONCES
		CALL NINE				
	
		bcf PORTB, 2			;	TERMINAR COLUMNA 3


		bsf PORTB, 3			;	SCAN DE LA 4ta COLUMNA DE TECLAS
		;========================================================
		btfsc PORTB, 4			;	LA TECLA + FUE PRESIONADA? ENTONCES
		call PLUS				
	
		btfsc PORTB, 5			;	LA TECLA - FUE PRESIONADA? ENTONCES
		call MINUS				
	
		btfsc PORTB, 6			;	LA TECLA x FUE PRESIONADA? ENTONCES
		call MULT				
	
		btfsc PORTB, 7			;	LA TECLA / FUE PRESIONADA? ENTONCES
		call DIV				
	
		bcf PORTB, 3			;	TERMINAR COLUMNA 4

        call DELAY1
	return						;	VUELTA A LA RUTINA PRINCIPAL
;----------------------------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------------------
;FUNCIONES DE LOS NUMEROS 
ZERO:
;movlw 0x00
call shift
addlw 0x00

;MOVWF FSR
;ADDWF FSR, 0
movwf 0x35
movlw 0x30
call display_digit
return 


ONE:
;movlw 0x01
call shift
addlw 0x01

movwf 0x35
movlw 0x31
call display_digit
return 

TWO:
;movlw 0x02
call shift
addlw 0x02

movwf 0x35
movlw 0x32
call display_digit
return 

THREE:
;movlw 0x03
call shift
addlw 0x03

movwf 0x35
movlw 0x33
call display_digit
return 

FOUR:
;movlw 0x04
call shift
addlw 0x04

movwf 0x35
movlw 0x34
call display_digit
return 

FIVE:
;movlw 0x05
call shift
addlw 0x05

movwf 0x35
movlw 0x35
call display_digit
return 

SIX:
;movlw 0x06
call shift
addlw 0x06

movwf 0x35
movlw 0x36
call display_digit
return 

SEVEN:
;movlw 0x07
call shift
addlw 0x07

movwf 0x35
movlw 0x37
call display_digit
return 

EIGHT:
;movlw 0x08
call shift
addlw 0x08

movwf 0x35
movlw 0x38
call display_digit
return 

NINE:
;movlw 0x09
call shift
addlw 0x09

movwf 0x35
movlw 0x39
call display_digit
return 

shift:
movf 0x35,w
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
return

	;-------------------------------------------------------
	PLUS:
	;GUARDANDO LA PRIMERA OPERACION A  0x36 PARA QUE
	;LA SEGUNDA OPERACION VAYA A  0x35
	movf 0x35,w
	movwf 0x36
	clrf 0x35
	
	;ENVIANDO EL VALOR 00 PARA LA OPERACION SUMA
	;0x37 ES LA VARIABLE QUE GUARDA LAS CONDICIONES
	movlw 0x00
	movwf 0x37
	
	movlw 0x2B
	call display_digit
	return
	;--------------------------------------------------------
	
	;---------------------------------------------------------
	MINUS:
	movf 0x35,w
	movwf 0x36
	clrf 0x35
	
	movlw 0x01
	movwf 0x37
	
	movlw 0x2D
	call display_digit
	return
	;----------------------------------------------------------

	;----------------------------------------------------------
	MULT:
	movf 0x35,w
	movwf 0x36
	clrf 0x35
	
	movlw 0x02
	movwf 0x37
	
	movlw 0x2A
	call display_digit
	return
	;--------------------------------------------------------------

	;--------------------------------------------------------------
	DIV:
	movf 0x35,w
	movwf 0x36
	clrf 0x35
	
	movlw 0x03
	movwf 0x37
	
	movlw 0x2F
	call display_digit
	return
	;------------------------------------------------------------------


EQUAL:
movlw 0x01
movwf 0x43
movlw 0x3D
movf 0x36
call display_digit

;PARTE DE CALCULO-------------------------------------------------------
BTFSS 0X37,1
GOTO TCOND0 ;0X
GOTO TCOND1 ;1X

TCOND0:
BTFSS 0X37,0
GOTO COND00
GOTO COND01

TCOND1:
BTFSS 0X37,0
GOTO COND10
GOTO COND11

;SUMA
COND00:
MOVF 0X36,W
ADDWF 0X35,W
;addlw 0x30 
call display_registor
RETURN

;RESTA
COND01:
SUBSTRACTION:
MOVF 0X35,W
SUBWF 0X36,W
;addlw 0x30  
call display_registor
RETURN

;MULTIPLICACION
COND10:
MOVLW 0X00 
LOOP2:
ADDWF 0X36,W
DECF 0X35,F
BTFSS STATUS,Z
GOTO LOOP2
;addlw 0x30  

;call axb
;movf 0x36, 0
call display_registor
RETURN 

;DIVISION  0x36/0x35
COND11:
MOVF 0X35,W
;LP1:
;SUBWF 0X36,W
;BTFSS STATUS,DC
;GOTO LP1

call del
movf 0x40, 0
;addlw 0x30  
;MOVF 0X00,0
call display_registor
RETURN

del clrf 0x40
	clrf 0x41  
    movlw .0        
    xorwf 0x35,W    
    btfsc STATUS,Z 
    return                
d1  movf 0x36, W
    movwf 0x41
    movf 0x35,W   
	subwf 0x36,F         
    btfss STATUS,C 
    return                
    incf 0x40,F 
    
    goto          d1      
;END CALCULADORA-----------------------------------------------

return


ON:
movlw 0x01
call DISPLAY

clrf 0x35
clrf 0x36
clrf 0x37
clrf 0x43
return
;----------------------------------------------------------------------------------------------------------------

; INICIALIZACION DEL LCD
    
		;If
		;RS=0  INSTRUCCION DEL COMMAND CODE REGISTRADO ES SELECCIONADO PARA PODER ENVIAR EL COMANDO
		;RS=1  REGISTRO DE DATOS ES SELECCIONADO PARA ENVIAR DATOS AL DISPLAY 

		;R\W=0  LECTURA
		;R\W=1  ESCRITURA
		;E- DISPONIBLE

		;EL PIN DISPONIBLE ES UTILIZADO POR EL LCD PARA ASEGURAR INFORMACION EN SUS PINES DE DATOS
		;DATA MODE:  RS=1, R\W=0, E=1\0

display_digit:
		BSF PORTD,0; SENAL DE CONTROL A RS
		BCF PORTD,1; SENAL DE CONTROL A R/W
		BSF PORTD,2; SENAL DE CONTROL A E
		
		;AQUI EL VALOR YA SE GUARDO Y SE ENVIA AL DISPLAY
		call DISPLAY
		;call DISPLAY

		MOVLW 0X38  ;ENCIENDE EL DISPLAY
		CALL DISPLAY
		
		MOVLW 0X0E ; PARAR PARPADEO DEL CURSOR
		CALL DISPLAY

		BSF PORTD,0
		RETURN
		
display_registor:
		
		movwf  0x36
		movlw 0x0A
		movwf 0x35
		call del
		movf 0x41, 0
		
		movwf  0x42
		movf 0x40, 0
		
		movwf  0x36
		movlw 0x0A
		movwf 0x35
		call del
		movf 0x41, 0
		
		ch   equ 0x40
		ch2 equ 0x41
		call checkByte
		movf 0x40, 0
		addlw 0x30
		call display_digit
next: 
		call checkByte2
		movf 0x41, 0
		addlw 0x30
		call display_digit
next2:
		movf 0x42, 0
		addlw 0x30
		call display_digit
		goto begin
		
checkByte:
		BTFSC ch,0
		return
		BTFSC ch,1
		return
		BTFSC ch,2
		return
		BTFSC ch,3
		return
		BTFSC ch,4
		return
		BTFSC ch,5
		return
		BTFSC ch,6
		return
		BTFSC ch,7
		return
		goto next

checkByte2:
		BTFSC ch2,0
		return
		BTFSC ch2,1
		return
		BTFSC ch2,2
		return
		BTFSC ch2,3
		return
		BTFSC ch2,4
		return
		BTFSC ch2,5
		return
		BTFSC ch2,6
		return
		BTFSC ch2,7
		return
		goto next2
		


DISPLAY:   
   		MOVWF PORTC

		BCF PORTD,2
		CALL DELAY1

		BSF PORTD,2
		CALL DELAY1

		BCF PORTD,0
		RETURN

DELAY1:	
		MOVLW	D'13'	 ;PEQUENO DELAY
		MOVWF	0X38
		MOVLW	D'251'
		MOVWF	0X39
		LOOP:	DECFSZ	0X39
				GOTO	LOOP
				DECFSZ	0X38
				GOTO	LOOP
		RETURN
		RETURN	

	return						
Loop  
      goto  Loop

      END

 


