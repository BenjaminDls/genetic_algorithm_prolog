
%croisementL(+KParents, -KCroises) % les k parents sont croises 2 � 2, par ordre d'apparition
croisementL([],[]):-!.
croisementL([P],[P]):-!. %si nb impair de parents, le dernier n'est pas crois�
croisementL([P1,P2|L],[P12,P21|LC]):-
	croisement(P1,P2,P12,P21),
	croisementL(L,LC).

% croisement:  appel  � la fonction de croisement passee en param dans param(fCroisement,F)
%%% | ?-  croisement([1,2,3,4,5],[5,4,3,2,1],Icroise1,Icroise2).
%%% But � executer : croisementUniforme([1,2,3,4,5],[5,4,3,2,1],_5497,_5565)
%%% Masque produit(pour croisement uniforme): [1,1,1,0,0]
%%% Icroise1 = [3,2,1,4,5],
%%% Icroise2 = [5,4,3,1,2] ?
croisement(I1,I2,Icroise1,Icroise2):-
	param(fCroisement,FCroisementActive), %ex: croisementUniforme
	But=..[FCroisementActive,I1,I2,Icroise1,Icroise2],
	%format("But à executer : ~p",[But]),nl,
	But. %ex: croisementUniforme([1,2,3,4,5],[5,4,3,2,1],Icroise1,Icroise2)


%*****************************************************
%**************** DEBUT croisement uniforme **********
%*****************************************************

%croisementUniforme(+I1,+I2,-Icrois�12,-Icrois�21)
%%%| ?-croisementUniforme([1,2,3,4,5],[5,4,3,2,1],Ic12,Ic21).
%%% Masque produit(pour trace): [0,1,1,0,1]
%%% Ic12 = [1,5,3,4,2],
%%% Ic21 = [2,4,3,5,1]

croisementUniforme(I1,I2,Ic12,Ic21):-
	genereMasque(M),
	%format("Masque produit(pour trace): ~p",[M]),nl,
	appliqueMasque(0,M,I1,I2,Ic12),
	appliqueMasque(1,M,I2,I1,Ic21).

%*****************************************************
%**************** FIN croisement uniforme ***********
%*****************************************************


% genereateListOfRandoms(+Length, -Liste).
% genere une liste de binaires aleatoires de longueur Length dans Liste
generateListOfRandoms(0,[]):-!.

generateListOfRandoms(1,List):-
    random(0,2,R),
    List = [R], !.

generateListOfRandoms(Length, List):-
    LenBis is Length - 1,
    generateListOfRandoms(LenBis, LBis),
    random(0,2,R),
    List = [R|LBis].
