tests():-
  PopInit = [i(11708,[9,5,12,14,7,13,11,15,4,1,6,10,3,8,16,2]),i(14645,[7,6,4,9,16,10,14,11,8,5,13,2,12,15,1,3]),i(13687,[13,15,11,2,7,12,1,4,6,10,8,16,5,9,14,3]),i(13092,[8,14,9,12,3,15,13,7,6,5,16,10,1,11,4,2]),i(7326,[1,14,13,12,7,6,15,5,11,9,10,16,4,8,3,2])],
  retract(param(taillePopulation,_)),assertz(param(taillePopulation, 5)),
  retract(param(tailleSelect,_)),assertz(param(tailleSelect, 5)),
  retract(param(tailleIndividu,_)),assertz(param(tailleIndividu, 16)),
  testDTEU(PopInit),nl,
  testTDEU(PopInit),nl,
  testDDAU(PopInit),nl,
  testTTEU(PopInit),nl,
  testTTAU(PopInit),nl,
  testDTAU(PopInit),nl,
  testTDAU(PopInit),nl,
  testDDEU(PopInit),nl.

testDDEU(PopInit):-
  initCptArret(2000),
  retract(param(fSelectionPourReproduction,_)),assertz(param(fSelectionPourReproduction, selectionDeterministe)),
  retract(param(fSelectionPourRemplacement,_)),assertz(param(fSelectionPourRemplacement, selectionDeterministeBis)),
  retract(param(fMutation,_)),assertz(param(fMutation, mutationEchange)),
  retract(param(fCroisement,_)),assertz(param(fCroisement, croisementUniforme)),
  statistics(walltime, _),
  algoGen(PopInit,PopFinale),
  statistics(walltime, [_|[ExecutionTime]]),
  sort(PopFinale, PopFinaleSorted),
  format("selectionDeterministe + selectionDeterministeBis + mutationEchange + croisementUniforme"),nl,
  format("Résultat : "),
  print(PopFinaleSorted),nl,
  format("Temps d'execution : ~d", [ExecutionTime]), nl,!.


testDTEU(PopInit):-
  initCptArret(2000),
  retract(param(fSelectionPourReproduction,_)),assertz(param(fSelectionPourReproduction, selectionDeterministe)),
  retract(param(fSelectionPourRemplacement,_)),assertz(param(fSelectionPourRemplacement, selectionTournoisBis)),
  retract(param(fMutation,_)),assertz(param(fMutation, mutationEchange)),
  retract(param(fCroisement,_)),assertz(param(fCroisement, croisementUniforme)),
  statistics(walltime, _),
  algoGen(PopInit,PopFinale),
  statistics(walltime, [_|[ExecutionTime]]),
  sort(PopFinale, PopFinaleSorted),
  format("selectionDeterministe + selectionTournoisBis + mutationEchange + croisementUniforme"),nl,
  format("Résultat : "),
  print(PopFinaleSorted),nl,
  format("Temps d'execution : ~d", [ExecutionTime]), nl,!.


testTDEU(PopInit):-
  initCptArret(2000),
  retract(param(fSelectionPourReproduction,_)),assertz(param(fSelectionPourReproduction, selectionTournois)),
  retract(param(fSelectionPourRemplacement,_)),assertz(param(fSelectionPourRemplacement, selectionDeterministeBis)),
  retract(param(fMutation,_)),assertz(param(fMutation, mutationEchange)),
  retract(param(fCroisement,_)),assertz(param(fCroisement, croisementUniforme)),
  statistics(walltime, _),
  algoGen(PopInit,PopFinale),
  statistics(walltime, [_|[ExecutionTime]]),
  sort(PopFinale, PopFinaleSorted),
  format("selectionTournois + selectionDeterministeBis + mutationEchange + croisementUniforme"),nl,
  format("Résultat : "),
  print(PopFinaleSorted),nl,
  format("Temps d'execution : ~d", [ExecutionTime]), nl,!.


testDDAU(PopInit):-
  initCptArret(2000),
  retract(param(fSelectionPourReproduction,_)),assertz(param(fSelectionPourReproduction, selectionDeterministe)),
  retract(param(fSelectionPourRemplacement,_)),assertz(param(fSelectionPourRemplacement, selectionDeterministeBis)),
  retract(param(fMutation,_)),assertz(param(fMutation, mutationAdjacence)),
  retract(param(fCroisement,_)),assertz(param(fCroisement, croisementUniforme)),
  statistics(walltime, _),
  algoGen(PopInit,PopFinale),
  statistics(walltime, [_|[ExecutionTime]]),
  sort(PopFinale, PopFinaleSorted),
  format("selectionDeterministe + selectionDeterministeBis + mutationAdjacence + croisementUniforme"),nl,
  format("Résultat : "),
  print(PopFinaleSorted),nl,
  format("Temps d'execution : ~d", [ExecutionTime]), nl,!.


testTTEU(PopInit):-
  initCptArret(2000),
  retract(param(fSelectionPourReproduction,_)),assertz(param(fSelectionPourReproduction, selectionTournois)),
  retract(param(fSelectionPourRemplacement,_)),assertz(param(fSelectionPourRemplacement, selectionTournoisBis)),
  retract(param(fMutation,_)),assertz(param(fMutation, mutationEchange)),
  retract(param(fCroisement,_)),assertz(param(fCroisement, croisementUniforme)),
  statistics(walltime, _),
  algoGen(PopInit,PopFinale),
  statistics(walltime, [_|[ExecutionTime]]),
  sort(PopFinale, PopFinaleSorted),
  format("selectionTournois + selectionTournoisBis + mutationEchange + croisementUniforme"),nl,
  format("Résultat : "),
  print(PopFinaleSorted),nl,
  format("Temps d'execution : ~d", [ExecutionTime]), nl,!.


testTTAU(PopInit):-
  initCptArret(2000),
  retract(param(fSelectionPourReproduction,_)),assertz(param(fSelectionPourReproduction, selectionTournois)),
  retract(param(fSelectionPourRemplacement,_)),assertz(param(fSelectionPourRemplacement, selectionTournoisBis)),
  retract(param(fMutation,_)),assertz(param(fMutation, mutationAdjacence)),
  retract(param(fCroisement,_)),assertz(param(fCroisement, croisementUniforme)),
  statistics(walltime, _),
  param(fSelectionPourRemplacement, P),
  algoGen(PopInit,PopFinale),
  statistics(walltime, [_|[ExecutionTime]]),
  sort(PopFinale, PopFinaleSorted),
  format("selectionTournois + selectionTournoisBis + mutationAdjacence + croisementUniforme"),nl,
  format("Résultat : "),
  print(PopFinaleSorted),nl,
  format("Temps d'execution : ~d", [ExecutionTime]), nl,!.


testDTAU(PopInit):-
  initCptArret(2000),
  retract(param(fSelectionPourReproduction,_)),assertz(param(fSelectionPourReproduction, selectionDeterministe)),
  retract(param(fSelectionPourRemplacement,_)),assertz(param(fSelectionPourRemplacement, selectionTournoisBis)),
  retract(param(fMutation,_)),assertz(param(fMutation, mutationAdjacence)),
  retract(param(fCroisement,_)),assertz(param(fCroisement, croisementUniforme)),
  statistics(walltime, _),
  algoGen(PopInit,PopFinale),
  statistics(walltime, [_|[ExecutionTime]]),
  sort(PopFinale, PopFinaleSorted),
  format("selectionDeterministe + selectionTournoisBis + mutationAdjacence + croisementUniforme"),nl,
  format("Résultat : "),
  print(PopFinaleSorted),nl,
  format("Temps d'execution : ~d", [ExecutionTime]), nl,!.


testTDAU(PopInit):-
  initCptArret(2000),
  retract(param(fSelectionPourReproduction,_)),assertz(param(fSelectionPourReproduction, selectionTournois)),
  retract(param(fSelectionPourRemplacement,_)),assertz(param(fSelectionPourRemplacement, selectionDeterministeBis)),
  retract(param(fMutation,_)),assertz(param(fMutation, mutationAdjacence)),
  retract(param(fCroisement,_)),assertz(param(fCroisement, croisementUniforme)),
  statistics(walltime, _),
  algoGen(PopInit,PopFinale),
  statistics(walltime, [_|[ExecutionTime]]),
  sort(PopFinale, PopFinaleSorted),
  format("selectionTournois + selectionDeterministeBis + mutationAdjacence + croisementUniforme"),nl,
  format("Résultat : "),
  print(PopFinaleSorted),nl,
  format("Temps d'execution : ~d", [ExecutionTime]), nl,!.
