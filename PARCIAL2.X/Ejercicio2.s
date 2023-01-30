;--------------------------------------------------------------
; @file      Ejercicio2.s
; @brief     PARCIAL 2
; @date      30/01/23
; @author    Nohelia Lucía Vilela García
; @frequency 4 Mhz
; @version   MPLAB X IDE v6.00
;------------------------------------------------------------------
    
;   Desarrolle un programa para que al presionar el botón de placa se ejecute la siguiente secuencia:
;1. Se inicia el encendido de leds en el Puerto C con la siguiente secuencia:
;a. RB0 y RB7
;b. RB1 y RB6
;c. RB2 y RB5
;d. RB3 y RB4
;e. Se apagan todos
;Terminada la secuencia anterior se inicia el encendido de leds en el Puerto C con la siguiente secuencia:
;f. RB3 y RB4
;g. RB2 y RB5
;h. RB1 y RB6
;i. RB0 y RB7
;j. Se apagan todos

;La secuencia se detiene cuando se presione otro pulsador externo conectado en
;el pin RB4 o hasta que el número de repeticiones sea 5. 
;El retardo entre el encendido y apagado de los leds será de 250 ms.
;Otro pulsador externo conectado al RF2 reinicia toda la secuencia y apaga los leds.
;Mientras no se active ninguna interrupción, el programa principal, 
;realice un toggle del led de la placa cada 500 ms. RB4 y RF2 son INT de alta prioridad
    
;RA3: Interrupción de baja prioridad (INT0)
;RB4: Interrupción de alta prioridad (INT1)
;RF2: Interrupción de alta prioridad (INT2) 

PROCESSOR 18F57Q84
#include "Bit_Config.inc"    /*config statements should precede project file includes.*/
#include <xc.inc>

PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT udata_acs
contador1: DS 1	   
contador2: DS 1	   
contador3: DS 1	   
offset:	   DS 1    
counter:   DS 1   
counter1:  DS 1    
    
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_INT0_INT1_INT2,1
    GOTO    Toggle_Led_Placa

Toggle_Led_Placa:
   BTG	   LATF,3,0
   CALL    Delay_250ms,1
   CALL    Delay_250ms,1
   BTG	   LATF,3,0
   CALL    Delay_250ms,1
   CALL    Delay_250ms,1
   goto	   Toggle_Led_Placa
 
PSECT ISRVectLowPriority,class=CODE,reloc=2
ISRVectLowPriority:
    BTFSS   PIR1,0,0	;  ¿Se ha producido la INT0?
    GOTO Exit1
Leds_Sec:
    BCF	    PIR1,0,0	; limpiamos el flag de INT0
    GOTO    Sequence
Leds_off:
    CLRF    PORTC,0
    BCF	    PIR1,0,0	; limpiamos el flag de INT0
Exit1:
    BCF	PIR1,0,0
    RETFIE

PSECT ISRVectHighPriority,class=CODE,reloc=2
ISRVectHighPriority:
BUTTON_RES:
    BTFSS   PIR10,0,0	; ¿Se ha producido la INT2?
    GOTO    Stop
    GOTO    RES_SEC
Exit:
    BCF	    PIR10,0,0
    BCF	    PIR6,0,0
    RETFIE
   
    
PSECT CODE  
    
Sequence:   
    MOVLW   0x05	
    MOVWF   counter1,0	; Se carga el valor de 5 al counter1 que determina el número de repeticiones
N_OFFSET:
    MOVLW   0x0A	
    MOVWF   counter,0	; Se carga el valor de 10 al counter que determina el número de offsets
    MOVLW   0x00	
    MOVWF   offset,0	; Se define valor del initial offset = 0
    GOTO    Loop
    
Stop:
    BTFSS PIR6,0,0	; ¿Se ha producido la INT1?
    GOTO Exit
    GOTO Stop2
Stop2:
    BCF PIR6,0,0	;limpiamos el flag INT1
Stop3:
    BTFSC   PIR10,0,0	;¿Se ha producido la INT2?
    GOTO    RES_SEC
    BTFSS   PIR6,0,0	;¿Se ha producido de nuevo la INT1?
    GOTO    Stop3
    GOTO    Exit
    
Table:
    ADDWF   PCL,1,0
    RETLW   10000001B	; offset: 0 -> LEDS 0 y 7 ON
    RETLW   01000010B	; offset: 1 -> LEDS 1 Y 6 ON
    RETLW   00100100B	; offset: 2 -> LEDS 2 Y 5 ON
    RETLW   00011000B	; offset: 3 -> LEDS 3 Y 4 ON
    RETLW   00000000B	; offset: 4 -> LEDS <0,7> OFF
    RETLW   00011000B	; offset: 5 -> LEDS 3 Y 4 ON
    RETLW   00100100B	; offset: 6 -> LEDS 2 Y 5 ON
    RETLW   01000010B	; offset: 7 -> LEDS 1 Y 6 ON
    RETLW   10000001B	; offset: 8 -> LEDS 0 Y 7 ON
    RETLW   00000000B	; offset: 9 -> LEDS <0,7> OFF
    
Loop:
    BSF	    LATF,3,0	    ;Led de la placa, STATUS = OFF
    BANKSEL PCLATU
    MOVLW   low highword(Table) 
    MOVWF   PCLATU,1	    ;Se carga el menor byte del word mas significativo a PCLATU
    MOVLW   high(Table)
    MOVWF   PCLATH,1	    ;Se carga el mayor byte del word menos significativo a PCLATH
    RLNCF   offset,0,0	    ;Rotación a la izquierda en el registro F y se guardas en W
    CALL    Table
    MOVWF   LATC,0	    ;Se mueve W al registro LATC
    CALL    Delay_250ms,1
    DECFSZ  counter,1,0	    
    GOTO    Next_Seq
    DECFSZ  counter1,1,0    
    GOTO    N_OFFSET
    GOTO    Leds_off
    
Next_Seq:
    INCF    offset,1,0	    
    GOTO    Loop
  
Config_OSC:
    ;Configuración del Oscilador Interno a una frecuencia de 4MHz
    BANKSEL OSCCON1
    MOVLW   0x60    ;seleccionamos el bloque del osc interno(HFINTOSC) con DIV=1
    MOVWF   OSCCON1,1 
    MOVLW   0x02    ;seleccionamos una frecuencia de Clock = 4MHz
    MOVWF   OSCFRQ,1
    RETURN
    
Config_Port:	
    
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
    BSF	    TRISB,4,1	
    BSF	    WPUB,4,1
    
    ;Config PORTC
    BANKSEL PORTC
    CLRF    PORTC,1		
    CLRF    ANSELC,1	
    CLRF    TRISC,1
   
    ;Config PORTF
    BANKSEL PORTF
    CLRF    PORTF,0
    CLRF    ANSELF,1	
    BSF	    TRISF,2,1
    BCF	    TRISF,3,1
    BSF	    WPUF,2,1
    RETURN
    
Config_PPS:
    ;Config INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	; INT0 --> RA3
    
    ;Config INT1
    BANKSEL INT1PPS
    MOVLW   0x0C
    MOVWF   INT1PPS,1	; INT1 --> RB4
    
;    Config INT2
    BANKSEL INT2PPS
    MOVLW   0x2A
    MOVWF   INT2PPS,1	; INT2 --> RF2    
    RETURN
 
Config_INT0_INT1_INT2:
    ;Configuracion de prioridades
    BSF	INTCON0,5,0 ; INTCON0<IPEN> = 1 -- Habilitamos las prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1    ; IPR1<INT0IP> = 0 -- INT0 de baja prioridad
    BCF	IPR6,1,1    ; IPR6<INT1IP> = 0 -- INT1 de alta prioridad
    BCF IPR10,1,1   ; IPR6<INT1IP> = 0 -- INT2 de alta prioridad
;    
    ;Config INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0
    
    ;Config INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext1
    
;    ;Config INT2
    BCF	INTCON0,2,0 ; INTCON0<INT1EDG> = 0 -- INT2 por flanco de bajada
    BCF	PIR10,0,0    ; PIR10<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE10<INT0IE> = 1 -- habilitamos la interrupcion ext2
    
    ;Habilitacion de interrupciones
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF	INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN
    
 Delay_250ms:            ; 2Tcy -- Call
    MOVLW  250          ; 1Tcy 
    MOVWF  contador2,0  ; 1 Tcy
; T= (6 + 4k)us           1Tcy = 1us
Ext_Loop250ms:               
    MOVLW  249           ; 1Tcy 
    MOVWF  contador1,0   ; 1Tcy
Int_Loop250ms:
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Int_Loop250ms       ; (k-1)*2Tcy
    DECFSZ contador2,1,0
    GOTO   Ext_Loop250ms
    RETURN                ; 2Tcy

    
RES_SEC:
    BCF	PIR10,0,0
    
END resetVect
    

