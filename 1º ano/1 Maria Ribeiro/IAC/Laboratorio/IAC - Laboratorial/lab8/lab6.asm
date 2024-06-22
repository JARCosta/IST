; *********************************************************************************
; *
; * IST-UL
; *
; *********************************************************************************
; *********************************************************************************
; *
; * Modulo:    lab6.asm
; * Descri��o: Este � um programa simples de teste dos processos cooperativos.
; *	    O display de 7 segmentos conta sozinho enquanto se estiver a 
; *	    carregar no bot�o. P1 l� o bot�o e liga uma vari�vel de 
; *	    comunica��o (R7) com o processo P2. P2 monitoriza o sinal dado 
; *	    pelo RTC (Real Time Clock) e incrementa o display se R7 o indicar.
; *	    Os processos s�o programados de forma independente (usando apenas a 
; *	    vari�vel para comunicar).
; *	    O estado do processo P1 � mantido no R5 e o do processo P2 no R6.
; *	    O registo R8 � usado como contador.
; *	    Em vez dos registos R5, R6, R7 e R8 poder-se-iam usar vari�veis 
; *	    de mem�ria (m�todo mais geral).
; *
; * Nota: Utiliza��o de vari�veis de estado para manter o estado de cada 
; *	      processo entre chamadas consecutivas.
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
ON      EQU 1       ; contagem ligada
OFF     EQU 0       ; contagem desligada
INPUT   EQU 8000H   ; endere�o do porto de entrada (bit 0 = RTC; bit 1 = bot�o)
OUTPUT  EQU 8000H   ; endere�o do porto de sa�da. No mesmo endere�o
                    ; que o porto de entrada, mas como estes portos
                    ; usam opera��es diferentes (leitura e escrita) 
                    ; n�o h� conflito

; *********************************************************************************
; * Stack 
; *********************************************************************************
PLACE       1000H
pilha:      TABLE 100H     ; espa�o reservado para a pilha 
fim_pilha:				

; *********************************************************************************
; * C�digo
; *********************************************************************************
PLACE   0

inicio:
    MOV  R9, INPUT         ; endere�o do porto de entrada
    MOV  R10, OUTPUT       ; endere�o do porto de sa�da
    MOV  SP, fim_pilha
    MOV  R5, 1             ; inicializa estado do processo P1
    MOV  R6, 1             ; inicializa estado do processo P2
    MOV  R8, 0             ; inicializa contador
    MOV  R7, OFF           ; inicialmente n�o permite contagem do display

ciclo:
    CALL P1                ; invoca processo P1
    CALL P2                ; invoca processo P2
    JMP  ciclo             ; repete ciclo

; *********************************************************************************
; * ROTINAS
; *********************************************************************************

;* -- Processo P1 -----------------------------------------------------------------
;* 
;* Descri��o: Trata do bot�o 
;*
;* Par�metros:  --
;* Retorna:     R7 - ON, se bot�o premido e OFF, no caso contr�rio.  
;* Destr�i:     R0
;* Notas: N�o h� par�metros de entrada expl�citos. Contudo, existe uma vari�vel global:
;*	R5 - vari�vel que cont�m o estado anterior do bot�o (1 - n�o premido, 2 - bot�o premido)
;*	     e � atualizada de acordo com o estado actual do bot�o.
;*	R7 - tamb�m � uma vari�vel global, embora possa ser visto como resultado desta
;*	rotina. 

P1:
    CMP R5, 1       ; se estado = 1
    JZ  P1_1
    CMP R5, 2       ; se estado = 2
    JZ  P1_2
sai_P1:
    RET	            ; sai do processo. D� oportunidade aos outros
                    ; processos de se executarem

P1_1:
    MOVB R0, [R9]   ; l� porto de entrada
	BIT  R0, 1
	JZ   sai_P1     ; se bot�o n�o carregado, sai do processo
	MOV  R7, ON     ; permite contagem do display
	MOV  R5, 2      ; passa ao estado 2 do P1
	JMP  sai_P1 	
				
P1_2:
    MOVB R0, [R9]   ; l� porto de entrada
    BIT  R0, 1
    JNZ  sai_P1     ; se bot�o continua carregado, sai do processo
    MOV  R7, OFF    ; caso contr�rio, desliga contagem do display
    MOV  R5, 1      ; passa ao estado 1 do P1
    JMP  sai_P1		
				

;* -- Processo P2 -----------------------------------------------------------------
;* 
;* Descri��o: 	trata do RTC e da contagem do display
;*      incrementa R8 e mostra-o no display de cada vez que o RTC
;*      varia de 0->1 & R7=ON
;*
;* Par�metros:  --
;* Retorna:     R8 - actualizado com o valor da contagem.  
;* Destr�i:     R0
;* Notas: N�o h� par�metros de entrada expl�citos. Contudo, existe uma vari�vel global:
;*	R6 - vari�vel que cont�m o estado anterior do RTC (1 - RTC=0, 2 - RTC=1) 
;*	R6 � atualizado de acordo com o estado atual do RTC.
;*	R8 - tamb�m � uma vari�vel global, embora possa ser visto como resultado desta
;*	rotina. 

P2:
    CMP R6, 1       ; se estado = 1
    JZ  P2_1
    CMP R6, 2       ; se estado = 2
    JZ  P2_2
sai_P2:
    RET             ; sai do processo. D� oportunidade aos outros
                    ; processos de se executarem

P2_1:
    MOVB R0, [R9]   ; l� porto de entrada
    BIT  R0, 0
    JZ   sai_P2     ; se RTC=0 espera que passe para 1
    MOV  R6, 2      ; passa ao estado 2 do P2
    CMP  R7, ON     ; v� se a contagem do display est� permitida
    JNZ  sai_P2     ; se n�o estiver, sai sem fazer nada
    ADD  R8, 1      ; incrementa contador
    MOVB [R10], R8  ; atualiza display
    JMP  sai_P2 	
				
P2_2:
    MOVB R0, [R9]   ; l� porto de entrada
    BIT  R0, 0
    JNZ  sai_P2     ; se RTC=1 espera que passe para 0
    MOV  R6, 1      ; passa ao estado 1 do P2
    JMP  sai_P2		
