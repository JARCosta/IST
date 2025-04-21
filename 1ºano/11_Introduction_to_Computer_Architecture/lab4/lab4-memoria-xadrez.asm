; *********************************************************************************
; * IST-UL
; * Modulo:    lab4-memoria-xadrez.asm
; * Descrição: Este programa ilustra o funcionamento do ecrã, em que os pixels
; *            são escritos por meio de acesso direto à memória do ecrã.
; *            Desenha um padrão de xadrez no ecrã, preenchendo todos os pixels. 
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
MEMORIA_ECRA	EQU	8000H	; endereço base da memória do ecrã

APAGA_ECRAS    EQU 6002H      ; endereço do comando para apagar todos os pixels de todos os ecrãs
APAGA_AVISO    EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado

N_LINHAS       EQU  32        ; número de linhas do ecrã (altura)
N_COLUNAS      EQU  64        ; número de colunas do ecrã (largura)

COR_PIXEL      EQU 0FF00H     ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)

; *********************************************************************************
; * Dados 
; *********************************************************************************
PLACE       1000H
pilha:      TABLE 100H        ; espaço reservado para a pilha 
                              ; (200H bytes, pois são 100H words)
SP_inicial:                   ; este é o endereço (1200H) com que o SP deve ser 
                              ; inicializado. O 1.º end. de retorno será 
                              ; armazenado em 11FEH (1200H-2)

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                     ; o código tem de começar em 0000H
inicio:
     MOV  SP, SP_inicial      ; inicializa SP para a palavra a seguir
                              ; à última da pilha
     
     MOV  R0, APAGA_ECRAS
     MOV  [R0], R1            ; apaga todos os pixels de todos os ecrãs (o valor de R1 não é relevante)
     
     MOV  R0, APAGA_AVISO
     MOV  [R0], R1            ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
     
     MOV  R3, COR_PIXEL       ; primeiro pixel a vermelho                   
     CALL escreve_ecra        ; escreve todo o ecrã

fim:
     JMP  fim                 ; termina programa

; **********************************************************************
; ESCREVE_ECRA - Escreve todos os pixels do ecra, trocando a cor do pixel
;                sempre que se muda de linha
; Argumentos: ;  R3 - cor do primeiro pixel (0 ou COR_PIXEL)

; **********************************************************************
escreve_ecra:
     PUSH R1                 ; guarda os registos alterados por esta rotina
     PUSH R3
     PUSH R4
     MOV  R1, 0               ; linha corrente
     MOV  R4, N_LINHAS
ee_proxima_linha:
     CALL escreve_linha       ; escreve os pixels na linha corrente
     CALL troca_cor           ; troca a cor, de 0 para COR_PIXEL ou vice-versa, para a linha seguinte começar num pixel diferente
     ADD  R1, 1               ; próxima linha
     CMP  R1, R4              ; chegou ao fim?
     JLT  ee_proxima_linha
     POP  R4
     POP  R3
     POP  R1
     RET

; **********************************************************************
; ESCREVE_LINHA - Escreve uma linha completa no ecra, trocando a cor do pixel alternadamente
; Argumentos:   R1 - linha
;               R3 - cor do primeiro pixel (0 ou COR_PIXEL)
; 
; **********************************************************************
escreve_linha:
     PUSH R2
     PUSH R3
     PUSH R4
     MOV  R2, 0               ; coluna corrente
     MOV  R4, N_COLUNAS
el_proximo_pixel:
     CALL escreve_pixel       ; escreve o pixel na coluna corrente
     CALL troca_cor           ; troca a cor, de 0 para COR_PIXEL ou vice-versa
     ADD  R2, 1               ; próxima coluna
     CMP  R2, R4              ; chegou ao fim?
     JLT  el_proximo_pixel
     POP  R4
     POP  R3
     POP  R2
     RET

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
	
; **********************************************************************
; TROCA_COR - Alterna a cor entre desligado e COR_PIXEL.
; Argumentos:   R3 - cor a trocar
; Saídas:       R3 - cor trocada
;
; **********************************************************************
troca_cor:
    CMP  R3, 0                ; se a cor é 0, vai alterar a cor para COR_PIXEL. Se não, põe a 0.
    JZ   poe_cor
    MOV  R3, 0
    JMP  troca_cor_saida
poe_cor:    
    MOV  R3, COR_PIXEL
troca_cor_saida:
    RET

