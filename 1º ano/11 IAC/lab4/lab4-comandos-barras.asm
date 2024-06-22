; *********************************************************************************
; * IST-UL
; * Modulo:    lab4-comandos-barras.asm
; * Descrição: Este programa ilustra o funcionamento do ecrã, em que os pixels
; *            são escritos por meio de comandos, escrevendo 8 pixels de uma só vez.
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
DEFINE_No_PIXEL     EQU 600EH      ; endereço do comando para definir o nº do pixel da posição corrente
AUTO_INCREMENT      EQU 6010H      ; endereço do comando para ligar o auto-increment
ESCREVE_8_PIXELS    EQU 601CH      ; endereço do comando para escrever 8 pixels
DEFINE_CANETA       EQU 6014H      ; endereço do comando para definir a cor da caneta
APAGA_AVISO         EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado


N_BYTES_ECRA        EQU 256        ; número de bytes do ecrã (32 linhas * 8 bytes/linha)

COR_CANETA          EQU 0F0F0H     ; cor da caneta: verde em ARGB (opaco e verde no máximo, vermelho e azul a 0)

BYTE_PADRAO         EQU 0CCH       ; byte para escrever no ecrã e desenhar um padrão (com a cor da caneta)   

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
     
     MOV  R0, DEFINE_No_PIXEL
     MOV  R1, 0
     MOV  [R0], R1            ; define a posição inicial dos pixels, a partir da qual os pixels serão escritos
     
     MOV  R0, AUTO_INCREMENT
     MOV  R1, 1
     MOV  [R0], R1            ; liga o auto-increment
     
     MOV  R0, DEFINE_CANETA
     MOV  R1, COR_CANETA
     MOV  [R0], R1            ; define a cor da caneta com a qual os pixels serão escritos
     
     MOV  R2, N_BYTES_ECRA    ; números de byte do ecrã
     
     MOV  R0, ESCREVE_8_PIXELS
escreve_byte:     
     MOV  R1, BYTE_PADRAO     ; byte para escrever no ecrã e desenhar um padrão                   
     MOV  [R0], R1            ; escreve os 8 pixels correspondentes ao byte (auto-increment avança a posição)
     
     SUB  R2, 1               ; menos um byte para tratar
     JNZ  escreve_byte

fim:
     JMP  fim                 ; termina programa

