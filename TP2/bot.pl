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

printList([]).

printList([X|List]):-
    write(X),nl,
    printList(List).

testAllOctos(63, Player, List, Newlist):-
    ((checkFinalMove(63, Player), append(List, [63], Newlist));append(List, [], Newlist)).


testAllOctos(X, Player, List, Newlist):-
    ((checkFinalMove(X, Player), append(List, [X], Newlist2));append(List, [], Newlist2)),
    X1 is X+1, X =< 63,!,
    testAllOctos(X1, Player, Newlist2, Newlist).

smartPlay(Player):-
    testAllOctos(0,Player,X,A),
    printList(A),
    A \== [],
    random_member(ID, A),
    octo(ID, Row, Col,_,_,_,_,_),
    placePiece(Player, Row, Col).

smartPlay(Player):-
    randomPlay(Player).

checkFinalMove(ID,Player):-
    octo(ID,Row, Col,Piece,A,B,C,D),
    Piece = .,
    square(A,G,H,S1),
    square(B,I,J,S2),
    square(C,K,L,S3),
    square(D,M,N,S4),
    turn(T),
    placePiece(Player,Row,Col),
    ((\+game_over(_,X),
    retractall(edge(ID,_)),
    retractall(edge(_,ID)),
    replaceFact(octo(ID,Row,Col,Player,Q,W,E,R),octo(ID,Row,Col,.,Q,W,E,R)), 
    replaceFact(end(_),end(0)),
    replaceFact(turn(_), turn(T)),
    replaceFact(square(A,_,_,_),  square(A,G,H,S1)),
    replaceFact(square(B,_,_,_),  square(B,I,J,S2)),
    replaceFact(square(C,_,_,_),  square(C,K,L,S3)),
    replaceFact(square(D,_,_,_),  square(D,M,N,S4)), fail);
    (game_over(_,X),
    retractall(edge(ID,_)),
    retractall(edge(_,ID)),
    replaceFact(octo(ID,Row,Col,Player,Q,W,E,R),octo(ID,Row,Col,.,Q,W,E,R)), 
    replaceFact(end(_),end(0)), 
    replaceFact(turn(_), turn(T)), 
    replaceFact(square(A,_,_,_),  square(A,G,H,S1)), 
    replaceFact(square(B,_,_,_),  square(B,I,J,S2)), 
    replaceFact(square(C,_,_,_),  square(C,K,L,S3)), 
    replaceFact(square(D,_,_,_),  square(D,M,N,S4)))).

    
    