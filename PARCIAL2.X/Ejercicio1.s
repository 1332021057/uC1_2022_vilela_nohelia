;--------------------------------------------------------------
; @file      Ejercicio1.s
; @brief     PARCIAL 2
; @date      30/01/23
; @author    Nohelia Lucía Vilela García
; @frequency 4 Mhz
; @version   MPLAB X IDE v6.00
;------------------------------------------------------------------
    
;Desarrolle un programa para dividir la frecuencia de una señal cuadrada utilizando
;las interrupciones INT0 e INT1, siguiendo las conexiones que se muestran en la Figura 1.
    
;La señal cuadrada ingresa por el pin RB0 y por el pin RC0 se genera una señal cuadrada
;divida por un valor N que por defecto tiene el valor de 10 y disminuye su valor cada vez
;que se presiona el botón de la placa. Si el valor de N es igual a cero,
;automáticamente se vuelve a cargar con el valor de 10.
    
;En el programa principal, realice un toggle del led de la placa cada 500 ms.
;RB0: Interrupción de baja prioridad (INT0)
;RA3: Interrupción de alta prioridad (INT1)
    

PROCESSOR 18F57Q84
#include "Bit_Config.inc"   /*config statements should precede project file includes.*/
#include <xc.inc>
;#include "Retardos_1.inc"    
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main

PSECT ISRVectLowPriority,class=CODE,reloc=2
;modificar para INT0    
ISRVectLowPriority:
    BTFSS   PIR1,0,0	; ¿Se ha producido la INT0?
    GOTO    Exit0
Toggle_Led:
    BCF	    PIR1,0,0	; limpiamos el flag de INT0
    BTG	    LATF,3,0	; toggle Led
    CALL    Delay_500ms,1
Exit0:
    RETFIE

PSECT ISRVectHighPriority,class=CODE,reloc=2    ;cambiar por el ISRTimer
;modificar para INT1    
ISRVectHighPriority:
    BTFSS   PIR6,0,0	; ¿Se ha producido la INT1?
    GOTO    Exit1
Leds_Off:   ;esto no, mas o menos aquí debería ir el config button de la placa RA3
    BCF	    PIR6,0,0	; limpiamos el flag de INT0
    BTG	    LATF,3,0	; toggle Led
Exit1:
    RETFIE

PSECT udata_acs
contador1:  DS 1	    
contador2:  DS 1
offset:	    DS 1
counter:    DS 1
    
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_INT0_INT1,1
    GOTO    Reload
Loop:
    BANKSEL PCLATU
    MOVLW   low highword(Table)
    MOVWF   PCLATU,1
    MOVLW   high(Table)
    MOVWF   PCLATH,1
    RLNCF   offset,0,0
    CALL    Table
    MOVWF   LATC,0
    CALL    Delay_250ms,1
    DECFSZ  counter,1,0
    GOTO    Next_Seq
    GOTO    Reload
Next_Seq:                 ; aquí el offset debe decrementarse
    INCF    offset,1,0
    GOTO    Loop
Reload:                   ; aquí el valor de 0x05 cambiar a 11 en hexadecimal pk va del 0 al 10       
    MOVLW   0x05	
    MOVWF   counter,0	; carga del contador con el numero de offsets
    MOVLW   0x00	
    MOVWF   offset,0	; definimos el valor del offset inicial
    GOTO    Loop
    
Config_OSC:
    ;Configuracion del Oscilador Interno a una frecuencia de 4MHz
    BANKSEL OSCCON1
    MOVLW   0x60    ;seleccionamos el bloque del osc interno(HFINTOSC) con DIV=1
    MOVWF   OSCCON1,1 
    MOVLW   0x02    ;seleccionamos una frecuencia de Clock = 4MHz
    MOVWF   OSCFRQ,1
    RETURN
    
Config_Port:	
;hay que configurar:
;Puerto de entrada de señal CLK externa
;Puerto de salida de señal CLK dividida
;Configurar puerto para botón externo que disminuye el valor del divisor   
    ;Config Led
    BANKSEL PORTF
    CLRF    PORTF,1	
    BSF	    LATF,3,1
    BSF	    LATF,2,1
    CLRF    ANSELF,1	
    BCF	    TRISF,3,1
    BCF	    TRISF,2,1
    
    ;Config User Button
    BANKSEL PORTA
    CLRF    PORTA,1	
    CLRF    ANSELA,1	
    BSF	    TRISA,3,1	
    BSF	    WPUA,3,1
    
    ;Config Ext Button
    BANKSEL PORTB
    CLRF    PORTB,1	
    CLRF    ANSELB,1	
    BSF	    TRISB,1,1	
    BSF	    WPUB,1,1
    
    ;Config PORTC
    BANKSEL PORTC
    SETF    PORTC,1	
    SETF    LATC,1	
    CLRF    ANSELC,1	
    CLRF    TRISC,1
    RETURN
    
Config_PPS:
;se queda para configurar las INT
;RB0: Interrupción de baja prioridad (INT0)
;RA3: Interrupción de alta prioridad (INT1)   
    
    ;Config INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	; INT0 --> RA3
    
    ;Config INT1
    BANKSEL INT1PPS
    MOVLW   0x09
    MOVWF   INT1PPS,1	; INT1 --> RB1
    
    RETURN
    
;   Secuencia para configurar interrupcion:
;    1. Definir prioridades
;    2. Configurar interrupcion
;    3. Limpiar el flag
;    4. Habilitar la interrupcion
;    5. Habilitar las interrupciones globales
    
Config_INT0_INT1:
;se queda, modificar para INT0 de low priority y INT1 de high priority    
    ;Configuracion de prioridades
    BSF	INTCON0,5,0 ; INTCON0<IPEN> = 1 -- Habilitamos las prioridades
    BANKSEL IPR1
    BSF	IPR1,0,1    ; IPR1<INT0IP> = 1 -- INT0 de alta prioridad
    BCF	IPR6,0,1    ; IPR6<INT1IP> = 0 -- INT1 de baja prioridad
    
    ;Config INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0
    
    ;Config INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext1
    
    ;Habilitacion de interrupciones
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF	INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN

Table:    ;esta tabla es para incrementar el valor del offset, pero yo lo quiero decrementar
    ;es decir de mayor a menor por lo tanto se cambia PCL por PCH
    ADDWF   PCL,1,0
    RETLW   11111111B	; offset: 0      dice que es 255 en decimal, debe ser offset 10
    RETLW   11111110B	; offset: 1      dice que es 254 en decimal
    RETLW   11111101B	; offset: 2
    RETLW   11111011B	; offset: 3
    RETLW   11110111B	; offset: 4
    
Delay_250ms:		    ; 2Tcy -- Call
;cambiar por delay de 500ms    
    MOVLW   250		    ; 1Tcy -- k2
    MOVWF   contador2,0	    ; 1Tcy
; T = (6 + 4k)us	    1Tcy = 1us
Ext_Loop:		    
    MOVLW   249		    ; 1Tcy -- k1
    MOVWF   contador1,0	    ; 1Tcy
Int_Loop:
    NOP			    ; k1*Tcy
    DECFSZ  contador1,1,0   ; (k1-1)+ 3Tcy
    GOTO    Int_Loop	    ; (k1-1)*2Tcy
    DECFSZ  contador2,1,0
    GOTO    Ext_Loop
    RETURN		    ; 2Tcy
    
End resetVect   
   
    



