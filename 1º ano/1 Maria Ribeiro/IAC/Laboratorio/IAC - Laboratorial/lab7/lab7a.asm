; *********************************************************************************
; *
; * IST-UL
; *
; *********************************************************************************
; *********************************************************************************
; *
; * Modulo:    lab7a.asm
; * Descrição: Este é um programa simples de teste das interrupções.
; *     Há apenas uma rotina de interrupção. Esta incrementa um contador
; *     e mostra o seu valor no display hex de cada vez que o botão (servido
; *     por interrupção) for premido.
; *
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
OUTPUT   EQU   8000H        ; endereço do porto de saída (display hex).

; *********************************************************************************
; * Dados
; *********************************************************************************
PLACE       2000H

pilha:      TABLE 100H      ; espaço reservado para a pilha 
fim_pilha:				

; Tabela de vectores de interrupção
tab:        WORD    rot0

; espaço para declarar quaisquer variáveis que o programa possa usar ...
; ...

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE    0

inicio:		
    MOV BTE, tab           ; incializa BTE
    MOV SP, fim_pilha      ; inicializa SP
    MOV R0, 0              ; inicializa contador
    EI0                    ; permite interrupções 0
    EI 
fim:
    JMP fim                ; fica à espera

; *********************************************************************************
;* ROTINAS
; *********************************************************************************

;* -- Rotina de Serviço de Interrupção 0 -------------------------------------------
;* 
;* Descrição: Trata interrupções do botão de pressão. 
;*
rot0:
    PUSH R1                ; guarda registo de trabalho	
    MOV  R1, OUTPUT        ; endereço do porto do display
    ADD  R0, 1             ; incrementa contador
    MOVB [R1], R0          ; atualiza display
    POP  R1                ; restaura registo de trabalho
    RFE                    ; regressa
