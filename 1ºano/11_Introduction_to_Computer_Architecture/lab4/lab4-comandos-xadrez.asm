; *********************************************************************************
; * IST-UL
; * Modulo:    lab4-comandos-xadrez.asm
; * Descrição: Este programa ilustra o funcionamento do ecrã, em que os pixels
; *            são escritos por meio de comandos.
; *            Desenha um padrão de xadrez no ecrã, preenchendo todos os pixels. 
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
DEFINE_LINHA    EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL    EQU 6012H      ; endereço do comando para escrever um pixel
APAGA_AVISO     EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado

N_LINHAS        EQU  32        ; número de linhas do ecrã (altura)
N_COLUNAS       EQU  64        ; número de colunas do ecrã (largura)

COR_PIXEL       EQU 0FF00H     ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)

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
     
     MOV  R0, APAGA_AVISO
     MOV  [R0], R1            ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
     
     MOV  R3, 0               ; primeiro pixel a 0                   
     CALL escreve_ecra        ; escreve todo o ecrã

fim:
     JMP  fim                 ; termina programa

; **********************************************************************
; ESCREVE_ECRA - Escreve todos os pixels do ecra, trocando a cor do pixel
;                sempre que se muda de linha
; Argumentos: ;  R3 - cor do primeiro pixel (0 ou COR_PIXEL)

; **********************************************************************
escreve_ecra:
     PUSH R1                  ; guarda os registos alterados por esta rotina
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
    
    POP  R0
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

