% Nome: Maria Francisco Ribeiro  Numero: 93735

:- [codigo_comum].
:- [puzzles_publicos].

% Predicado aplica_R1_triplo 

aplica_R1_triplo(Lista, Lista_R1):- conta(1, Lista, Contador),
    Contador == 2, duplicate_term(Lista, L_aux),!,
    insere_elemento(0, L_aux), Lista_R1 = L_aux.

aplica_R1_triplo(Lista, Lista_R1):- conta(0, Lista, Contador),
    Contador == 2, duplicate_term(Lista, L_aux),!,
    insere_elemento(1, L_aux), Lista_R1 = L_aux.

aplica_R1_triplo(Lista, Lista_R1):- conta(0, Lista, Contador),
    Contador == 1, Lista_R1 = Lista,!.

aplica_R1_triplo(Lista, Lista_R1):- conta(1, Lista, Contador),
    Contador == 1, Lista_R1 = Lista,!.

aplica_R1_triplo(Lista, Lista_R1):- conta(1, Lista, Contador_Zero),
    Contador_Zero == 0, conta(0, Lista, Contador), Contador == 0,!,
    Lista_R1 = Lista.

% Predicado aplica_R1_fila_aux

aplica_R1_fila_aux([X, Y], [X, Y]):- !.

aplica_R1_fila_aux([El_1, El_2, El_3|R_Fila], [ElR1_1|Fila_R1]):-
    aplica_R1_triplo([El_1, El_2, El_3], [ElR1_1, ElR1_2, ElR1_3]),
    aplica_R1_fila_aux([ElR1_2, ElR1_3|R_Fila], Fila_R1).


% Predicado aplica_R1_fila

aplica_R1_fila(Fila, Fila_aux):- aplica_R1_fila_aux(Fila, Fila_R1),
    Fila_R1 == Fila,!, Fila_aux = Fila_R1.

aplica_R1_fila(Fila, Fila_aux):- aplica_R1_fila_aux(Fila, Fila_R1),
    Fila_R1 \== Fila,!, aplica_R1_fila(Fila_R1, Fila_aux).


% Predicado aplica_R2_fila

aplica_R2_fila(Fila, Fila_R2):- length(Fila, N), conta(0, Fila, Contador),
    Contador =:= N/2, duplicate_term(Fila, Fila_R2), 
    insere_elemento(1, Fila_R2).

aplica_R2_fila(Fila, Fila_R2):- length(Fila, N), conta(1, Fila, Contador), 
    Contador =:= N/2, duplicate_term(Fila, Fila_R2), 
    insere_elemento(0, Fila_R2).

aplica_R2_fila(Fila, Fila_R2):- length(Fila, N), conta(1, Fila, Contador_1), 
    Contador_1 < N/2, conta(0, Fila, Contador_2), Contador_2 < N/2,
    Fila_R2 = Fila.

% Predicado aplica_R1_R2_fila

aplica_R1_R2_fila(Fila, Fila_R1_R2):- aplica_R1_fila(Fila, Fila_aux),
    aplica_R2_fila(Fila_aux, Fila_R1_R2).

% Predicado aplica_R1_R2_puzzle

aplica_R1_R2_puzzle(Puzzle, Puzzle_R1_R2):- 
    aplica_R1_R2_lc(Puzzle, Puzzle_aux), transpose(Puzzle_aux, Puzzle_aux2),
    aplica_R1_R2_lc(Puzzle_aux2, Puzzle_aux3), transpose(Puzzle_aux3, Puzzle_R1_R2).


% Predicado inicializa
inicializa(Puzzle, Puzzle_R1_R2):- aplica_R1_R2_puzzle(Puzzle, Puzzle_aux),
    Puzzle == Puzzle_aux, Puzzle_R1_R2 = Puzzle_aux.

inicializa(Puzzle, Puzzle_R1_R2):- aplica_R1_R2_puzzle(Puzzle, Puzzle_aux),
    Puzzle_aux \== Puzzle, inicializa(Puzzle_aux, Puzzle_R1_R2).


% Predicado verifica_R3

verifica_R3(Puzzle):- verifica_linhas_R3(Puzzle), transpose(Puzzle, Puzzle_aux),
    verifica_linhas_R3(Puzzle_aux).


% Predicado propaga_posicoes

propaga_posicoes([], Puzzle, Puzzle):- !.

propaga_posicoes([(L, C)|R_Coordenadas], Puzzle, Puzzle_N):- 
    procura_linha(Puzzle, L, Linha_aux), 
    aplica_R1_R2_fila(Linha_aux, Linha_aux2),
    mat_muda_linha(Puzzle, L, Linha_aux2, Puzzle_aux2), 
    mat_elementos_coluna(Puzzle_aux2, C, Coluna_aux), 
    aplica_R1_R2_fila(Coluna_aux, Coluna_aux2),
    mat_muda_coluna(Puzzle_aux2, C, Coluna_aux2, Puzzle_aux),
    encontra_alteracoes_linhas(Linha_aux, Linha_aux2, (L, 1), [],Coord_N1),
    encontra_alteracoes_colunas(Coluna_aux, Coluna_aux2, (1, C), [], Coord_N2),
    append([R_Coordenadas,Coord_N1, Coord_N2], Coord_N),
    propaga_posicoes(Coord_N, Puzzle_aux, Puzzle_N).

% Predicado resolve
resolve(Solucao, Solucao):-
    flatten(Solucao, Solucao_f),
    nao_tem_variaveis(Solucao_f), !.

resolve(Puzzle, Solucao):- inicializa(Puzzle, Puzzle_aux),
    verifica_R3(Puzzle_aux),
    encontra_variavel(Puzzle_aux, 0, Coord), 
    (Coord\==[] -> [(L, C)] = Coord,
    mat_muda_posicao(Puzzle_aux, (L, C), 1, Puzzle_aux2),
    propaga_posicoes(Coord, Puzzle_aux2, Puzzle_aux3);Puzzle_aux3=Puzzle_aux),
    resolve(Puzzle_aux3, Solucao).

resolve(Puzzle, Solucao):- inicializa(Puzzle, Puzzle_aux),
    verifica_R3(Puzzle_aux),
    encontra_variavel(Puzzle_aux, 0, Coord), 
    (Coord\==[] -> [(L, C)] = Coord,
    mat_muda_posicao(Puzzle_aux, (L, C), 1, Puzzle_aux2),
    propaga_posicoes(Coord, Puzzle_aux2, Puzzle_aux3);Puzzle_aux3=Puzzle_aux),
    resolve(Puzzle_aux3, Solucao).

% Predicado auxiliar que conta quantas vezes um elemento X
%                 aparece numa lista                                                                                                                       g           

conta(N, L_inicial, Contador):- findall(X, (member(X, L_inicial), X == N), L_aux),
    length(L_aux, Contador).

% Predicado auxiliar que adiciona um elemento a uma lista 

insere_elemento(_, []).

insere_elemento(Elemento, [El_1|R_L_in]):- var(El_1), El_1 = Elemento,
    insere_elemento(Elemento, R_L_in).

insere_elemento(Elemento, [El_1|R_L_in]):-number(El_1), 
    insere_elemento(Elemento, R_L_in).

% Predicado auxiliar que aplica a todas as linha de um puzzle R1 e R2
aplica_R1_R2_lc([], []):-!.

aplica_R1_R2_lc([El_1|R_Puzzle], [El_1_R12|R_Puzzle2]):- aplica_R1_R2_fila(El_1, El_1_R12),
    aplica_R1_R2_lc(R_Puzzle, R_Puzzle2), !.

% Predicado auxiliar que verifica R3

verifica_linhas_R3([]).

verifica_linhas_R3([El_1|R_Puzzle]):- verifica_linhas_R3_aux(R_Puzzle, El_1), 
    verifica_linhas_R3(R_Puzzle).

% Predicado auxiliar para a verifica R3

verifica_linhas_R3_aux([], _).

verifica_linhas_R3_aux([El_2|R_Puzzle], El_1):- El_2 \== El_1, !,
    verifica_linhas_R3_aux(R_Puzzle, El_1).

% Predicado auxiliar que procura uma linha

procura_linha([Fila|_], 1, Fila):- !.

procura_linha([_|R_Puzzle], L, Linha):-
    L > 0, NL is L - 1,
    procura_linha(R_Puzzle, NL, Linha).

% Predicado que encontra as linhas e colunas em que ocorreram alteracoes

encontra_alteracoes_linhas([], [], (_, _), Res,Res):- !.

encontra_alteracoes_linhas([El_Fila_I|R_Fila_I], [El_Fila_N|R_Fila_N], (L, C), Coord_N,Res):-
    El_Fila_I \== El_Fila_N, C1 is C + 1,!,
    encontra_alteracoes_linhas(R_Fila_I, R_Fila_N, (L, C1), [(L,C)|Coord_N],Res).

encontra_alteracoes_linhas([El_Fila_I|R_Fila_I], [El_Fila_N|R_Fila_N], (L, C), Coord_N,Res):-
    El_Fila_I == El_Fila_N, C1 is C + 1,
    encontra_alteracoes_linhas(R_Fila_I, R_Fila_N, (L, C1), Coord_N,Res).

% Colunas

encontra_alteracoes_colunas([], [], (_, _), Res,Res):- !.

encontra_alteracoes_colunas([El_Fila_I|R_Fila_I], [El_Fila_N|R_Fila_N], (L, C), Coord_N,Res):-
    El_Fila_I \== El_Fila_N, L1 is L + 1,!,
    encontra_alteracoes_colunas(R_Fila_I, R_Fila_N, (L1, C), [(L, C)|Coord_N],Res).

encontra_alteracoes_colunas([El_Fila_I|R_Fila_I], [El_Fila_N|R_Fila_N], (L, C), Coord_N, Res):-
    El_Fila_I == El_Fila_N, L1 is L + 1,
    encontra_alteracoes_colunas(R_Fila_I, R_Fila_N, (L1, C), Coord_N, Res).


% Predicado auxiliar que verifica se existem variaveis e as suas posicoes

encontra_variavel([], _, []):-!.

encontra_variavel([Fila|_], L, Coord):- L1 is L + 1,
    encontra_variavel_fila(Fila, L1, 0, Coord), Coord \== [],  !.

encontra_variavel([_|R_Puzzle], L, Coord):- L1 is L + 1,
    encontra_variavel(R_Puzzle, L1, Coord).


encontra_variavel_fila([], _, _, []):- !.

encontra_variavel_fila([El|_], L, C, [(L, C1)]):-
    var(El), C1 is C + 1, !.

encontra_variavel_fila([El|R_Fila],L, C, Coord_N):-
    nonvar(El), C1 is C + 1,
    encontra_variavel_fila(R_Fila,L, C1, Coord_N).

nao_tem_variaveis([]):- !.

nao_tem_variaveis([El|R_Puzzle]):-
    number(El),
    nao_tem_variaveis(R_Puzzle).
    