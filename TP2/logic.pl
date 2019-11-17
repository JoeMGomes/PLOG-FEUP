:- consult('data.pl').


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
	T \== -3,T \== 3,
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
	end(0),
	octo(7,_,_,P,_,_,_,_),
	P = b,
	checkWinBlack(7,56).

checkAllBlack(X):-
	end(0),
	octo(X,_,_,P,_,_,_,_),
	((P = b,
	checkWinBlack(X,56));true),
	X1 is X+1, X1=<7,
	checkAllBlack(X1).

checkWinBlack(X,63):-
	end(0),
	checkPath(X,63,-1).

checkWinBlack(X,Y):-
	end(0),
	(checkPath(X,Y,-1),!; true),
	Y1 is Y+1, Y1 =< 63,
	checkWinBlack(X,Y1).


checkAllWhite(56):-
	end(0),
	octo(56,_,_,P,_,_,_,_),
	P = @,
	checkWinWhite(56,7).

checkAllWhite(X):-
	end(0),
	octo(X,_,_,P,_,_,_,_),
	((P = @,
	checkWinWhite(X,7));true),
	X1 is X+8, X1=<56,
	checkAllWhite(X1).

checkWinWhite(X,63):-
	end(0),	
	checkPath(X,63,1).

checkWinWhite(X,Y):-
	end(0),
	((checkPath(X,Y,1),!); true),
	Y1 is Y+8, Y1 =< 63,
	checkWinWhite(X,Y1).


checkPath(X,Y,N):-
	end(0),
	path(X,Y),
	write('end changed'),nl,
	replaceFact(end(_), end(N)).



