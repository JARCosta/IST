:- [codigo_comum].


soma_lista([],0).
soma_lista([Head|Tail],Res):-
    soma_lista(Tail,NewRes),
    Res is Head + NewRes.

get_el([H|_],0,H).
get_el([_|List],Index,El):-
    N is Index-1,
    get_el(List,N,El).


is_null(Lst,Bulian):-
    findall(El,(member(El,Lst),El==0),New),
    length(Lst) = length(New) -> 
    Bulian is 0;
    Bulian is 1.

get_list([H|Lista], H_V, [New|Res]):-
    is_list(H),
(   H_V=h -> Index is 1;
    H_V=v -> Index is 0),  
    get_el(H,Index,New),
    get_list(Lista,H_V,Res).

get_list([H|Lista], H_V, [H|Res]):-
    not(is_list(H)),
    get_list(Lista,H_V,Res).

%                funcoes auxiliares
%-------------------------------------------------------------------------------
%                funcoes principais

% 3.1.1 Predicado combinacoes_soma/4
combinacoes_soma(N,Els,Soma,Combs):-
    setof(New, (combinacao(N,Els,New),sum_list(New,Soma)), Combs).


% 3.1.2 Predicado permutacoes_soma/4
permutacoes_soma(N,Els,Soma,Perms):-
    findall(New,( (combinacao(N,Els,All),permutation(All,New)), sum_list(All,Soma) ),Permunsorted),
    sort(Permunsorted,Perms).


% 3.1.3 Predicado espaco_fila/2
espaco(_,_).

armazena([V1|Fila],Esp,[V1|Vars]):-
    var(V1) ->!, armazena(Fila,Esp,Vars).

armazena(_,_,[]).

espaco_fila_aux([V1,V2|Fila],Esp,_,Soma,Vars):-
    is_list(V1),var(V2) -> Soma = V1, armazena([V2|Fila],Esp,Vars).

espaco_fila_aux([_,V2|Fila],Esp,H_V,Soma,Vars):-
    espaco_fila_aux([V2|Fila],Esp,H_V,Soma,Vars).

espaco_fila(Fila,Esp,H_V):-
    espaco_fila_aux(Fila,Esp,H_V,Soma,Vars),
(   H_V == h -> get_el(Soma,1,Sum), Esp = espaco(Sum,Vars);
    H_V == v -> get_el(Soma,0,Sum), Esp = espaco(Sum,Vars) ).


% 3.1.4 Predicadoespacos_fila/2
espacos_fila(H_V,Fila,Espacos):-
    bagof(Esp,espaco_fila(Fila,Esp,H_V),Espacos).


% 3.1.5 Predicadoespacos_puzzle/2
espacos_puzzle([Fila|Puzzle], Espacos):-
    bagof(New, espaco_fila(Fila,New,h), Espacos).
