; *********************************************************************************
; * IST-UL
; * Modulo: 	lab4-comandos.asm
; * Descrição: Este programa define uma rotina para escrever um pixel no ecrã,
; *            usando comandos, e ilustra a sua utlização
; *
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************

DEFINE_LINHA    EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL    EQU 6012H      ; endereço do comando para escrever um pixel

LINHA           EQU 0          ; linha em que o pixel vai ser desenhado
COLUNA          EQU 0          ; coluna em que o pixel vai ser desenhado

RED				EQU 0FF00H
GREEN			EQU 0F0F0H
BLUE			EQU 0F00FH
WHITE			EQU 0FFFFH


PLACE 10000H
colunas:		word 0
				word 63
				word 0
				word 63
PLACE 11000H
linhas:			
				word 0
				word 0
				word 31
				word 31
PLACE 12000H
cores:			
				word RED
				word GREEN
				word BLUE
				word WHITE



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
                            
    MOV  R1, LINHAS          ; define linha, coluna e cor do pixel a escrever
    MOV  R2, COLUNAS
    MOV  R3, RED
	MOV  R7, 2
    CALL escreve_pixel      ; escreve o pixel no ecrã
fim:
    JMP  fim
 

; **********************************************************************
; ESCREVE_PIXEL - Rotina que escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
    PUSH  R0
    
    MOV  R0, DEFINE_LINHA
    MOV  [R0], R1           ; seleciona a linha
    
    MOV  R0, DEFINE_COLUNA
    MOV  [R0], R2           ; seleciona a coluna
    
    MOV  R0, DEFINE_PIXEL
    MOV  [R0], R3           ; altera a cor do pixel na linha e coluna selecionadas
    
	
	ADD LINHAS, 9h
	ADD COLUNAS, 9h
	
	
	MOV  R0, DEFINE_LINHA
    MOV  [R0], R1           ; seleciona a linha
    
    MOV  R0, DEFINE_COLUNA
    MOV  [R0], R2           ; seleciona a coluna
    
    MOV  R0, DEFINE_PIXEL
    MOV  [R0], R3           ; altera a cor do pixel na linha e coluna selecionadas
	
    POP  R0
    RET
