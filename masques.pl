%*****************************************************
%**************** DEBUT predicats masques ************
%*****************************************************

%appliqueMasque(+ValeurPourGarderValDansI1,+Masque,+I1,+I2,-Icroise)
%%%| ?-appliqueMasque(0,[1,1,0,1,0],[1,2,3,4,5],[5,4,3,2,1],Ic12).
%%% Ic12 = [4,2,3,1,5]
%%%| ?-appliqueMasque(1,[1,1,0,1,0],[5,4,3,2,1],[1,2,3,4,5],Ic21).
%%% Ic21 = [5,4,1,2,3]
appliqueMasque(V,M,I1,I2,Ic12):-
	masqueParent1(V,M,I1,I1Masque, ListeElemDeI1),
	filtreParent2(I2, ListeElemDeI1, ListeElemDeI2),
	fusionneI1MasqueAvecListeElemDeI2(I1Masque,ListeElemDeI2,Ic12).

%masqueParent1(+V,+Masque,+I1,-I1Masque, -ListeElemDeI1)
%garde les valeurs de I1 aux positions ou le masque a la valeur V
%%%| ?-masqueParent1(0, [1,1,0,1,0], [1,2,3,4,5], I1M, LI1).
%%% I1M = [trou,trou,3,trou,5],   LI1 = [3,5]
%le masque est un singleton de valeur égale à V, on garde l'element qu'on va renvoyer en singleton dans le masque appliqué et dans les elements choisis
masqueParent1(0, [0], [I1Singleton], I1Masque, ListeElemDeI1):-
    I1Masque = I1Singleton,
    ListeElemDeI1 = I1Singleton, !.
masqueParent1(1, [1], [I1Singleton], I1Masque, ListeElemDeI1):-
    I1Masque = I1Singleton,
    ListeElemDeI1 = I1Singleton, !.
%le masque est un singleton de valeur different de V, on ne garde pas lelement et le masque appliqué est un trou
masqueParent1(1, [0], [_], I1Masque, ListeElemDeI1):-
    I1Masque = trou,
    ListeElemDeI1 = [], !.
masqueParent1(0, [1], [_], I1Masque, ListeElemDeI1):-
    I1Masque = trou,
    ListeElemDeI1 = [], !.

masqueParent1(V, [E1M|Masque], [E1I|I1], I1Masque, ListeElemDeI1):-
    masqueParent1(V, [E1M], [E1I], E1Masque, ListeE1),%application du masque sur la tete de liste sous forme dun singleton
    masqueParent1(V, Masque, I1, I1MasqueBis, ListeElemDeI1Bis),%aplication du masque recursivement
    I1MasqueNotClean = [E1Masque|I1MasqueBis],
    %print(I1MasqueNotClean),
    ListeElemDeI1NotClean = [ListeE1|ListeElemDeI1Bis],
    %print(ListeElemDeI1NotClean),
	  flatten(I1MasqueNotClean, I1Masque),
    flatten(ListeElemDeI1NotClean, ListeElemDeI1).%enleve les [] de la liste

%filtreParent2(+I2, +ListeElemDeI1, -ListeElemDeI2Restant):
% ListeElemDeI2=I2 privee des elements de ListeElemDeI1
%%%| ?- filtreParent2([5,4,3,2,1], [3,5], L).
%%%L = [4,2,1]
filtreParent2(I2, ListeElemDeI1, ListeElemDeI2Restant):-
    subtract(I2, ListeElemDeI1, ListeElemDeI2Restant).

%fusionneI1MasqueAvecListeElemDeI2(+I1Masque,+ListeElemDeI2,-Ic12).
% Ic12= les elements de ListeElemDeI2 viennent combler les 'trou' de I1Masque
%%%| ?- fusionneI1MasqueAvecListeElemDeI2([trou,trou,3,trou,5],[4,2,1],Ic12).
%%% Ic12 = [4,2,3,1,5]
fusionneI1MasqueAvecListeElemDeI2([trou], [E], [E]):-!.
fusionneI1MasqueAvecListeElemDeI2([E], _, [E]):-!.
fusionneI1MasqueAvecListeElemDeI2([trou|I1Masque], [E|ListeElemDeI2],Ic12):-
    fusionneI1MasqueAvecListeElemDeI2(I1Masque, ListeElemDeI2, Ic12Bis),
    Ic12 = [E|Ic12Bis], !.
fusionneI1MasqueAvecListeElemDeI2([Num|I1Masque], ListeElemDeI2,Ic12):-
    fusionneI1MasqueAvecListeElemDeI2(I1Masque, ListeElemDeI2, Ic12Bis),
    Ic12 = [Num|Ic12Bis], !.

%genereMasque(-M) fabrique un masque aleatoire de 1 et de 0
% de la taille d'un individu.
% La taille d'un individu est contenue dans le fait param(tailleIndividu,N).
% Pour la g�n�ration al�atoire dun nombre 1 ou 0,
%   utiliser random(+L, +U, -R) de la librairie random
genereMasque(M):-
    param(tailleIndividu,TailleIndividus),
    generateListOfRandoms(TailleIndividus, M).


%*****************************************************
%**************** FIN predicats masques **************
%*****************************************************
