; *********************************************************************************
; * IST-UL
; * Modulo: 	lab4-memoria.asm
; * Descrição: Este programa define uma rotina para escrever um pixel no ecrã,
; *            usando acesso à memória do ecrã, e ilustra a sua utlização
; *
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************

MEMORIA_ECRA	 EQU	8000H	 ; endereço base da memória do ecrã

LINHA           EQU 2          ; linha
COLUNA          EQU 1          ; coluna

COR_PIXEL       EQU 0FF00H     ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)

; *********************************************************************************
; * Dados 
; *********************************************************************************
PLACE       1000H
pilha:      TABLE 100H      ; espaço reservado para a pilha 
                            ; (200H bytes, pois são 100H words)
SP_inicial:                 ; este é o endereço (1200H) com que o SP deve ser 
                            ; inicializado. O 1.º end. de retorno será 
                            ; armazenado em 11FEH (1200H-2)
							
; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                   ; o código tem de começar em 0000H
inicio:
    MOV  SP, SP_inicial     ; inicializa SP para a palavra a seguir
                            ; à última da pilha
                            
    MOV  R1, LINHA          ; define linha, coluna e cor do pixel a escrever
    MOV  R2, COLUNA
    MOV  R3, COR_PIXEL
    CALL escreve_pixel      ; escreve o pixel no ecrã
fim:
    JMP  fim
 

; **********************************************************************
; ESCREVE_PIXEL - Rotina que escreve a cor de um pixel na linha e coluna indicadas.
;                 O endereço do pixel é dado por MEMORIA_ECRA + 2 * (linha * 64 + coluna)
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
	PUSH	R0
	PUSH	R1
	MOV	R0, MEMORIA_ECRA		; endereço de base da memória do ecrã
	SHL	R1, 6				; linha * 64
     ADD  R1, R2                   ; linha * 64 + coluna
     SHL  R1, 1                    ; * 2, para ter o endereço da palavra
	ADD	R0, R1				; MEMORIA_ECRA + 2 * (linha * 64 + coluna)
	MOV	[R0], R3				; escreve cor no pixel
	POP	R1
	POP	R0
	RET
	
	
