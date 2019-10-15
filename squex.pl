:- consult('data.pl').

oformatLine(X,7):-
	octo(X,7,C,_,_,_,_), format('~a   ', [C]).

oformatLine(X,Y):-
	octo(X,Y,C,_,_,_,_), format('~a   ', [C]),
	 Y1 is Y+1, Y1 < 8, oformatLine(X,Y1).	

oformatBoard(7):-
	write('a   '),oformatLine(7,0), write('a'), nl.

oformatBoard(X):-
	write('a   '), oformatLine(X,0), write('a'), nl,
	X1 is X+1, X1 < 8,
	write('a   '),oformatSquare(X,0),write('    a'), nl,
	oformatBoard(X1).

oformatSquare(S,6):-
	square(_,S,6,C), format('  ~a ', [C]).

oformatSquare(S,R):-
	square(_,S,R,C), format('  ~a ', [C]),
	 R1 is R+1, R1 < 7, oformatSquare(S,R1).	
