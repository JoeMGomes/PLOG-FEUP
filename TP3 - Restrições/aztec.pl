:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).

appendlist([], Final, Final).

appendlist([H|T], List, Final) :-
    append(List,H, NewList),
    appendlist(T, NewList, Final).

aztec(List) :-
    appendlist(List, [], NewList),
    aux_aztec(List),
    catch(labeling([max_regret], NewList),_,fail).

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

nTabs(0).
nTabs(X):-
    write(' '),
    X1 is X-1,
    nTabs(X1).

displayPuzzle(List):-
    length(List, Size),
    NewSize is Size -1,!, nl,
    displayPuzzleAux(List, NewSize).
    

displayPuzzleAux([],_):-
    nl.

displayPuzzleAux([Line| List], Size):-
    nTabs(Size),
    write(Line), nl,
    NewSize is Size -1, !,
    displayPuzzleAux(List, NewSize).

randOrAtom(C):-
    maybe(0.2) -> random(0,10,C); true.

createPyramid(Size, CurrLevel, Board, FinalBoard):-
    CurrLevel =< Size,
    length(Row, CurrLevel), maplist(randOrAtom, Row),
    append(Board,[Row], Pyramid),
    NextLevel is CurrLevel + 1,
    createPyramid(Size, NextLevel, Pyramid, FinalBoard).

createPyramid(_,_,FinalBoard, FinalBoard).

try(Size, Res):-
    createPyramid(Size, 1, [], Board),
    findall(Board, aztec(Board), Possible),
    length(Possible, 1),
    length(Board, Size),    
    append(Board,[], Res).

generate(Size, Board):-
    reset_timer,
    repeat,
    try(Size, Board),
    print_time,
    fd_statistics.

reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.

puzzle(1, [[4], [_, _], [8, _, 3], [_, _, _, _], [1, _, 5, _, 6]]).
puzzle(2, [[7], [_, _], [_, _, 9], [2, _, _, _], [_, _, _, 7, _],[4,_,1,_,_,5]]).
puzzle(3, [[9], [_, _], [_, 8, _], [5, _, _, 6], [_, _, _, _, _],[2,_,_,3,_,5]]).
puzzle(4, [[6], [_, _], [4, _, 8], [_, _, _, _], [_, _, _, 1, _],[2,_,7,_,_,4]]).
