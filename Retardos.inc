PSECT udata_acs
contador1: DS 1     ; reserva 1 byte en access ram
contador2: DS 1

    
PSECT code
; T= (6 + 4k)us           1Tcy = 1us
Delay_10us:             ; 2Tcy -- Call
    MOVLW  1            ; 1 Tcy
    MOVWF  contador1,0  ; 1 Tcy
Delay_Loop10us:               
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Delay_Loop10us     ; (k-1)*2Tcy
    RETURN                ; 2Tcy
    
    
Delay_25us:             ; 2Tcy -- Call
    MOVLW  5            ; 1 Tcy
    MOVWF  contador1,0  ; 1 Tcy
Delay_Loop25us:               
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Delay_Loop25us     ; (k-1)*2Tcy
    RETURN                ; 2Tcy
  
    
Delay_50us:             ; 2Tcy -- Call
    MOVLW  11           ; 1 Tcy
    MOVWF  contador1,0  ; 1 Tcy
Delay_Loop50us:               
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Delay_Loop50us ; (k-1)*2Tcy
    RETURN                ; 2Tcy
    
    
Delay_100us:             ; 2Tcy -- Call
    MOVLW  24            ; 1 Tcy
    MOVWF  contador1,0   ; 1 Tcy
Delay_Loop100us:               
    NOP                     ; k*Tcy
    DECFSZ contador1,1,0    ; (k-1)+ 3Tcy
    GOTO   Delay_Loop100us  ; (k-1)*2Tcy
    RETURN                  ; 2Tcy
    
    
Delay_200us:             ; 2Tcy -- Call
    MOVLW  49             ; 1 Tcy
    MOVWF  contador1,0   ; 1 Tcy
Delay_Loop200us:               
    NOP                     ; k*Tcy
    DECFSZ contador1,1,0    ; (k-1)+ 3Tcy
    GOTO   Delay_Loop200us  ; (k-1)*2Tcy
    RETURN                  ; 2Tcy
    
    
Delay_250us:              ; 2Tcy -- Call
    MOVLW  61             ; 1 Tcy
    MOVWF  contador1,0    ; 1 Tcy
Delay_Loop250us:               
    NOP                     ; k*Tcy
    DECFSZ contador1,1,0    ; (k-1)+ 3Tcy
    GOTO   Delay_Loop250us  ; (k-1)*2Tcy
    RETURN                  ; 2Tcy

    
Delay_500us:              ; 2Tcy -- Call
    MOVLW  124             ; 1 Tcy
    MOVWF  contador1,0    ; 1 Tcy
Delay_Loop500us:               
    NOP                     ; k*Tcy
    DECFSZ contador1,1,0    ; (k-1)+ 3Tcy
    GOTO   Delay_Loop500us  ; (k-1)*2Tcy
    RETURN                  ; 2Tcy
    
Delay_1ms:               ; 2Tcy -- Call
    MOVLW  1             ; 1Tcy 
    MOVWF  contador2,0   ; 1 Tcy
; T= (6 + 4k)us           1Tcy = 1us
Ext_Loop1:               
    MOVLW  249           ; 1Tcy 
    MOVWF  contador1,0   ; 1Tcy
Int_Loop1:
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Int_Loop1      ; (k-1)*2Tcy
    DECFSZ contador2,1,0
    GOTO   Ext_Loop1
    RETURN                ; 2Tcy
    
Delay_5ms:               ; 2Tcy -- Call
    MOVLW  5             ; 1Tcy 
    MOVWF  contador2,0   ; 1 Tcy
; T= (6 + 4k)us           1Tcy = 1us
Ext_Loop5ms:               
    MOVLW  249           ; 1Tcy 
    MOVWF  contador1,0   ; 1Tcy
Int_Loop5ms:
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Int_Loop       ; (k-1)*2Tcy
    DECFSZ contador2,1,0
    GOTO   Ext_Loop
    RETURN                ; 2Tcy

    
Delay_10ms:               ; 2Tcy -- Call
    MOVLW  10             ; 1Tcy 
    MOVWF  contador2,0    ; 1 Tcy
; T= (6 + 4k)us           1Tcy = 1us
Ext_Loop10ms:               
    MOVLW  249           ; 1Tcy 
    MOVWF  contador1,0   ; 1Tcy
Int_Loop10ms:
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Int_Loop       ; (k-1)*2Tcy
    DECFSZ contador2,1,0
    GOTO   Ext_Loop
    RETURN                ; 2Tcy
    
    
Delay_25ms:               ; 2Tcy -- Call
    MOVLW  25             ; 1Tcy 
    MOVWF  contador2,0    ; 1 Tcy
; T= (6 + 4k)us           1Tcy = 1us
Ext_Loop25ms:               
    MOVLW  249           ; 1Tcy
    MOVWF  contador1,0   ; 1Tcy
Int_Loop25ms:
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Int_Loop       ; (k-1)*2Tcy
    DECFSZ contador2,1,0
    GOTO   Ext_Loop
    RETURN                ; 2Tcy
    
    
Delay_50ms:               ; 2Tcy -- Call
    MOVLW  50             ; 1Tcy 
    MOVWF  contador2,0    ; 1 Tcy
; T= (6 + 4k)us           1Tcy = 1us
Ext_Loop50ms:               
    MOVLW  249           ; 1Tcy 
    MOVWF  contador1,0   ; 1Tcy
Int_Loop50ms:
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Int_Loop       ; (k-1)*2Tcy
    DECFSZ contador2,1,0
    GOTO   Ext_Loop
    RETURN                ; 2Tcy
   
    
Delay_100ms:            ; 2Tcy -- Call
    MOVLW  100          ; 1Tcy 
    MOVWF  contador2,0  ; 1 Tcy
; T= (6 + 4k)us           1Tcy = 1us
Ext_Loop100ms:               
    MOVLW  249           ; 1Tcy 
    MOVWF  contador1,0   ; 1Tcy
Int_Loop100ms:
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Int_Loop       ; (k-1)*2Tcy
    DECFSZ contador2,1,0
    GOTO   Ext_Loop
    RETURN                ; 2Tcy
    

Delay_200ms:            ; 2Tcy -- Call
    MOVLW  200          ; 1Tcy 
    MOVWF  contador2,0  ; 1 Tcy
; T= (6 + 4k)us           1Tcy = 1us
Ext_Loop200ms:               
    MOVLW  249           ; 1Tcy
    MOVWF  contador1,0   ; 1Tcy
Int_Loop200ms:
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Int_Loop       ; (k-1)*2Tcy
    DECFSZ contador2,1,0
    GOTO   Ext_Loop
    RETURN                ; 2Tcy
    
    
Delay_250ms:            ; 2Tcy -- Call
    MOVLW  250          ; 1Tcy 
    MOVWF  contador2,0  ; 1 Tcy
; T= (6 + 4k)us           1Tcy = 1us
Ext_Loop:               
    MOVLW  249           ; 1Tcy 
    MOVWF  contador1,0   ; 1Tcy
Int_Loop:
    NOP                   ; k*Tcy
    DECFSZ contador1,1,0  ; (k-1)+ 3Tcy
    GOTO   Int_Loop       ; (k-1)*2Tcy
    DECFSZ contador2,1,0
    GOTO   Ext_Loop
    RETURN                ; 2Tcy


