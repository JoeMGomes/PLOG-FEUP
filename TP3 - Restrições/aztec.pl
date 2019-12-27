:- use_module(library(clpfd)).

puzzle(1, [[2], [_, _], [7, _, 6], [_, _, _, _], [4, _, 5, _, 3]]).

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
    math_constraint(H, H1, H2),
    constraints_list(List1, [H2 | List2]).

math_constraint(H, H1, H2) :-
    H #= H1 + H2.

math_constraint(H, H1, H2) :-
    H #= abs(H1 - H2).

math_constraint(H, H1, H2) :-
    H #= H1 * H2.

math_constraint(H, H1, H2) :-
    H1 #> H2,
    0 #= mod(H1, H2),
    H #= H1 / H2.

math_constraint(H, H1, H2) :-
    H1 #< H2,
    0 #= mod(H2, H1),
    H #= H2 / H1.


