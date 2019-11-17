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
	
move(Row, Col):-
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
	(game_over(_,Winner);true),
	turn(X),
	(X>0 , write('It is @\'s turn!');
	write('It is b\'s turn!')).



playBot(Level):-
	end(0),
	turn(X),
	(X =< 0 ->
		(	
			(Level = 1 ->randomPlay('b');smartPlay('b')),
			(turn(Y), Y =< 0 ->
			(N is Y+2,
			replaceFact(turn(Y), turn(N)));true
		)
	)
	;	
	(
			(Level = 1 ->randomPlay('@');smartPlay('@')),
		(turn(Y), Y >= 0 ->
		(N is Y-2,
			replaceFact(turn(Y), turn(N)));true
			)
		)
		),
		
		turn(Z),

		(game_over(_,Winner);true),
		(Z>0 , write('It is @\'s turn!'), nl;
		write('It is b\'s turn!'), nl).	

move(Row, Col):-
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
	(game_over(_,Winner);true),
	turn(X),
	(X>0 , write('It is @\'s turn!');
	write('It is b\'s turn!')).

moveVsBot(Row, Col, Level):-
	turn(X),
	(X >= 0 ->
		(	
			placePiece('@', Row, Col),
			(turn(X), X >= 0 ->
			(N is X-2,
			replaceFact(turn(X), turn(N)));true
			)
		)
	),
	(game_over(_,Winner);true),
	turn(A),
	(A < 0), 
	((A = -3, playBot(Level));true),
	playBot(Level),
	(A>0 , write('It is @\'s turn!');
	write('It is b\'s turn!')).
	

choose_move(Board, Level, Move):-
	turn(X),
	X < 0,
	playBot(Level).

botVsbot(Level):-
	end(0),
	playBot(Level),!,
	botVsbot(Level).
    
		
game_over(Board, Winner):-
	Winner is 0,
	(checkAllBlack(0);true),		
	(checkAllWhite(0);true),
	end(X),
	((X > 0, Winner is 1); true),
	((X < 0, Winner is -1); true),
	X \== 0.