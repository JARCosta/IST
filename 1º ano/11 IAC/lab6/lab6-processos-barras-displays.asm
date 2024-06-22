; *********************************************************************************
; * IST-UL
; * Modulo:    lab6-processos-barras-displays.asm
; * Descri��o: Este programa ilustra o funcionamento de v�rios processos cooperativos.
; *            Um dos processos faz contar os displays, com temporiza��o feita
; *            por uma rotina com um ciclo de atraso.
; *            Os outros processos animam as barras que caem no ecr�, com
; *            o movimento das barras sincronizadas com interrup��es. 
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
DELAY               EQU  2000H     ; valor usado para implementar um atraso temporal    

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

evento_int:
          WORD 0              ; se 1, indica que a interrup��o 0 ocorreu
          WORD 0              ; se 1, indica que a interrup��o 1 ocorreu
          WORD 0              ; se 1, indica que a interrup��o 2 ocorreu
          WORD 0              ; se 1, indica que a interrup��o 3 ocorreu
                              
linha_barra:
          WORD 0              ; linha em que a 1� barra est�
          WORD 0              ; linha em que a 2� barra est�
          WORD 0              ; linha em que a 3� barra est�
          WORD 0              ; linha em que a 4� barra est�
                              
contador:
          WORD 0              ; contador usado para mostrar nos displays
          
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

; ciclo dos processos
ciclo:

     CALL anima_displays      ; faz os displays avan�ar de uma unidade

     ; Estes 4 CALLs podiam ser feitos num ciclo, incrementando o R3, mas assim � mais expl�cito
     MOV  R3, 0               ; n� da barra
     CALL anima_barra         ; faz a barra nesta coluna descer de uma linha. Se chegar ao fundo, passa ao topo

     MOV  R3, 1               ; n� da barra
     CALL anima_barra         ; faz a barra nesta coluna descer de uma linha. Se chegar ao fundo, passa ao topo

     MOV  R3, 2               ; n� da barra
     CALL anima_barra         ; faz a barra nesta coluna descer de uma linha. Se chegar ao fundo, passa ao topo

     MOV  R3, 3               ; n� da barra
     CALL anima_barra         ; faz a barra nesta coluna descer de uma linha. Se chegar ao fundo, passa ao topo

     JMP  ciclo

; **********************************************************************
; Processos 
; **********************************************************************


; **********************************************************************
; ANIMA_DISPLAYS - Processo que avan�a o valor dos displays de uma unidade
; **********************************************************************
anima_displays:
     PUSH R0
     PUSH R1
     PUSH R2
     PUSH R3
     MOV  R3, contador        ; contador, cujo valor vai ser mostrado nos displays
     MOV  R2, [R3]            ; obt�m valor do contador
     MOV  R0, DISPLAYS        ; endere�o do perif�rico que liga aos displays
     MOVB [R0], R2            ; mostra o valor do contador nos displays
     ADD  R2, 1               ; prepara o pr�ximo valor a mostrar no display
     MOV  [R3], R2            ; atualiza valor do contador
     MOV  R1, DELAY           ; valor para o atraso
     CALL atraso              ; espera algum tempo
     POP  R3
     POP  R2
     POP  R1
     POP  R0
     RET

; **********************************************************************
; ANIMA_BARRA - Faz descer uma barra no ecr�, numa dada coluna, caso tenha ocorrido
;               a interrup��o respetiva. Se chegar ao fundo, passa ao topo.
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
     MOV  R6, R3              ; c�pia de R3 (para n�o destruir R3)
     SHL  R6, 1               ; multiplica a coluna por 2 porque a linha_barra e o evento_int s�o tabelas de words

     MOV  R5, evento_int
     MOV  R2, [R5+R6]         ; valor da vari�vel que diz se houve uma interrup��o com o mesmo n�mero da coluna
     CMP  R2, 0
     JZ   sai_anima_barra     ; se n�o houve interrup��o, vai-se embora
     MOV  R2, 0
     MOV  [R5+R6], R2         ; coloca a zero o valor da vari�vel que diz se houve uma interrup��o (consome evento)

     MOV  R5, linha_barra
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
sai_anima_barra:
     POP  R6
     POP  R5
     POP  R4
     POP  R3
     POP  R2
     POP  R1
     RET
    
     
; **********************************************************************
; Rotinas de interrup��o 
; **********************************************************************


; **********************************************************************
; ROT_INT_0 - Rotina de atendimento da interrup��o 0
;             Assinala o evento na componente 0 da vari�vel evento_int
; **********************************************************************
rot_int_0:
     PUSH R0
     PUSH R1
     MOV  R0, evento_int
     MOV  R1, 1               ; assinala que houve uma interrup��o 0
     MOV  [R0], R1            ; na componente 0 da vari�vel evento_int
     POP  R1
     POP  R0
     RFE

; **********************************************************************
; ROT_INT_1 - Rotina de atendimento da interrup��o 1
;             Assinala o evento na componente 1 da vari�vel evento_int
; **********************************************************************
rot_int_1:
     PUSH R0
     PUSH R1
     MOV  R0, evento_int
     MOV  R1, 1               ; assinala que houve uma interrup��o 0
     MOV  [R0+2], R1          ; na componente 1 da vari�vel evento_int
                              ; Usa-se 2 porque cada word tem 2 bytes
     POP  R1
     POP  R0
     RFE

; **********************************************************************
; ROT_INT_2 - Rotina de atendimento da interrup��o 2
;             Assinala o evento na componente 2 da vari�vel evento_int
; **********************************************************************
rot_int_2:
     PUSH R0
     PUSH R1
     MOV  R0, evento_int
     MOV  R1, 1               ; assinala que houve uma interrup��o 0
     MOV  [R0+4], R1          ; na componente 2 da vari�vel evento_int
                              ; Usa-se 4 porque cada word tem 2 bytes
     POP  R1
     POP  R0
     RFE

; **********************************************************************
; ROT_INT_3 - Rotina de atendimento da interrup��o 3
;             Assinala o evento na componente 3 da vari�vel evento_int
; **********************************************************************
rot_int_3:
     PUSH R0
     PUSH R1
     MOV  R0, evento_int
     MOV  R1, 1               ; assinala que houve uma interrup��o 0
     MOV  [R0+6], R1          ; na componente 3 da vari�vel evento_int
                              ; Usa-se 6 porque cada word tem 2 bytes
     POP  R1
     POP  R0
     RFE

     
; **********************************************************************
; Rotinas auxiliares 
; **********************************************************************


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


