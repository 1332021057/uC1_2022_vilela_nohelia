;--------------------------------------------------------------
; @file      Practica1-Corrimiento_Leds.s
; @brief     Práctica 1
; @date      14/01/23
; @author    Nohelia Lucía Vilela García
; @frequency 4 Mhz
; @version   MPLAB X IDE v6.00
;------------------------------------------------------------------
        
    
    
PROCESSOR 18F57Q84
#include "Bit_Config.inc"     /*config statements should precede project file includes.*/
#include <xc.inc>
#include "Retardos.inc"
    
PSECT resetVect, class=CODE, reloc=2
resetVect:
    goto Main
    
PSECT CODE
Main:
    CALL Config_OSC,1
    CALL Config_Port,1
    
Sequence:
    BTFSC PORTA,3,0
    GOTO  Sequence
LED1:
    CALL  Delay_250ms
    CLRF  LATC,1
    CALL  Delay_250ms
    BSF   LATC,0,1
    BTFSC PORTA,3,0
    GOTO  LED2
Stop1:
    MOVLW 00000001B
    MOVWF LATC,1
    ;BTFSC PORTA,3,0
    GOTO  Stop1
LED2:   
    CALL  Delay_250ms
    CALL  Delay_250ms
    BSF   LATC,1,1
    BTFSC PORTA,3,0
    GOTO  LED3
Stop2:
    MOVLW 00000011B
    MOVWF LATC,1
    ;BTFSC PORTA,3,0
    GOTO  Stop2
LED3:
    CALL  Delay_250ms
    BSF   LATC,2,1
    BTFSC PORTA,3,0
    GOTO  LED4
Stop3:
    MOVLW 00000111B
    MOVWF LATC,1
    ;BTFSC PORTA,3,0
    GOTO  Stop3
LED4:
    CALL Delay_250ms
    CALL Delay_250ms
    BSF LATC,3,1
    ;BTFSC PORTA,3,0
    GOTO LED5
Stop4:
    MOVLW 00001111B
    MOVWF LATC,1
    ;BTFSC PORTA,3,0
    GOTO  Stop4   
LED5:
    CALL  Delay_250ms
    BSF   LATC,4,1
    BTFSC PORTA,3,0
    GOTO  LED6
Stop5:
    MOVLW 00001111B
    MOVWF LATC,1
    ;BTFSC PORTA,3,0
    GOTO  Stop5
LED6:
    CALL  Delay_250ms
    CALL  Delay_250ms
    BSF   LATC,5,1
    BTFSC PORTA,3,0
    GOTO  LED7
Stop6:
    MOVLW 00111111B
    MOVWF LATC,1
    ;BTFSC PORTA,3,0
    GOTO  Stop6
LED7:
    CALL  Delay_250ms
    BSF   LATC,6,1
    BTFSC PORTA,3,0
    GOTO  LED8
Stop7:
    MOVLW 01111111B
    MOVWF LATC,1
    ;BTFSC PORTA,3,0
    GOTO  Stop7
LED8:
    CALL  Delay_250ms
    CALL  Delay_250ms
    BSF   LATC,7,1
    BTFSC PORTA,3,0
    GOTO  LED1
Stop8:
    MOVLW 11111111B
    MOVWF LATC,1
    ;BTFSC PORTA,3,0
    GOTO  Stop8
    
Config_OSC:
    BANKSEL  OSCCON1
    MOVLW    0X60h ;SELECIONAMOS EL BLOQUE DEL OSCILADOR INTERNO CON UN DIV:1
    MOVWF    OSCCON1,1
    BANKSEL  OSCFRQ
    MOVLW    0x02h;SELECIONAMOS UNA FRECUENCIA DE 4MHZ
    MOVWF    OSCFRQ,1
    RETURN
Config_Port:              ; PORT - LAT - ANSEL - TRIS   LED:RF3, BUTTON:RA3
; Config Led   
    BANKSEL  PORTC
    CLRF     PORTC,1      ; PORTF=0
    CLRF     LATC,1
    CLRF     ANSELC,1     ; ANSELF <7:0> - PORTF DIGITAL 
    CLRF     TRISC,1      ; RF3-> COMO SALIDA 
; Config Button 
    BANKSEL PORTA 
    SETF    PORTA,1     
    CLRF    ANSELA,1      ;PORTA DIGITAL 
    BSF     TRISA,3,1     ;RA3 COMO ENTRADA
    BSF     WPUA,3,1      ;ACTIVAMOS LA RESISTENCIA PULL-UP DEL PIN RA3
    RETURN

END resetVect


