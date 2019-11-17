:- consult('data.pl').
:- consult('bot.pl').
:- consult('logic.pl').

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


playBotRandom(64):-
	write('NO MORE MOVES AVAILABLE').

playBotRandom(T):-
	T < 64,
	write(T), nl,
	end(0),
	turn(X),
	(X =< 0 ->
		(	
			randomPlay('b'),
			(turn(Y), Y =< 0 ->
			(N is Y+2,
			replaceFact(turn(Y), turn(N)));true
		)
	)
	;	
	(
		randomPlay('@'),
		(turn(Y), Y >= 0 ->
		(N is Y-2,
			replaceFact(turn(Y), turn(N)));true
			)
		)
		),
		
		turn(Z),

		(game_over(_,Winner);true),
		%display_game(_,_),
		(Z>0 , write('It is @\'s turn!'), nl;
		write('It is b\'s turn!'), nl),
		T1 is T +1, !,
		playBotRandom(T1).		
		
game_over(Board, Winner):-
	Winner is 0,
	(checkAllBlack(0);true),		
	(checkAllWhite(0);true),
	end(X),
	((X > 0, Winner is 1); true),
	((X < 0, Winner is -1); true),
	X \== 0.