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
	write('    0   1   2   3   4   5   6   7'),nl,
	write('    b b b b b b b b b b b b b b b'),nl,nl,
	oformatBoard(0), nl,
	write('    b b b b b b b b b b b b b b b'), nl.
	

replaceFact(OldFact, NewFact) :-
(   call(OldFact)
->  retract(OldFact),
	assertz(NewFact);
	true
).

isUsed(Row, Col):-
	octo(_,Row, Col,X,_,_,_,_),
	\+ (X = '.').

checkOcto(Player, Row, Col):-
	octo(_,Row,Col,X,_,_,_,_),
	X = Player.

checkCut(SquareID,Player, ID1,ID2):-
	square(SquareID,_,_,S),
	(S \== Player , S \== x)->(
	turn(T),	
	T1 is T * -3,
	replaceFact(turn(T), turn(T1)),
	removeEdge(ID1,ID2)
	).

placeSquareCE(Player, Row, Col):-
	R1 is Row-1, C1 is Col-1,
	checkOcto(Player, R1,C1),
	octo(ID,Row,Col,_,X,_,_,_),
	octo(ID1,R1,C1,_,_,_,_,_),
	octo(ID2,Row,C1,_,_,_,_,_),
	octo(ID3,R1,Col,_,_,_,_,_),
	addEdge(ID, ID1),
	(checkCut(X,Player,ID2,ID3);true),
	replaceFact(square(X,A,B,_),square(X,A,B,Player)).
placeSquareCD(Player, Row, Col):-
	R1 is Row-1, C1 is Col+1,
	checkOcto(Player, R1,C1),
	octo(ID,Row,Col,_,_,X,_,_),
	octo(ID1,R1,C1,_,_,_,_,_),
	octo(ID2,Row,C1,_,_,_,_,_),
	octo(ID3,R1,Col,_,_,_,_,_),
	addEdge(ID, ID1),
	(checkCut(X,Player,ID2,ID3);true),
	replaceFact(square(X,A,B,_),square(X,A,B,Player)).
placeSquareBE(Player, Row, Col):-
	R1 is Row+1, C1 is Col-1,
	checkOcto(Player, R1,C1),
	octo(ID,Row,Col,_,_,_,X,_),
	octo(ID1,R1,C1,_,_,_,_,_),
	octo(ID2,Row,C1,_,_,_,_,_),
	octo(ID3,R1,Col,_,_,_,_,_),
	addEdge(ID, ID1),
	(checkCut(X,Player,ID2,ID3);true),
	replaceFact(square(X,A,B,_),square(X,A,B,Player)).
placeSquareBD(Player, Row, Col):-
	R1 is Row+1, C1 is Col+1,
	checkOcto(Player, R1,C1),
	octo(ID,Row,Col,_,_,_,_,X),
	octo(ID1,R1,C1,_,_,_,_,_),
	octo(ID2,Row,C1,_,_,_,_,_),
	octo(ID3,R1,Col,_,_,_,_,_),
	addEdge(ID, ID1),
	(checkCut(X,Player,ID2,ID3);true),
	replaceFact(square(X,A,B,_),square(X,A,B,Player)).


placeSquares(Player, Row, Col):-
	(placeSquareCE(Player, Row, Col);true),
	(placeSquareCD(Player, Row, Col);true),
	(placeSquareBE(Player, Row, Col);true),
	(placeSquareBD(Player, Row, Col);true).

placeEdge(Player,Row,Col, ID1):-
	checkOcto(Player,Row,Col),
	octo(ID,Row,Col,_,_,_,_,_),
	addEdge(ID,ID1).


placePiece(Player, Row, Col):-
	\+isUsed(Row, Col),
	replaceFact(octo(ID,Row, Col,_,A,B,C,D),octo(ID,Row, Col,Player,A,B,C,D)),
	placeSquares(Player,Row,Col),
	R1 is Row -1, R2 is Row +1, % check Hor and Vert edges
	C1 is Col -1, C2 is Col +1,
	(placeEdge(Player,R1,Col, ID);true),
	(placeEdge(Player,R2,Col, ID);true),
	(placeEdge(Player,Row,C1, ID);true),
	(placeEdge(Player,Row,C2, ID);true).


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
	checkAllWhite(0);true,
	display_game(_,_),
	turn(X),
	(X>0 , write('It is @\'s turn!');
	write('It is b\'s turn!')).


%% stackoverflow.com/questions/21161624/define-graph-in-prolog-edge-and-path-finding-if-there-is-a-path-between-two-ve
path(A,B) :-   % two nodes are connected, if
  walk(A,B,[]) % - if we can walk from one to the other,
  .            % first seeding the visited list with the empty list

walk(A,B,V) :-       % we can walk from A to B...
  edge(A,X) ,        % - if A is connected to X, and
  \+(member(X,V)) , % - we haven't yet visited X, and
  (                  % - either
    B = X            %   - X is the desired destination
  ;                  %   OR
    walk(X,B,[A|V])  %   - we can get to it from X
  )                  %
  .                  % Easy!


checkAllBlack(7):-
	octo(7,_,_,P,_,_,_,_),
	P = b,
	checkWinBlack(7,56).

checkAllBlack(X):-
	octo(X,_,_,P,_,_,_,_),
	P = b,
	checkWinBlack(X,56),
	X1 is X+1, X1=<7,
	checkAllBlack(X1).

checkWinBlack(X,63):-
	checkPath(X,63,-1).

checkWinBlack(X,Y):-
	(checkPath(X,Y,-1); true),
	Y1 is Y+1, Y1 =< 63,
	checkWinBlack(X,Y1).


checkAllWhite(56):-
	octo(56,_,_,P,_,_,_,_),
	P = @,
	checkWinWhite(56,7).

checkAllWhite(X):-
	octo(X,_,_,P,_,_,_,_),
	P = @,
	checkWinWhite(X,7),
	X1 is X+8, X1=<56,
	checkAllWhite(X1).

checkWinWhite(X,63):-
	checkPath(X,63,1).

checkWinWhite(X,Y):-
	(checkPath(X,Y,1); true),
	Y1 is Y+8, Y1 =< 63,
	checkWinWhite(X,Y1).


checkPath(X,Y,N):-
	path(X,Y),
	replaceFact(end(_), end(N)).



