; *********************************************************************************
; * IST-UL
; * Modulo:    lab6-processos-teclado-bloqueante.asm
; * Modulo:    lab6-processos-teclado-OK.asm
; * Descrição: Este programa ilustra o funcionamento de vários processos cooperativos.
; *            Igual ao lab6-processos-teclado-bloqueante.asm, mas agora com o
; *            teclado não bloqueante.
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

N_LINHAS            EQU  32        ; número de linhas do écrã
BARRA               EQU  0FFH      ; valor do byte usado para representar a barra

DISPLAYS            EQU  0A000H    ; endereço do periférico que liga aos displays
TEC_LIN             EQU  0C000H    ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL             EQU  0E000H    ; endereço das colunas do teclado (periférico PIN)
LINHA               EQU  8         ; linha a testar (4ª linha, 1000b)
DELAY               EQU  80H       ; valor usado para implementar um atraso temporal    

; *********************************************************************************
; * Dados 
; *********************************************************************************
PLACE     1000H
pilha:    TABLE 100H          ; espaço reservado para a pilha 
                              ; (200H bytes, pois são 100H words)
SP_inicial:                   ; este é o endereço (1200H) com que o SP deve ser 
                              ; inicializado. O 1.º end. de retorno será 
                              ; armazenado em 11FEH (1200H-2)
                              
; Tabela das rotinas de interrupção
tab:      WORD rot_int_0      ; rotina de atendimento da interrupção 0
          WORD rot_int_1      ; rotina de atendimento da interrupção 1
          WORD rot_int_2      ; rotina de atendimento da interrupção 2
          WORD rot_int_3      ; rotina de atendimento da interrupção 3

evento_int:
          WORD 0              ; se 1, indica que a interrupção 0 ocorreu
          WORD 0              ; se 1, indica que a interrupção 1 ocorreu
          WORD 0              ; se 1, indica que a interrupção 2 ocorreu
          WORD 0              ; se 1, indica que a interrupção 3 ocorreu
                              
linha_barra:
          WORD 0              ; linha em que a 1ª barra está
          WORD 0              ; linha em que a 2ª barra está
          WORD 0              ; linha em que a 3ª barra está
          WORD 0              ; linha em que a 4ª barra está
                              
contador:
          WORD 0              ; contador usado para mostrar nos displays
          
contador_atraso:
          WORD DELAY              ; contador usado para gerar o atraso
          
coluna_carregada:
          WORD 0              ; variável que indica se uma tecla foi carregada
                              ; 0 - não
                              ; 1, 2, 4 ou 8 - sim, e valor indica a coluna da tecla) 
          
; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                     ; o código tem de começar em 0000H
inicio:
     MOV  BTE, tab            ; inicializa BTE (registo de Base da Tabela de Exceções)
     MOV  SP, SP_inicial      ; inicializa SP para a palavra a seguir
                              ; à última da pilha
    
     MOV  R0, APAGA_ECRAS
     MOV  [R0], R1            ; apaga todos os pixels de todos os ecrãs (o valor de R1 não é relevante)
     
     MOV  R0, APAGA_AVISO
     MOV  [R0], R1            ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
     
     EI0                      ; permite interrupções 0
     EI1                      ; permite interrupções 1
     EI2                      ; permite interrupções 2
     EI3                      ; permite interrupções 3
     EI                       ; permite interrupções (geral)

; ciclo dos processos
ciclo:

     CALL teclado             ; verifica se alguma tecla foi carregada

     CALL anima_displays      ; faz os displays avançar de uma unidade

     ; Estes 4 CALLs podiam ser feitos num ciclo, incrementando o R3, mas assim é mais explícito
     MOV  R3, 0               ; nº da barra
     CALL anima_barra         ; faz a barra nesta coluna descer de uma linha. Se chegar ao fundo, passa ao topo

     MOV  R3, 1               ; nº da barra
     CALL anima_barra         ; faz a barra nesta coluna descer de uma linha. Se chegar ao fundo, passa ao topo

     MOV  R3, 2               ; nº da barra
     CALL anima_barra         ; faz a barra nesta coluna descer de uma linha. Se chegar ao fundo, passa ao topo

     MOV  R3, 3               ; nº da barra
     CALL anima_barra         ; faz a barra nesta coluna descer de uma linha. Se chegar ao fundo, passa ao topo

     JMP  ciclo

; **********************************************************************
; Processos 
; **********************************************************************


; **********************************************************************
; TECLADO - Processo que deteta quando se carrega numa tecla na 4ª linha
;           do teclado. É bloqueante e só retorna quando a tecla carregada.
; **********************************************************************
teclado:
     PUSH R0
     PUSH R1
     PUSH R2
     PUSH R3
     MOV  R2, TEC_LIN         ; endereço do periférico das linhas
     MOV  R3, TEC_COL         ; endereço do periférico das colunas

     MOV  R1, LINHA           ; testar a linha 4 
     MOVB [R2], R1            ; escrever no periférico de saída (linhas)
     MOVB R0, [R3]            ; ler do periférico de entrada (colunas)
     CMP  R0, 0               ; há tecla premida?
     JNZ  ha_tecla
     MOV  R2, 0               ; nenhuma tecla premida
     JMP  sai_teclado
ha_tecla:
     MOV  R2, R0              ; houve uma tecla premida
sai_teclado:
     MOV  R1, coluna_carregada
     MOV  [R1], R2            ; atualiza na variável a informação sobre se houve ou não tecla premida
                              ; O uso de R2 é redundante (bastava guardar R0), mas assim é mais explícito
     POP  R3
     POP  R2
     POP  R1
     POP  R0
     RET



; **********************************************************************
; ANIMA_DISPLAYS - Processo que avança o valor dos displays de uma unidade
; **********************************************************************
anima_displays:
     PUSH R0
     PUSH R1
     PUSH R2
     PUSH R3
     CALL atraso              ; espera tempo
     CMP  R1, 0               ; tempo de espera chegou ao fim?
     JNZ  sai_anima_displays
     MOV  R3, contador        ; contador, cujo valor vai ser mostrado nos displays
     MOV  R2, [R3]            ; obtém valor do contador
     MOV  R0, DISPLAYS        ; endereço do periférico que liga aos displays
     MOVB [R0], R2            ; mostra o valor do contador nos displays
     MOV  R0, coluna_carregada
     MOV  R1, [R0]            ; obtém em R1 a informação sobre se há ou não tecla premida
     CMP  R1, 0               ; há tecla premida?
     JZ  cresce
     SUB  R2, 1               ; há, diminui o valor dos displays
     JMP  atualiza
cresce:
     ADD  R2, 1               ; não, aumenta o valor dos displays
atualiza:
     MOV  [R3], R2            ; atualiza valor do contador
sai_anima_displays:
     POP  R3
     POP  R2
     POP  R1
     POP  R0
     RET

; **********************************************************************
; ANIMA_BARRA - Faz descer uma barra no ecrã, numa dada coluna, caso tenha ocorrido
;               a interrupção respetiva. Se chegar ao fundo, passa ao topo.
;               A linha em que o byte é escrito é guardada na variável linha_barra, que é
;               uma tabela de quatro variáveis simples, uma para cada barra
; Argumentos: R3 - Nº da barra (0 a 3)
; **********************************************************************
anima_barra:
     PUSH R1
     PUSH R2
     PUSH R3
     PUSH R4
     PUSH R5
     PUSH R6
     MOV  R6, R3              ; cópia de R3 (para não destruir R3)
     SHL  R6, 1               ; multiplica a coluna por 2 porque a linha_barra e o evento_int são tabelas de words

     MOV  R5, evento_int
     MOV  R2, [R5+R6]         ; valor da variável que diz se houve uma interrupção com o mesmo número da coluna
     CMP  R2, 0
     JZ   sai_anima_barra     ; se não houve interrupção, vai-se embora
     MOV  R2, 0
     MOV  [R5+R6], R2         ; coloca a zero o valor da variável que diz se houve uma interrupção (consome evento)

     MOV  R5, linha_barra
     MOV  R2, [R5+R6]         ; linha em que a barra está
     SHL  R3, 3               ; multiplica o nº da barra por 8 para dar a coluna onde desenhar o byte
     MOV  R1, 0               ; para apagar a barra
     CALL escreve_byte        ; apaga a barra do ecrã
     ADD  R2, 1               ; passa à linha abaixo
     MOV  R4, N_LINHAS
     CMP  R2, R4              ; já estava na linha do fundo?
     JLT  escreve
     MOV  R2, 0               ; volta ao topo do ecrã
escreve:
     MOV  [R5+R6], R2         ; atualiza na tabela a linha em que esta barra está
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
; Rotinas de interrupção 
; **********************************************************************


; **********************************************************************
; ROT_INT_0 - Rotina de atendimento da interrupção 0
;             Assinala o evento na componente 0 da variável evento_int
; **********************************************************************
rot_int_0:
     PUSH R0
     PUSH R1
     MOV  R0, evento_int
     MOV  R1, 1               ; assinala que houve uma interrupção 0
     MOV  [R0], R1            ; na componente 0 da variável evento_int
     POP  R1
     POP  R0
     RFE

; **********************************************************************
; ROT_INT_1 - Rotina de atendimento da interrupção 1
;             Assinala o evento na componente 1 da variável evento_int
; **********************************************************************
rot_int_1:
     PUSH R0
     PUSH R1
     MOV  R0, evento_int
     MOV  R1, 1               ; assinala que houve uma interrupção 0
     MOV  [R0+2], R1          ; na componente 1 da variável evento_int
                              ; Usa-se 2 porque cada word tem 2 bytes
     POP  R1
     POP  R0
     RFE

; **********************************************************************
; ROT_INT_2 - Rotina de atendimento da interrupção 2
;             Assinala o evento na componente 2 da variável evento_int
; **********************************************************************
rot_int_2:
     PUSH R0
     PUSH R1
     MOV  R0, evento_int
     MOV  R1, 1               ; assinala que houve uma interrupção 0
     MOV  [R0+4], R1          ; na componente 2 da variável evento_int
                              ; Usa-se 4 porque cada word tem 2 bytes
     POP  R1
     POP  R0
     RFE

; **********************************************************************
; ROT_INT_3 - Rotina de atendimento da interrupção 3
;             Assinala o evento na componente 3 da variável evento_int
; **********************************************************************
rot_int_3:
     PUSH R0
     PUSH R1
     MOV  R0, evento_int
     MOV  R1, 1               ; assinala que houve uma interrupção 0
     MOV  [R0+6], R1          ; na componente 3 da variável evento_int
                              ; Usa-se 6 porque cada word tem 2 bytes
     POP  R1
     POP  R0
     RFE

     
; **********************************************************************
; Rotinas auxiliares 
; **********************************************************************


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
    
     MOV  R0, ESCREVE_8_PIXELS     ; endereço do comando para escrever 8 pixels
     MOV  [R0], R1                 ; escreve os 8 pixels correspondentes ao byte
     POP  R0
     RET

; **********************************************************************
; ATRASO - Faz DELAY iterações, para implementar um atraso no tempo,
;          de forma não bloqueante.
; Argumentos: Nenhum
; Saidas:     R1 - Se 0, o atraso chegou ao fim
; **********************************************************************
atraso:
     PUSH R2
     PUSH R3
     MOV  R3, contador_atraso        ; contador, cujo valor vai ser mostrado nos displays
     MOV  R1, [R3]                   ; obtém valor do contador do atraso
     SUB  R1, 1
     MOV  [R3], R1                   ; atualiza valor do contador do atraso
     JNZ  sai
     MOV  R2, DELAY
     MOV  [R3], R2                   ; volta a colocar o valor inicial no contador do atraso
sai:
     POP  R3
     POP  R2
     RET


