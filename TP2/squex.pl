:- consult('data.pl').

oformatLine(X,7):-
	octo(X,7,C,_,_,_,_), format('~a   ', [C]).

oformatLine(X,Y):-
	octo(X,Y,C,_,_,_,_), format('~a   ', [C]),
	 Y1 is Y+1, Y1 < 8, oformatLine(X,Y1).	

oformatBoard(7):-
	write('@   '),oformatLine(7,0), write('@'), nl.

oformatBoard(X):-
	write('@   '), oformatLine(X,0), write('@'), nl,
	X1 is X+1, X1 < 8,
	write('@   '),oformatSquare(X,0),write('    @'), nl,
	oformatBoard(X1).

oformatSquare(S,6):-
	square(_,S,6,C), format('  ~a ', [C]).

oformatSquare(S,R):-
	square(_,S,R,C), format('  ~a ', [C]),
	 R1 is R+1, R1 < 7, oformatSquare(S,R1).	

display_game(+Board,+Player):-
	write('    0   1   2   3   4   5   6   7'),nl,
	write('    b b b b b b b b b b b b b b b'),nl,nl,
	oformatBoard(0), nl,
	write('    b b b b b b b b b b b b b b b').

replaceFact(OldFact, NewFact) :-
(   call(OldFact)
->  retract(OldFact),
	assertz(NewFact);
	true
).

isUsed(Row, Col):-
	octo(Row, Col,X,_,_,_,_),
	\+ (X = '.').

checkCorner(Player, Row, Col):-
	octo(Row,Col,X,_,_,_,_),
	X = Player.

placeSquareCE(Player, Row, Col):-
	R1 is Row-1, C1 is Col-1,
	checkCorner(Player, R1,C1),
	octo(Row,Col,_,X,_,_,_),
	replaceFact(square(X,_,_,_),square(X,_,_,Player)).
placeSquareCD(Player, Row, Col):-
	R1 is Row-1, C1 is Col+1,
	checkCorner(Player, R1,C1),
	octo(Row,Col,_,_,X,_,_),
	replaceFact(square(X,_,_,_),square(X,_,_,Player)).
placeSquareBE(Player, Row, Col):-
	R1 is Row+1, C1 is Col-1,
	checkCorner(Player, R1,C1),
	octo(Row,Col,_,_,_,X,_),
	replaceFact(square(X,_,_,_),square(X,_,_,Player)).
placeSquareBD(Player, Row, Col):-
	R1 is Row+1, C1 is Col+1,
	checkCorner(Player, R1,C1),
	octo(Row,Col,_,_,_,_,X),
	replaceFact(square(X,_,_,_),square(X,_,_,Player)).


placeSquares(Player, Row, Col):-
	(placeSquareCE(Player, Row, Col);true),
	(placeSquareCD(Player, Row, Col);true),
	(placeSquareBE(Player, Row, Col);true),
	(placeSquareBD(Player, Row, Col);true).

placePiece(Player, Row, Col):-
	(Player = 'b' ; Player = '@'),
	\+isUsed(Row, Col),
	replaceFact(octo(Row, Col,X,A,B,C,D),octo(Row, Col,Player,A,B,C,D)),
	placeSquares(Player,Row,Col).

