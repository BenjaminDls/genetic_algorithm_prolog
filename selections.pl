
%selectionPourRemplacementL(+PopulationEval,+KenfantsEval, -NewPopulationEval)
%appel � la fonction de selection pour remplacement pass�e en param
selectionPourRemplacementL(PopulationEval,KenfantsEval, NewPopulationEval):-
	param(taillePopulation,N),
	param(fSelectionPourRemplacement,FSelect),%ex: Fselect=selectionDeterministeBis
	But=..[FSelect,N,PopulationEval, KenfantsEval,NewPopulationEval],
	But.  %ex: selectionDeterministeBis(10,PopulationEval, KenfantsEval,NewPopulationEval)


%selectionPourReproductionL:
%            appel � la fonction fSelectionPourReproduction passee en param
%selectionPourReproductionL(+PopulationEval, -KParentsSelectionnes)
selectionPourReproductionL(PopulationEval, KParentsSelectionnes):-
	param(tailleSelect,K),
	param(fSelectionPourReproduction,FSelect), %ex: FSelect=selectionDeterministe
	But=..[FSelect,K,PopulationEval, KParentsSelectionnes],
	But.  %ex: selectionDeterministe(K,PopulationEval, ParentsSelectionnes)


%*********************************************************************************
%****************DEBUT fonction s�lection pour reproduction: selectionDeterministe
%*********************************************************************************
%Quels individus vont  se reproduire?    Selection de K individus parmi N
% selectionDeterministe(+K,+PopulationEval,-KParentsSelectionnesEval)
% KParentsSelectionnesEval = les K meilleurs de PopulationEval - et on garde l'info 'Valeur'-
%%% | ?- selectionDeterministe(2,[i(27,[1,2,3,4,5]),i(27,[5,4,3,2,1]),i(20,[1,2,5,4,3]),i(28,[1,3,5,2,4])], Resul).
%%% Resul = [i(20,[1,2,5,4,3]),i(27,[1,2,3,4,5])] ?
selectionDeterministe(0,_,[]):-!.
selectionDeterministe(K,PopulationEval,KParentsSelectionnesEval):-
    %par elitisme : les K dont l'eval est la plus petite
    sort(PopulationEval, ListeOrdo),
    nth0(0,ListeOrdo, Meilleur),
    KMM is K - 1,
    delete(PopulationEval, Meilleur, ListeReduite),
    selectionDeterministe(KMM, ListeReduite, KMMParentsSelectionnes),
    KParentsSelectionnesEval = [Meilleur|KMMParentsSelectionnes],!.

%********************************************************************************
%****************FIN  fonction s�lection pour reproduction: selectionDeterministe
%********************************************************************************

%************************************************************************************
%****************DEBUT fonction s�lection pour remplacement: selectionDeterministeBis
%************************************************************************************
%Quels individus vont dispara�tre?
%Il faut garder N individus parmi N (generation precedente) +K (les enfants nouveaux nes)
%selectionDeterministeBis : r�unit les N individus de la population de d�part
% et les K enfants, et prend les N meilleurs
%selectionDeterministeBis(+N,+PopulationEval, +KenfantsEval,-NewPopulationEval)
% | ?- selectionDeterministeBis(3,[i(27,[1,2,3,4,5]),i(27,[5,4,3,2,1])],[i(28,[1,3,5,2,4]),i(20,[1,2,5,4,3])], R).
% R = [i(20, [1, 2, 5, 4, 3]), i(27, [1, 2, 3, 4, 5]), i(27, [5, 4, 3, 2, 1])]
selectionDeterministeBis(0,_, KenfantsEval,KenfantsEval):-!.
selectionDeterministeBis(N,PopulationEval, KenfantsEval,NewPopulationEval):-
    append(PopulationEval,KenfantsEval,Concat),
    selectionDeterministe(N, Concat, NewPopulationEval).

%************************************************************************************
%****************FIN  fonction  s�lection pour remplacement: selectionDeterministeBis
%************************************************************************************
