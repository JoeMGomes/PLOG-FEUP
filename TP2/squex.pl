:- consult('data.pl').

oformatLine(X,7):-
	octo(_,X,7,C,_,_,_,_), format('~a   ', [C]).

oformatLine(X,Y):-
	octo(_,X,Y,C,_,_,_,_), format('~a   ', [C]),
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
	octo(_,Row, Col,X,_,_,_,_),
	\+ (X = '.').

checkCorner(Player, Row, Col):-
	octo(_,Row,Col,X,_,_,_,_),
	X = Player.

checkCut(SquareID,Player):-
	square(SquareID,A,B,S),
	(S \== Player , S \== x)->(
	turn(T),	
	T1 is T * -3,
	replaceFact(turn(T), turn(T1))
	).

placeSquareCE(Player, Row, Col):-
	R1 is Row-1, C1 is Col-1,
	checkCorner(Player, R1,C1),
	octo(_,Row,Col,_,X,_,_,_),
	(checkCut(X,Player);true),
	replaceFact(square(X,A,B,_),square(X,A,B,Player)).
placeSquareCD(Player, Row, Col):-
	R1 is Row-1, C1 is Col+1,
	checkCorner(Player, R1,C1),
	octo(_,Row,Col,_,_,X,_,_),
	(checkCut(X,Player);true),
	replaceFact(square(X,A,B,_),square(X,A,B,Player)).
placeSquareBE(Player, Row, Col):-
	R1 is Row+1, C1 is Col-1,
	checkCorner(Player, R1,C1),
	octo(_,Row,Col,_,_,_,X,_),
	(checkCut(X,Player);true),
	replaceFact(square(X,A,B,_),square(X,A,B,Player)).
placeSquareBD(Player, Row, Col):-
	R1 is Row+1, C1 is Col+1,
	checkCorner(Player, R1,C1),
	octo(_,Row,Col,_,_,_,_,X),
	(checkCut(X,Player);true),
	replaceFact(square(X,A,B,_),square(X,A,B,Player)).


placeSquares(Player, Row, Col):-
	placeSquareCE(Player, Row, Col);true,
	placeSquareCD(Player, Row, Col);true,
	placeSquareBE(Player, Row, Col);true,
	placeSquareBD(Player, Row, Col);true.

placePiece(Player, Row, Col):-
	\+isUsed(Row, Col),
	replaceFact(octo(_,Row, Col,_,A,B,C,D),octo(_,Row, Col,Player,A,B,C,D)),
	placeSquares(Player,Row,Col).


play(Row, Col):-
	turn(X),
	(X =< 0 ->
		(
			placePiece('b', Row, Col),
			(turn(X), X =< 0 ->
			(N is X+2,
			replaceFact(turn(X), turn(N)));true
			)
		)
	;	
		(	
			placePiece('@', Row, Col),
			(turn(X), X >= 0 ->
			(N is X-2,
			replaceFact(turn(X), turn(N)));true
			)
		)
	),
	display_game(_,_).



floodWhite(Row, Col):-
	octo(Id,Row, Col , Player, C1, C2, C3, C4),
	Player = '@', !,
	visited(Id, X),
	end(E),
	write(E),nl,
	X = 0,
	replaceFact(visited(Id,_), visited(Id, 1)),
	(Col = 7 ->
		replaceFact(end(_), end(1)),
		write("@ wins!")
	;
	R is Row+1,
	C is Col,
	floodWhite(N, C),
	R is Row-1,
	C is Col,
	floodWhite(N, C),
	R is Row,
	C is Col+1,
	floodWhite(N, C),
	R is Row,
	C is Col-1,
	floodWhite(N, C),

	(\+(C1 = 'nn') ->
		(square(C1,_,_,S1),
		S1 = '@' ->
		R is Row-1,
		C is Col-1,
		floodWhite(R,C)
		)),

	(\+(C2 = 'nn') ->
		(square(C2,_,_,S2),
		S2 = '@' ->
		R is Row-1,
		C is Col+1,
		floodWhite(R,C)
		)),
	
	(\+(C3 = 'nn') ->
		(square(C3,_,_,S3),
		S3 = '@' ->
		R is Row+1,
		C is Col-1,
		floodWhite(R,C)
		)),

	(\+(C4 = 'nn') ->
		(square(C4,_,_,S4),
		S4 = '@' ->
		R is Row+1,
		C is Col+1,
		floodWhite(R,C)
		))
    ). 
	

	

