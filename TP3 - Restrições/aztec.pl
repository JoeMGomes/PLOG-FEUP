:- use_module(library(clpfd)).

appendlist([], Final, Final).

appendlist([H|T], List, Final) :-
    append(List,H, NewList),
    appendlist(T, NewList, Final).

aztec(List) :-
    appendlist(List, [], NewList),
    aux_aztec(List),
    labeling([], NewList).

aux_aztec([H|[]]).

aux_aztec([List|[ List1 | List2]]) :-
    constraints_list(List, List1),
    aux_aztec([List1 | List2]).

constraints_list([], List1).

constraints_list([H|List1], [H1 | [H2 | List2]]) :-
    H in 1..9, H1 in 1..9, H2 in 1..9,
    all_different([H|List1]),
    all_different([H1 | [H2 | List2]]),
    (H #= H1 + H2 #\/ %SOMA
    H #= abs(H1 - H2) #\/ %SUBTRAÇÃO
    H #= H1 * H2 #\/ % MULTIPLICAÇÃO
    ( H1 #> H2 #/\ 0 #= mod(H1, H2) #/\ H #= H1 / H2) #\/ % DIVISÂO LEFT RIGHT
    ( H1 #< H2 #/\ 0 #= mod(H2, H1) #/\ H #= H2 / H1)), % DIVISÃO RIGHt LEFT
    constraints_list(List1, [H2 | List2]).

puzzle(1, [[4], [_, _], [8, _, 3], [_, _, _, _], [1, _, 5, _, 6]]).

nTabs(0).
nTabs(X):-
    write(' '),
    X1 is X-1,
    nTabs(X1).

displayPuzzle(List):-
    length(List, Size),
    NewSize is Size -1,!,
    displayPuzzleAux(List, NewSize).
    

displayPuzzleAux([],_):-
    nl.

displayPuzzleAux([Line| List], Size):-
    nTabs(Size),
    write(Line), nl,
    NewSize is Size -1, !,
    displayPuzzleAux(List, NewSize).