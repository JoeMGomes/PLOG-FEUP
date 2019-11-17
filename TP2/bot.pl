:- consult('data.pl').
:- consult('logic.pl').
:- use_module(library(lists)).
:- use_module(library(random)).

isNotUsed(Id):-
	octo(Id,_,_,X,_,_,_,_),
	(X = '.').

valid_moves(+Board, +Player, ListOfMoves):-
    findall(X, octo(X,_,_,'.',_,_,_,_), ListOfMoves).

randomPlay(Player):-
    valid_moves(_,_,List),
    random_member(M, List),
    octo(M, Row, Col,_,_,_,_,_),
    placePiece(Player, Row, Col).

appendToList(List, Item):-
    List = [Start|[To_add|Rest]],
    nonvar(Start),
    (var(To_add), To_add=Item;appendToList([To_add|Rest], Item)).


testAllOctos(63, Player, List):-
    ((checkFinalMove(63, Player), appendToList(List, 63));true).


testAllOctos(X, Player, List):-
    ((checkFinalMove(X, Player), appendToList(List, X));true),
    X1 is X+1, X < 63,
    testAllOctos(X1, Player, List).


smartPlay(Player):-
    bagof(ID, checkFinalMove(ID,Player), List),
    write(List).

checkFinalMove(ID,Player):-
    octo(ID,Row, Col,Piece,A,B,C,D),
    Piece = .,
    square(A,_,_,S1),
    square(B,_,_,S2),
    square(C,_,_,S3),
    square(D,_,_,S4),
    turn(T),
    placePiece(Player,Row,Col),
    ((\+game_over(_,X),
    retractall(edge(ID,_)),
    retractall(edge(_,ID)),
    replaceFact(octo(ID,Row,Col,Player,Q,W,E,R),octo(ID,Row,Col,.,Q,W,E,R)),
    replaceFact(end(_),end(0)),
    replaceFact(turn(_), turn(T)),
    replaceFact(square(A,_,_,_),  square(A,_,_,S1)),
    replaceFact(square(B,_,_,_),  square(B,_,_,S2)),
    replaceFact(square(C,_,_,_),  square(C,_,_,S3)),
    replaceFact(square(D,_,_,_),  square(D,_,_,S4)), fail);
    (game_over(_,X),
    retractall(edge(ID,_)),
    retractall(edge(_,ID)),
    replaceFact(octo(ID,Row,Col,Player,Q,W,E,R),octo(ID,Row,Col,.,Q,W,E,R)),
    replaceFact(end(_),end(0)),
    replaceFact(turn(_), turn(T)),
    replaceFact(square(A,_,_,_),  square(A,_,_,S1)),
    replaceFact(square(B,_,_,_),  square(B,_,_,S2)),
    replaceFact(square(C,_,_,_),  square(C,_,_,S3)),
    replaceFact(square(D,_,_,_),  square(D,_,_,S4)))).
    