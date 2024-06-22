; *********************************************************************************
; *
; * IST-UL
; *
; *********************************************************************************
; *********************************************************************************
; *
; * Modulo:    lab7a.asm
; * Descri��o: Este � um programa simples de teste das interrup��es.
; *     H� apenas uma rotina de interrup��o. Esta incrementa um contador
; *     e mostra o seu valor no display hex de cada vez que o bot�o (servido
; *     por interrup��o) for premido.
; *
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
OUTPUT   EQU   8000H        ; endere�o do porto de sa�da (display hex).

; *********************************************************************************
; * Dados
; *********************************************************************************
PLACE       2000H

pilha:      TABLE 100H      ; espa�o reservado para a pilha 
fim_pilha:				

; Tabela de vectores de interrup��o
tab:        WORD    rot0

; espa�o para declarar quaisquer vari�veis que o programa possa usar ...
; ...

; *********************************************************************************
; * C�digo
; *********************************************************************************
PLACE    0

inicio:		
    MOV BTE, tab           ; incializa BTE
    MOV SP, fim_pilha      ; inicializa SP
    MOV R0, 0              ; inicializa contador
    EI0                    ; permite interrup��es 0
    EI 
fim:
    JMP fim                ; fica � espera

; *********************************************************************************
;* ROTINAS
; *********************************************************************************

;* -- Rotina de Servi�o de Interrup��o 0 -------------------------------------------
;* 
;* Descri��o: Trata interrup��es do bot�o de press�o. 
;*
rot0:
    PUSH R1                ; guarda registo de trabalho	
    MOV  R1, OUTPUT        ; endere�o do porto do display
    ADD  R0, 1             ; incrementa contador
    MOVB [R1], R0          ; atualiza display
    POP  R1                ; restaura registo de trabalho
    RFE                    ; regressa
