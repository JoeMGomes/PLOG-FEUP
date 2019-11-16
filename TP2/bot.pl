:- consult('data.pl').
:- consult('logic.pl').
:- use_module(library(lists)).
:- use_module(library(random)).

isNotUsed(Id):-
	octo(Id,_,_,X,_,_,_,_),
	(X = '.').





randomPlay(Player):-
    findall(X, octo(X,_,_,'.',_,_,_,_), List),
    random_member(M, List),
    octo(M, Row, Col,_,_,_,_,_),
    placePiece(Player, Row, Col).