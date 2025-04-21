:- [codigo_comum, puzzles_publicos].


soma_lista([],0).
soma_lista([Head|Tail],Res):-
    soma_lista(Tail,NewRes),
    Res is Head + NewRes.


get_el([E1,_],v,E1).
get_el([_,E2],h,E2).


is_null(Lst):-
    findall(El,(member(El,Lst),El==0),New),
    length(Lst) = length(New).

len_lista_com_listas([],_).
len_lista_com_listas([_|List],Len):-
    len_lista_com_listas(List,Len+1).

reverse_list([],[]).
reverse_list([H|Lst],Res):-
    reverse_list(Lst,[H|Res]).
%                funcoes auxiliares
%-------------------------------------------------------------------------------
%                funcoes principais


combinacoes_soma(N,Els,Soma,Combs):-
    sort(Els,Sorted),
    findall(New, (combinacao(N,Sorted,New),sum_list(New,Soma)), Combs).


permutacoes_soma(N,Els,Soma,Perms):-
    findall(New,((combinacao(N,Els,All),permutation(All,New)),sum_list(All,Soma)),Permunsorted),
    sort(Permunsorted,Perms).

/*
espaco_fila([X1,X2|Fila],Esp,v):-
(   is_list(X1) ->
        get_el(X,0,H),
        espaco_fila([X2|Fila],[H|Esp],v);
    is_val(X1),is_val(X2) ->
        H is X1,
        espaco_fila([X2|Fila],[H|Esp],v);
    is_val(X1),is_val(X2) ->
        H is X1,
        espaco_fila([X2|Fila],NewEsp,v);
)
    espaco_fila(Fila,[H|Esp],v).


espaco_fila([X1,X2|Fila],Esp,h):-
(   is_list(X1) ->
        get_el(X,1,H),
        espaco_fila([X2|Fila],[H|Esp],h);
    is_val(X1),is_val(X2) ->
        H is X1,
        espaco_fila([X2|Fila],[H|Esp],h);
    is_val(X1),is_val(X2) ->
        H is X1,
        espaco_fila([X2|Fila],NewEsp,h);
)
    espaco_fila(Fila,[H|Esp],h).
*/


espaco(_,_).

add_fim_lista(X1,Lista,Res):-
    findall(N,member(N,Lista),ListaInvertida),
    findall(M,member(M,[X1|ListaInvertida]),Res).

get_1st_el([Fst|List],Fst,List).

espaco_fila([],[Fst|Esp],_):-
        Esp = espaco(Fst,Esp).



espaco_fila([X1,X2|Fila], Esp, H_V):-
%    length([X1,X2|Fila],Len),
%    Len>2,
    % se elemento a observar for uma lista nao nula (is_null([0,0])=true , is_null([])=true)
    (is_list(X1), not(is_null(X1))) -> ( 
        get_el(X1,H_V,El),
        add_fim_lista(El,Esp,NewEsp)
        );

    % se elemento a observar for a ultima casa vazia (is_list([])=true)
    (not(is_list(X1)),is_list(X2)) -> ( 
        add_fim_lista(X1,Esp,NewEsp),
        get_1st_el(Esp,Fst,Lista),
        Esp = espaco(Fst,Lista)
        );
    
    % se elemento a observar for uma casa vazia e houver outra casa vazia aseguir
    (not(is_list(X1)),not(is_list(X2))) -> add_fim_lista(X1,Esp,NewEsp);
    espaco_fila([X2|Fila],NewEsp,H_V).

