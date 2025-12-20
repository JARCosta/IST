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


%                funcoes auxiliares
%-------------------------------------------------------------------------------
%                funcoes principais


combinacoes_soma(N,Els,Soma,Combs):-
    sort(Els,Sorted),
    findall(New, (combinacao(N,Sorted,New),sum_list(New,Soma)), Combs).


permutacoes_soma(N,Els,Soma,Perms):-
    findall(New,((combinacao(N,Els,All),permutation(All,New)),sum_list(All,Soma)),Permunsorted),
    sort(Permunsorted,Perms).

get_list(A, Ess,H_V) :-
(   H_V=h -> Index is 1;
    H_V=v -> Index is 0),
    findall(El,(  member(Ell,A),( (is_list(Ell),get_el(Ell,Index,El)) ; (not(is_list(Ell))) )  ),Ess).

%espaco_fila_aux([_,0|_],Esp,_):-
%    Esp.

espaco(_,_).
lol(Fila,H_V):-
    espaco(Fila,H_V).

print_espaco_fila(_,[Head|Resto],_):-
    Esp = espaco(Head,Resto).

espaco_fila_aux([V1,V2|Fila],Esp,H_V):-
(   ( integer(V1),not(V1=:=0) -> espaco_fila_aux([V2|Fila],[V1|Esp],H_V) );
    ( not(integer(V1)),integer(V2) -> ( Esp = espaco(V1,Esp);espaco_fila_aux([V2|Fila],[V1|Esp],H_V) ) );
    ( not(integer(V1)),not(integer(V2)) -> espaco_fila_aux([V2|Fila],[V1|Esp],H_V ) );
    ( espaco_fila_aux([V2|Fila],[],H_V) )
).



espaco_fila(Fila,Esp,H_V):-
    get_list(Fila,NewList,H_V),
    espaco_fila_aux(NewList,Esp,H_V).
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
/*



espaco_fila_listav([X1|_],[V|_],v):-
    get_el(X1,0,V).

espaco_fila_listah([X1|_],[V|_],h):-
    get_el(X1,1,V).

espaco_fila_nonval([X1|_],[V|_],_):-
    V is X1.

%espaco_fila_null([X1|_],_,_,End):-
%    is_list(X1),
%    is_null(X1,0),
%    End is 1.


espaco_fila_aux([],[Fst|Esp],_):-
    espaco(Fst,Esp).


espaco_fila_aux([X1,X2|Fila], [Fst|Esp], H_V):-
%   se for o ultimo _ preenchivel
    (not(is_list(X1)),     is_list(X2))  -> (
        espaco_fila_nonval([X1,X2|Fila], [Fst|Esp], H_V),
        espaco(Fst,Esp),
        [Fst|Esp] is []
    );

%   se for nao for o ultimo _
    (not(is_list(X1)), not(is_list(X2))) ->  espaco_fila_nonval([X1,X2|Fila], [Fst|Esp], H_V);

%   se for uma lista nao nula (espaco com valor da soma)
    (H_V=v, is_list(X1), is_null(X1,1)) -> espaco_fila_listav([X1,X2|Fila], [Fst|Esp], H_V);
    (H_V=h, is_list(X1), is_null(X1,1)) -> espaco_fila_listah([X1,X2|Fila], [Fst|Esp], H_V);



%   se for uma lista nula (espaco vazio)
%    (is_list(X1),is_null(X1,0)) -> espaco_fila_null(_, [Fst|Esp], _,1);

    
    espaco_fila([X2|Fila],[Fst|Esp],H_V).

espaco_fila([X1,X2|Fila], _, H_V):-
    espaco_fila_aux([X1,X2|Fila], [], H_V).

*/
