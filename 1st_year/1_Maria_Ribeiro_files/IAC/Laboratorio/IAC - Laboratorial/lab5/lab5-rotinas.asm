; *********************************************************************************
; *
; * IST-UL
; *
; *********************************************************************************
; *********************************************************************************
; *
; * Modulo: 	lab5-rotinas.asm
; * Descrição : Este é um programa simples, com rotinas que escrevem nos displays
; *     hexadecimais Low (bits 3-0 de POUT-1) e High (bits 7-4 de POUT-1).
; *     Dado que os dois displays são independentes, mas partilham o mesmo 
; *     periférico, cuja unidade de escrita mínima é um byte, a forma de 
; *     escrever apenas um dos nibbles (grupo de 4 bits) é ter uma cópia do
; *     seu valor (byte com o valor dos dois displays) em memória, 
; *     modificar apenas o nibble que se quer, e depois escrever esse byte. 
; *     É usual designar esta cópia em memória por imagem do periférico.
; *
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
DISPLAYS    EQU 0A000H      ; endereço do porto dos displays hexadecimais
NIBBLE_3_0  EQU 000FH       ; máscara para isolar os 4 bits de menor peso	
NIBBLE_7_4  EQU 00F0H       ; máscara para isolar os bits 7 a 4	

; *********************************************************************************
; * Stack 
; *********************************************************************************
PLACE       1000H
pilha:      TABLE 100H      ; espaço reservado para a pilha 
                            ; (200H bytes, pois são 100H words)
SP_inicial:                 ; este é o endereço (1200H) com que o SP deve ser 
                            ; inicializado. O 1.º end. de retorno será 
                            ; armazenado em 11FEH (1200H-2)
; *********************************************************************************
; * Dados
; *********************************************************************************
imagem_hexa:
    STRING  00H             ; imagem em memória dos displays hexadecimais 
                            ; (inicializada a zero).
							
; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                   ; o código tem de começar em 0000H
inicio:
    MOV  SP, SP_inicial     ; inicializa SP para a palavra a seguir
                            ; à última da pilha

    MOV  R0, 7
    CALL hexa_low           ; escreve 7 no display Low

    MOV  R0, 3
    CALL hexa_high          ; escreve 3 no display high

    MOV  R0, 0AH
    CALL hexa_low           ; escreve A no display low

    MOV  R0, 0FH
    CALL hexa_high          ; escreve F no display high

fim:
    JMP  fim                ; termina programa

; *********************************************************************************
;* ROTINAS
; *********************************************************************************

;* -- hexa_low --------------------------------------------------------------------
;* 
;* Descrição: Rotina que escreve um valor no display hex. Low de POUT-1 (bits 3-0) 
;*
;* Parâmetros:  R0 - número (entre 0 e FH) a escrever no display hexadecimal
;* Retorna:     --  
;* Destrói:     R0, R1, R2, R3

hexa_low:
    MOV  R1, NIBBLE_3_0      ; máscara para isolar os 4 bits de menor peso
    AND  R0, R1              ; limita valor de entrada a valores entre 0 e FH
    MOV  R2, imagem_hexa     ; endereço da imagem dos displays hexadecimais	
    MOVB R3, [R2]            ; lê imagem dos displays na memória
    MOV  R1, NIBBLE_7_4      ; máscara para isolar os bits 7 a 4 (display High)
    AND  R3, R1              ; elimina o valor anterior do display Low
    OR   R3, R0              ; junta o novo valor do display Low (bits 3 a 0)
    MOVB [R2], R3            ; atualiza imagem dos displays na memória
    MOV  R1, DISPLAYS        ; endereço dos displays hexadecimais
    MOVB [R1], R3            ; atualiza displays
    RET                      ; regressa

;* -- hexa_high --------------------------------------------------------------------
;* 
;* Descrição: Rotina que escreve um valor no display hex. High de POUT-1 (bits 7-4)
;*
;* Parâmetros:  R0 - número (entre 0 e FH) a escrever no display hexadecimal
;* Retorna:     --  
;* Destrói:     R0, R1, R2, R3

hexa_high:
    MOV  R1, NIBBLE_3_0      ; máscara para isolar os 4 bits de menor peso
    AND  R0, R1              ; limita valor de entrada a valores entre 0 e FH
    SHL  R0, 4               ; desloca valor para ficar já nos bits 7 a 4
    MOV  R2, imagem_hexa     ; endereço da imagem dos displays hexadecimais	
    MOVB R3, [R2]            ; lê imagem dos displays na memória
    MOV  R1, NIBBLE_3_0      ; máscara para isolar os bits 3 a 0 (display Low)
    AND  R3, R1              ; elimina o valor anterior do display High
    OR   R3, R0	         ; junta o novo valor do display High (bits 7 a 4)
    MOVB [R2], R3            ; atualiza imagem dos displays na memória
    MOV  R1, DISPLAYS        ; endereço dos displays hexadecimais
    MOVB [R1], R3            ; atualiza displays 
    RET                      ; regressa
