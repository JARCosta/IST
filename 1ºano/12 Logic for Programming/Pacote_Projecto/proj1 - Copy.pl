:- [codigo_comum].


% remake da funcao nth0(Lista de entrada, posicao do elemento, elemento isolado)
get_el([H|_],0,H):-!.
get_el([_|List],Index,El):-
    N is Index-1,
    get_el(List,N,El).


%                funcoes auxiliares
%-------------------------------------------------------------------------------
%                funcoes principais

% 3.1.1 Predicado combinacoes_soma/4
combinacoes_soma(N,Els,Soma,Combs):-
    % lista odenada com todas as combinacoes(setof) onde a soma dos seus elementos(sum_List) e igual a Soma
    setof(New, (combinacao(N,Els,New),sum_list(New,Soma)), Combs).


% 3.1.2 Predicado permutacoes_soma/4
permutacoes_soma(N,Els,Soma,Perms):-
    % lista odenada(sort) com todas as permutacoes (permutation) das combinacoes cuja soma e Soma
    findall(New,( (combinacao(N,Els,All),permutation(All,New)), sum_list(All,Soma) ),Permunsorted),
    sort(Permunsorted,Perms).


% 3.1.3 Predicado espaco_fila/2
espaco(_,_).

armazena([V1|Fila],Esp,[V1|Vars]):-
% guarda as variaveis correspondentes a Soma
    var(V1) ->!, armazena(Fila,Esp,Vars).

armazena(_,_,[]).

espaco_fila_aux([V1,V2|Fila],Esp,_,Soma,Vars):-
% caso V1 contenha o valor da Soma guarda o valor da soma, e chama armazena para guardar as variaveis
    is_list(V1),var(V2) -> Soma = V1, armazena([V2|Fila],Esp,Vars).

espaco_fila_aux([_,V2|Fila],Esp,H_V,Soma,Vars):-
% caso V1 seja uma casa vazia
    espaco_fila_aux([V2|Fila],Esp,H_V,Soma,Vars).

espaco_fila(Fila,Esp,H_V):-
% obtem Soma(Lista de 2 valores) e Vars
    espaco_fila_aux(Fila,Esp,H_V,Soma,Vars),
% consuante H_V=h ou v retorna 1o ou segundo elemento de Soma e as Vars(_)
(   H_V == h -> get_el(Soma,1,Sum), Esp = espaco(Sum,Vars);
    H_V == v -> get_el(Soma,0,Sum), Esp = espaco(Sum,Vars) ).


% 3.1.4 Predicado espacos_fila/2
espacos_fila(H_V,Fila,Espacos):-
    % lista(bagof) de todas as espaco_fila
    bagof(Esp,espaco_fila(Fila,Esp,H_V),Espacos).

espacos_fila(_,_,[]).


% 3.1.5 Predicado espacos_puzzle/2\
%obtem todas as esoaco_fila para todas as linhas do Puzzle, na vertical e horizontal
espacos_puzzle(Puzzle, Espacos):-
    % executa espacos_fila em todas as linhas na horizontal do Puzzle
    maplist(espacos_fila(h),Puzzle,Horizontais),
    mat_transposta(Puzzle,PuzzleT),
    % depois de transpor o Puzzle, executa espacos_fila na vertical
    maplist(espacos_fila(v),PuzzleT,Verticais),!,
    % agrupa ambos os resultados
    append(Horizontais,Verticais,Total),
    flatten(Total,Espacos).

% 3.1.6 Predicado espacos_com_posicoes_comuns/3
espacos_com_posicoes_comuns_aux([],_,[]).
espacos_com_posicoes_comuns_aux([Memb|Espacos], Esp, [Memb|Total]):-
    % procura todos os membros de Espacos que partilham alguma variavel com Esp
    Esp = espaco(_,Var),
    % se houver um Membro que contem alguma variavel iagual a Esp, e a lista de variaveis sao diferentes, armazena Membro
(   Memb = espaco(_,Vars),
    member(V1,Vars),
    member(V2,Var),
    V1==V2,
    not(Var == Vars)
),
    espacos_com_posicoes_comuns_aux(Espacos,Esp,Total).

espacos_com_posicoes_comuns_aux([_|Espacos], Esp, Total):-
    % caso contrario, ignora Membro
    espacos_com_posicoes_comuns_aux(Espacos,Esp,Total).

espacos_com_posicoes_comuns(Espacos, Esp, Members):-
    espacos_com_posicoes_comuns_aux(Espacos, Esp, Members).



% 3.1.7 Predicado permutacoes_soma_espacos/2
% obtem uma lista de espacos e suas permutacoes possiveis
permutacoes_soma_espacos_aux([],[]).
permutacoes_soma_espacos_aux([Memb|Espacos], [Final|Total]):-
    % para cada espaco em Espacos
    Memb = espaco(Soma,Var),
    length(Var,Len),
    % obtem a lista de permutacoes possiveis naquele tamanho de espaco e soma
    bagof(El,permutacoes_soma(Len,[1,2,3,4,5,6,7,8,9],Soma,El),Membi),
    % devolve uma lista de [Espaco n , Permutacoes possiveis]
    Final = [Memb|Membi],
    permutacoes_soma_espacos_aux(Espacos,Total).

permutacoes_soma_espacos(Espacos, Perms_soma):-
    permutacoes_soma_espacos_aux(Espacos,Perms_soma).


% 3.1.8 Predicado permutacao_possivel_espaco/4

filtra_espacos_comuns(_,_,[],[]).
                                                            % obtem uma lista de espacos com posicoes comuns a Esp
filtra_espacos_comuns(Esp,Espacos,[Fst|Perms_soma],[Fst|Perms_Coms]):-
    espacos_com_posicoes_comuns(Espacos,Esp,Esps_com),
    get_el(Fst,0,El),
    member(El,Esps_com),
    filtra_espacos_comuns(Esp,Espacos,Perms_soma,Perms_Coms).

filtra_espacos_comuns(Esp,Espacos,[_|Perms_soma],Perms_Coms):-
    filtra_espacos_comuns(Esp,Espacos,Perms_soma,Perms_Coms).

%--------------------------------
intersecao_espacos_aux([]).
intersecao_espacos_aux([Fst|Permsss]):-
                                        % verifica se Esp e possivel se Fst = permutacao escolhida pelo forall
    Fst = [espaco(_,Vars)|Resto],
    member(Perms,Resto),
    findall(Ell,(member(Ell,Perms),subsumes_term(Vars,Ell)),ListaPerms),
    not(ListaPerms = []),
    intersecao_espacos_aux(Permsss).

%-------------
intersecao_espacos(Esp,[Fst|_],Perms_Coms,Fst):-
    Esp = espaco(_,Vars),
    % para todas as permutacoes possiveis dos espacos comuns a Esp,
    %verifica quais sao possiveis (ex: 11 =\= 1+1+9 pois no Puzzle numeros nao se podem repetir na mesma soma)
    forall(Vars=Fst,intersecao_espacos_aux(Perms_Coms)).

intersecao_espacos(Esp,[_|Perms],Perms_Coms,Perm):-
    intersecao_espacos(Esp,Perms,Perms_Coms,Perm).

%--------------------------------
permutacao_possivel_espaco(Perm, Esp, Espacos, Perms_soma):-
    filtra_espacos_comuns(Esp,Espacos,Perms_soma,Perms_Coms),!,
    Esp = espaco(Soma,Vars),
    length(Vars,L),
                                % obtem uma lista de todas permutacoes dos espacos com posicoes comuns a Esp
    permutacoes_soma(L,[1,2,3,4,5,6,7,8,9],Soma,Perms),
    intersecao_espacos(Esp,Perms,Perms_Coms,Perm).

% 3.1.9 Predicado permutacoes_possiveis_espaco/4
permutacoes_possiveis_espaco(Espacos, Perms_soma, Esp,Perms_poss):-
    Esp = espaco(_,Vars),
    % obtem todas as permutacoes de Esp possiveis obtidas pelo predicado 8
    bagof(Perm,permutacao_possivel_espaco(Perm,Esp,Espacos,Perms_soma),Perms),
    Perms_poss = [Vars,Perms].

% 3.1.10 Predicado permutacoes_possiveis_espacos/2
permutacoes_possiveis_espacos(Espacos, Perms_poss_esps):-
    % para todos os espacos de Espacos cria a lista [espaco , permutacoes obtidas pelo predicado 9] e agrupa todas numa
    permutacoes_soma_espacos(Espacos, Perms_soma),
    maplist(permutacoes_possiveis_espaco(Espacos,Perms_soma),Espacos,Perms_poss_esps).

% 3.1.11 Predicado numeros_comuns/2
remove_lastEl([X|Xs], Ys):-             % funcao auxiliar que elimina o ultimo elemento de uma lista
   remove_lastEl_prev(Xs, Ys, X).
remove_lastEl_prev([], [], _).
remove_lastEl_prev([X1|Xs], [X0|Ys], X0) :-  
   remove_lastEl_prev(Xs, Ys, X1).


numNumerosIguaisInList([],_,0).         % funcao auxiliar que conta o numero de elementos iguais numa lista
numNumerosIguaisInList([H|List],Val,Qnt):-
    numNumerosIguaisInList(List,Val,Qnt1),
(   Val = H -> Qnt is Qnt1+1;
    Qnt is Qnt1).

numeros_comuns_aux(Line, New,Pos):-
    % obtem os elementos de Line na posicao Pos
    findall(El, (member(List,Line), get_el(List,Pos,El) ),ElsInPos),
    get_el(ElsInPos,0,ValTemp),
    numNumerosIguaisInList(ElsInPos,ValTemp,QntTemp), % verifica se todos os elementos da ista na posicao Pos sao iguais,
                                                      % eleminando os elementos que sao diferentes do 1o da lista ElsInPos
    Pos1 is Pos + 1,
    (length(Line,QntTemp) -> get_el(ElsInPos,0,NewEl), New = (Pos1,NewEl) ).


numeros_comuns_repeating(_,_,L,H):- L>=H,!.
numeros_comuns_repeating(Line,News,Inicio,Fim):-
    bagof(El,numeros_comuns_aux(Line,El,Inicio),News); 
                                            % agrupa todos os elementos que sao comuns na Posicao Inicio, ate Inicio = Fim
    Inicio1 is Inicio + 1,
    numeros_comuns_repeating(Line,News,Inicio1,Fim).


numeros_comuns(Line,Numeros_comuns):-
    get_el(Line,0,Fst),
    length(Fst,Len),
    findall(El,(numeros_comuns_repeating(Line,El,0,Len)),Nums), 
                                                 % agrupa todos os elementos que sao comuns (testa em todas as posicoes)
    flatten(Nums,Nums2),
    remove_lastEl(Nums2,Numeros_comuns).


% 3.1.12 Predicado atribui_comuns/1

atribui_comuns_aux_aux(_,[]).
atribui_comuns_aux_aux(Esp, [Fst|Numeros_comuns]):-
    Fst=(Pos, Ell),
    Pos1 is Pos - 1,
    get_el(Esp,Pos1,Ell),                               % seta o valor do espaco comum com o valor comum
    atribui_comuns_aux_aux(Esp,Numeros_comuns).

atribui_comuns_aux([]).
atribui_comuns_aux([Fst|Perms_Possiveis]):-             % para todas as permutacoes possiveis
    get_el(Fst,0,Esp),
    get_el(Fst,1,Perms),
    numeros_comuns(Perms,Numeros_comuns),               % obtem os espacos com numeros comuns
    atribui_comuns_aux_aux(Esp,Numeros_comuns),         % e da o valor do numero comum ao espaco comun
    atribui_comuns_aux(Perms_Possiveis).

atribui_comuns_aux([_|Perms_Possiveis]):-
    atribui_comuns_aux(Perms_Possiveis).

atribui_comuns(Perms_Possiveis):-
    atribui_comuns_aux(Perms_Possiveis).

% 3.1.13 Predicado retira_impossiveis/2
retira_impossiveis_aux([],[]).
retira_impossiveis_aux([Fst|Perms_Possiveis],[RealPerms|Novas_Perms_Possiveis]):-
    get_el(Fst,0,Esp),
    get_el(Fst,1,Perms),                                    
                            % recebe todos os espacos ja com numeros comuns,
    findall(Ell,(member(Ell,Perms),subsumes_term(Esp,Ell)),NewPerms),  
                                        % filtra as permutacoes que respeitam esse espaco comum
    RealPerms = [Esp,NewPerms],
    retira_impossiveis_aux(Perms_Possiveis,Novas_Perms_Possiveis).

retira_impossiveis(Perms_Possiveis,Novas_Perms_Possiveis):-
    retira_impossiveis_aux(Perms_Possiveis,Novas_Perms_Possiveis).


% 3.1.14 Predicado simplifica/2
simplifica(Perms_Possiveis, Novas_Perms_Possiveis):-        % recebe Espacos com permutacoes
    atribui_comuns(Perms_Possiveis),                        % analisa os espacos comuns e aplica para as "_"
    retira_impossiveis(Perms_Possiveis,Novas_Perms_Possiveis). % filtra as permutacoes que respeitam os espacos comuns

% 3.1.15 Predicado inicializa/2
inicializa(Puzzle, Perms_Possiveis):-
    espacos_puzzle(Puzzle,Espacos),                     % obtem a lista de Espacos
    permutacoes_possiveis_espacos(Espacos,Perms),       % obtem a lista de espacos com as suas permutacoes
    simplifica(Perms,Old_Perms_Possiveis),              % filtra os espacos comuns e as permutacoes respetivas
    simplifica(Old_Perms_Possiveis,Perms_Possiveis).
                                                    % teoricamente funcionaria, mas excede o tempo limite de execucao

