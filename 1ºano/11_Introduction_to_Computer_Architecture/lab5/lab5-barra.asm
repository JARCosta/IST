; *********************************************************************************
; * IST-UL
; * Modulo:    lab5-barra.asm
; * Descrição: Este programa anima uma barra (8 pixels) que desce verticalmente no ecrã.
; *            A temporização do movimento é feita por um ciclo de atraso. 
; *
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
DEFINE_LINHA        EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA       EQU 600CH      ; endereço do comando para definir a coluna
ESCREVE_8_PIXELS    EQU 601CH      ; endereço do comando para escrever 8 pixels
APAGA_ECRAS         EQU 6002H      ; endereço do comando para apagar todos os pixels de todos os ecrãs
APAGA_AVISO         EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado

N_LINHAS            EQU	32        ; número de linhas do écrã
forma_nave:
					word	010H      ; valor do byte usado para representar a barra
    				word	038H
    				word	054H
    				word	092H
    				word	06CH

					
DELAY               EQU  1000H     ; valor usado para implementar um atraso temporal    

; *********************************************************************************
; * Dados 
; *********************************************************************************
PLACE     1000H
pilha:    TABLE 100H          ; espaço reservado para a pilha 
                              ; (200H bytes, pois são 100H words)
SP_inicial:                   ; este é o endereço (1200H) com que o SP deve ser 
                              ; inicializado. O 1.º end. de retorno será 
                              ; armazenado em 11FEH (1200H-2)
                              
linha_barra:
          WORD 0              ; linha em que a barra está
                              
; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                     ; o código tem de começar em 0000H
inicio:
     MOV  SP, SP_inicial      ; inicializa SP para a palavra a seguir
                              ; à última da pilha
    
;     MOV  R0, APAGA_ECRAS
;     MOV  [R0], R1            ; apaga todos os pixels de todos os ecrãs (o valor de R1 não é relevante)
     
     MOV  R0, APAGA_AVISO
     MOV  [R0], R1            ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
     
ciclo:
     CALL anima_barra         ; desenha e faz a barra descer de uma linha. Se chegar ao fundo, passa ao topo
     MOV  R1, DELAY           ; valor para o atraso
     CALL atraso              ; espera algum tempo

     JMP  ciclo               ; anima a barra novamente

; **********************************************************************
; ANIMA_BARRA - Desenha e faz descer uma barra de 8 pixels no ecrã.
;               Se chegar ao fundo, passa ao topo.
;               A linha em que o byte é escrito é guardada na variável linha_barra
; Argumentos: Nenhum
; **********************************************************************
anima_barra:
     PUSH R1
     PUSH R2
     PUSH R3
     PUSH R4
     PUSH R5
     MOV  R3, 0               ; coluna a partir da qual a barra é desenhada
     MOV  R4, linha_barra
     MOV  R2, [R4]            ; linha em que a barra está
     MOV  R1, 0               ; para apagar a barra
     CALL escreve_byte        ; apaga a barra do ecrã
     ADD  R2, 1               ; passa à linha abaixo
     MOV  R5, N_LINHAS
     CMP  R2, R5              ; já estava na linha do fundo?
     JLT  escreve
     MOV  R2, 0               ; volta ao topo do ecrã
escreve:
     MOV  [R4], R2            ; atualiza na variável a linha em que a barra está
     MOV  R1, BARRA1           ; valor da barra
	 MOV  R6, BARRA2
	 MOV  R7, BARRA3
	 MOV  R8, BARRA4
	 MOV  R9, BARRA5
     CALL escreve_byte        ; escreve a barra na nova linha
     POP  R5
     POP  R4
     POP  R3
     POP  R2
     POP  R1
     RET

; **********************************************************************
; ESCREVE_BYTE - Escreve um byte no ecrã, com a cor da caneta
; Argumentos: R1 - Valor do byte a escrever
;             R2 - Linha onde escrever o byte (entre 0 e N_LINHAS - 1)
;             R3 - Coluna a partir da qual a barra deve ser desenhada 
; **********************************************************************
escreve_byte:
     PUSH R0
     MOV  R0, DEFINE_LINHA
     MOV  [R0], R2                 ; seleciona a linha
    
     MOV  R0, DEFINE_COLUNA
     MOV  [R0], R3                 ; seleciona a coluna
	 COMP R10, 4
	 JZ lnave1
lnave1:
     MOV  R0, ESCREVE_8_PIXELS     ; endereço do comando para escrever 8 pixels
     MOV  [R0], R1                 ; escreve os 8 pixels correspondentes ao byte
	 ADD  R10, 1
	 
     POP  R0
     RET

; **********************************************************************
; ATRASO - Espera algum tempo
; Argumentos: R1 - Valor a usar no contador para o atraso
; **********************************************************************
atraso:
     PUSH R1
continua:
     SUB  R1, 1                    ; decrementa o contador de 1 unidade
     JNZ  continua                 ; só sai quando o contador chegar a 0
     POP  R1
     RET

