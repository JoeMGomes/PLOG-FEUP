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

smartPlay(Player):-
    bagof(ID, checkFinalMove(ID,Player), List),
    write(List).

checkFinalMove(ID,Player):-
    octo(ID,Row, Col,_,A,B,C,D),
    square(A,_,_,S1),
    square(B,_,_,S2),
    square(C,_,_,S3),
    square(D,_,_,S4),
    turn(T),
    placePiece(Player,Row,Col),
    game_over(_,X),
    X \== 0,
    retractall(edge(ID,_)),
    retractall(edge(_,ID)),
    replaceFact(octo(ID,Row,Col,Player,Q,W,E,R),octo(ID,Row,Col,.,Q,W,E,R)),
    replaceFact(end(_),end(0)),
    replaceFact(turn(_), turn(T)),
    replaceFact(square(A,_,_,_),  square(A,_,_,S1)),
    replaceFact(square(B,_,_,_),  square(B,_,_,S2)),
    replaceFact(square(C,_,_,_),  square(C,_,_,S3)),
    replaceFact(square(D,_,_,_),  square(D,_,_,S4)).
    