Aztec Math
David Dinis - up201706766
José Gomes - up201707054

Os 4 comandos principais são

puzzle(x,L)	 %unifica L com o puzzle número x (1-4)
aztec(L)	 %resolve o puzzle L
generate(x,G)	 %unifica G com um puzzle de x níveis (1-9). Não são recomendados valores maiores que 4
displayPuzzle(L) %imprime no ecrã o puzzle L

Exemplos de execução:

?- puzzle(1,L),aztec(L),displayPuzzle(L). %resolve e imprime o puzzle 1

?- generate(3,L), displayPuzzle(L). %gera e imprime um puzzle de 3 níveis por resolver. 