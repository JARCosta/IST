; *********************************************************************************
; * IST-UL
; * Modulo:    lab5-quatro-barras-displays.asm
; * Descri��o: Este programa ilustra o funcionamento simult�neo entre um programa
; *            principal e interrup��es. O programa principal faz contar os displays.
; *            As interrup��es animam as barras que caem no ecr�.
; *            A temporiza��o dos displays � feita por uma rotina com um ciclo de atraso.
; *            As temporiza��es do movimento das barras s�o feitas por interrup��es. 
; *
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
DEFINE_LINHA        EQU 600AH      ; endere�o do comando para definir a linha
DEFINE_COLUNA       EQU 600CH      ; endere�o do comando para definir a coluna
ESCREVE_8_PIXELS    EQU 601CH      ; endere�o do comando para escrever 8 pixels
APAGA_ECRAS         EQU 6002H      ; endere�o do comando para apagar todos os pixels de todos os ecr�s
APAGA_AVISO         EQU 6040H      ; endere�o do comando para apagar o aviso de nenhum cen�rio selecionado

N_LINHAS            EQU  32        ; n�mero de linhas do �cr�
BARRA               EQU  0FFH      ; valor do byte usado para representar a barra

DISPLAYS            EQU  0A000H    ; endere�o do perif�rico que liga aos displays
DELAY               EQU  1000H     ; valor usado para implementar um atraso temporal    

; *********************************************************************************
; * Dados 
; *********************************************************************************
PLACE     1000H
pilha:    TABLE 100H          ; espa�o reservado para a pilha 
                              ; (200H bytes, pois s�o 100H words)
SP_inicial:                   ; este � o endere�o (1200H) com que o SP deve ser 
                              ; inicializado. O 1.� end. de retorno ser� 
                              ; armazenado em 11FEH (1200H-2)
                              
; Tabela das rotinas de interrup��o
tab:      WORD rot_int_0      ; rotina de atendimento da interrup��o 0
          WORD rot_int_1      ; rotina de atendimento da interrup��o 1
          WORD rot_int_2      ; rotina de atendimento da interrup��o 2
          WORD rot_int_3      ; rotina de atendimento da interrup��o 3

linha_barra:
          WORD 0              ; linha em que a 1� barra est�
          WORD 0              ; linha em que a 2� barra est�
          WORD 0              ; linha em que a 3� barra est�
          WORD 0              ; linha em que a 4� barra est�
                              
; *********************************************************************************
; * C�digo
; *********************************************************************************
PLACE   0                     ; o c�digo tem de come�ar em 0000H
inicio:
     MOV  BTE, tab            ; inicializa BTE (registo de Base da Tabela de Exce��es)
     MOV  SP, SP_inicial      ; inicializa SP para a palavra a seguir
                              ; � �ltima da pilha
    
     MOV  R0, APAGA_ECRAS
     MOV  [R0], R1            ; apaga todos os pixels de todos os ecr�s (o valor de R1 n�o � relevante)
     
     MOV  R0, APAGA_AVISO
     MOV  [R0], R1            ; apaga o aviso de nenhum cen�rio selecionado (o valor de R1 n�o � relevante)
     
     EI0                      ; permite interrup��es 0
     EI1                      ; permite interrup��es 1
     EI2                      ; permite interrup��es 2
     EI3                      ; permite interrup��es 3
     EI                       ; permite interrup��es (geral)

     MOV  R0, DISPLAYS        ; endere�o do perif�rico que liga aos displays
     MOV  R2, 0               ; contador cujo valor vai ser mostrado nos displays

ciclo:
     MOVB [R0], R2            ; mostra o valor do contador nos displays
     ADD  R2, 1               ; prepara o pr�ximo valor a mostrar no display
     MOV  R1, DELAY           ; valor para o atraso
     CALL atraso              ; espera algum tempo

     JMP  ciclo

; **********************************************************************
; ROT_INT_0 - Rotina de atendimento da interrup��o 0
;        Faz a barra descer uma linha. A anima��o da barra � causada pela
;        invoca��o peri�dica desta rotina
; **********************************************************************
rot_int_0:
     PUSH R3
     MOV  R3, 0               ; n� da barra
     CALL anima_barra         ; faz a barra descer de uma linha. Se chegar ao fundo, passa ao topo
     POP  R3
     RFE                      ; Return From Exception (diferente do RET)

; **********************************************************************
; ROT_INT_1 - Rotina de atendimento da interrup��o 1
;        Faz a barra descer uma linha. A anima��o da barra � causada pela
;        invoca��o peri�dica desta rotina
; **********************************************************************
rot_int_1:
     PUSH R3
     MOV  R3, 1               ; n� da barra
     CALL anima_barra         ; faz a barra descer de uma linha. Se chegar ao fundo, passa ao topo
     POP  R3
     RFE                      ; Return From Exception (diferente do RET)

; **********************************************************************
; ROT_INT_2 - Rotina de atendimento da interrup��o 2
;        Faz a barra descer uma linha. A anima��o da barra � causada pela
;        invoca��o peri�dica desta rotina
; **********************************************************************
rot_int_2:
     PUSH R3
     MOV  R3, 2               ; n� da barra
     CALL anima_barra         ; faz a barra descer de uma linha. Se chegar ao fundo, passa ao topo
     POP  R3
     RFE                      ; Return From Exception (diferente do RET)

; **********************************************************************
; ROT_INT_3 - Rotina de atendimento da interrup��o 3
;        Faz a barra descer uma linha. A anima��o da barra � causada pela
;        invoca��o peri�dica desta rotina
; **********************************************************************
rot_int_3:
     PUSH R3
     MOV  R3, 3               ; n� da barra
     CALL anima_barra         ; faz a barra descer de uma linha. Se chegar ao fundo, passa ao topo
     POP  R3
     RFE                      ; Return From Exception (diferente do RET)


; **********************************************************************
; ANIMA_BARRA - Desenha e faz descer uma barra de 8 pixels no ecr�, numa dada coluna.
;               Se chegar ao fundo, passa ao topo.
;               A linha em que o byte � escrito � guardada na vari�vel linha_barra, que �
;               uma tabela de quatro vari�veis simples, uma para cada barra
; Argumentos: R3 - N� da barra (0 a 3)
; **********************************************************************
anima_barra:
     PUSH R1
     PUSH R2
     PUSH R3
     PUSH R4
     PUSH R5
     PUSH R6
     MOV  R5, linha_barra
     MOV  R6, R3              ; c�pia de R3 (para n�o destruir R3)
     SHL  R6, 1               ; multiplica o n� da barra por 2 (porque a linha_barra � uma tabela de words)
     MOV  R2, [R5+R6]         ; linha em que a barra est�
     SHL  R3, 3               ; multiplica o n� da barra por 8 para dar a coluna onde desenhar o byte
     MOV  R1, 0               ; para apagar a barra
     CALL escreve_byte        ; apaga a barra do ecr�
     ADD  R2, 1               ; passa � linha abaixo
     MOV  R4, N_LINHAS
     CMP  R2, R4              ; j� estava na linha do fundo?
     JLT  escreve
     MOV  R2, 0               ; volta ao topo do ecr�
escreve:
     MOV  [R5+R6], R2         ; atualiza na tabela a linha em que esta barra est�
     MOV  R1, BARRA           ; valor da barra
     CALL escreve_byte        ; escreve a barra na nova linha
     POP  R6
     POP  R5
     POP  R4
     POP  R3
     POP  R2
     POP  R1
     RET


; **********************************************************************
; ESCREVE_BYTE - Escreve um byte no ecr�, com a cor da caneta
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
    
     MOV  R0, ESCREVE_8_PIXELS     ; endere�o do comando para escrever 8 pixels
     MOV  [R0], R1                 ; escreve os 8 pixels correspondentes ao byte
     POP  R0
     RET

; **********************************************************************
; ATRASO - Espera algum tempo
; Argumentos: R1 - Valor a usar no contador para o atraso
; **********************************************************************
atraso:
     PUSH R1
continua:
     SUB  R1, 1               ; decrementa o contador de 1 unidade
     JNZ  continua            ; s� sai quando o contador chegar a 0
     POP  R1
     RET


