% MAJ: 23  mars 2021
% BENJAMIN DANLOS & RIDA GHOUTI TERKI
%%% export PATH=/Applications/SWI-Prolog.app/Contents/MacOS:$PATH
%%% swipl tp7_AG_TROUS.pl

% TODO : rapport
% TODO : ajouter autres croisements et selections (tournois...)

% TP ag � trous pour TP7 et 8
%prolog_flag(toplevel_print_options,Val).
%:- set_prolog_flag(toplevel_print_options, [max_depth(20)]).
:- set_prolog_flag(toplevel_print_options, [max_depth(0)]). %0= sans borne max
%:- set_prolog_flag(debugger_print_options, [max_depth(20)]).
:- set_prolog_flag(debugger_print_options, [max_depth(0)]). %0= sans borne max

:-use_module(library(lists)).	%pr�dicats maplist,sort,length,append,nth1,last ...
%:-use_module(library(sets)). %pr�dicat union,list_to_set ...
:-use_module(library(random)).%pr�dicat random(+L,+U,-R) [SWI :random_between(+L,+U,-R)]
%:-use_module(library(samsort)).%predicat samsort(+L,_Ltriee)
    % NB: sort elimine les doublons, samsort, non.

:-consult('matrices.pl').
:-consult('croisements.pl').
:-consult('selections.pl').
:-consult('mutations.pl').
:-consult('masques.pl').


:- dynamic  decompteurArret/1.	%decompte dynamique pour farret: arretParCompteur
:- dynamic  individu/1.
:- dynamic  param/2. %pour pouvoir renseigner param(fArret_CptMax, CptMax) au lancement

%*************************************************
%**************** PARAMETRES de l'algorithme *****
%*************************************************

%decompteurArret(Cpt): pr�dicat utilis� par fonction arretParCompteur.
  %Contient le d�compte du nombre de g�n�rations calcul�es. Doit �tre initialis�
  %� CptMax en d�but de programme (par assertion dynamique, cf initCptArret) .
decompteurArret(_).

param(fArret, arretParCompteur).
param(fArret_CptMax, 2). %PAS UTILISE. Au cas o� on voudrait �viter de passer CptMax en argument du 'go'
                         %Ici,on fera 2 tours de boucle.
param(fEvaluation,fEval).
param(fSelectionPourReproduction,selectionDeterministe).
param(fSelectionPourRemplacement,selectionDeterministeBis).
param(fMutation,mutationEchange).% ou mutationAdjacence
param(fCroisement,croisementUniforme).
param(taillePopulation,10). % N individus dans la population
param(tailleSelect,10).     % K individus parents, qui donneront K enfants
param(tailleIndividu,29).   % Nombre de villes � parcourir (taille de la matrice ?)

%***************************************************
% Lancement global
%***************************************************
go(CptMax):-
    initCptArret(CptMax),  %CptMax: nb tours de boucle
    param(taillePopulation, TaillePop),
    param(tailleSelect, Tailleselect),
    param(tailleIndividu, TailleIndiv),
    param(fSelectionPourReproduction, FReprod),
    param(fSelectionPourRemplacement, FRempl),
    param(fMutation, FMuta),
    param(fCroisement, FCrois),
    format("Paramètres :"),nl,
    format("Taille population : ~d",[TaillePop]),nl,
    format("Taille selection : ~d",[Tailleselect]),nl,
    format("Taille individu : ~d",[TailleIndiv]),nl,
    format("Fonction selection reproduction : ~s",[FReprod]),nl,
    format("Fonction selection remplacement : ~s",[FRempl]),nl,
    format("Fonction mutation : ~s",[FMuta]),nl,
    format("Fonction croisement : ~s",[FCrois]),nl,
    format("Generation de la population initiale..."),nl,
    generatePopulationEvaluee(PopInit),
    %PopInit = [i(28,[2,4,1,3,5]), i(34,[5,4,1,2,3]), i(27,[1,2,3,4,5]), i(35,[1,4,2,3,5]), i(21,[4,3,1,5,2])],
    %PopInit = [i(11708,[9,5,12,14,7,13,11,15,4,1,6,10,3,8,16,2]),i(14645,[7,6,4,9,16,10,14,11,8,5,13,2,12,15,1,3]),i(13687,[13,15,11,2,7,12,1,4,6,10,8,16,5,9,14,3]),i(13092,[8,14,9,12,3,15,13,7,6,5,16,10,1,11,4,2]),i(7326,[1,14,13,12,7,6,15,5,11,9,10,16,4,8,3,2])],
    format("Population initiale:"),nl,
    print(PopInit),nl,
    format("Clacul en cours..."),nl,
    algoGen(PopInit,[i(Cout,MeilleurParcours)|PopFinale]),
    format("Cout du meilleur parcours calculé: ~d",[Cout]),nl,
    format("Meilleur parcours calculé:"),
    print(MeilleurParcours),nl,
    format("Autres parcours interessants calculés :"),nl,
    print(PopFinale),!.

%***************************************************
%FIN de lancement global
%***************************************************

%*************************************************
%********* BOUCLE GENERATIONNELLE ****************
%*************************************************
%*************************************************
%algoGen(+PopulationEval,-PopulationFinaleEval )
% produit PopulationFinaleEval � partir de PopulationEval,
% en faisant Cpt appels r�cursifs � algoGen.
% Il y aura donc Cpt g�n�rations entre PopulationEval et PopulationFinaleEval.
% Cpt est la valeur contenue dans le fait decompteurArret(Cpt).

algoGen(PopulationEval,PopulationEval ):-
	critereArret(PopulationEval),!.

algoGen(PopulationEval,PopulationFinaleEval ):-
  selectionPourReproductionL(PopulationEval, KParentsSelectionnesEval), % Liste de k 'i(Val,Indiv)'
  maplist(enleveVal,KParentsSelectionnesEval,KParentsSelectionnesSansEval),% -> liste de k 'Indiv'
  mutationEtCroisementL(KParentsSelectionnesSansEval,Kenfants),%  liste de k 'Indiv'
  evaluationL(Kenfants, KenfantsEval),% Liste de k 'i(Val,Indiv)'
  selectionPourRemplacementL(PopulationEval,KenfantsEval,NewPopulationEval),%Liste de n 'i(Val,Indiv)'
  algoGen(NewPopulationEval,PopulationFinaleEval).
  %NewPopulationEval est la g�n�ration suivant PopulationEval

%%% | ?- maplist(enleveVal, [i(25,[1,2,3,4,5]),i(21,[1,2,5,4,3]),i(39,[1,3,5,2,4])],R).
%%% R = [[1,2,3,4,5],[1,2,5,4,3],[1,3,5,2,4]] ?
enleveVal(i(_Val,I),I).

%%% %mutationEtCroisementL(+Parents ,-Enfants) taille des listes: param(tailleSelect,K)
%%% | ?- mutationEtCroisementL([[1,2,3,4,5],[5,4,3,2,1],[1,2,5,4,3],[1,3,5,2,4]],P).
%%% But � executer : croisementUniforme([1,2,3,4,5],[5,4,3,2,1],_6759,_6763)
%%% Masque produit(pour croisement uniforme): [1,1,1,1,1]
%%% But � executer : croisementUniforme([1,2,5,4,3],[1,3,5,2,4],_10759,_10763)
%%% Masque produit(pour croisement uniforme): [1,0,0,0,1]
%%% But � executer : mutationParEchange([5,4,3,2,1],_14933)
%%% Position P1 et P2 (pour mutation par �change): 4 5
%%% But � executer : mutationParEchange([1,2,5,4,3],_14941)
%%% Position P1 et P2 (pour mutation par �change): 3 5
%%% P = [[5,4,3,1,2],[5,4,3,2,1],[1,2,3,4,5],[1,2,5,3,4]] ?

mutationEtCroisementL(Parents , Enfants):-
  croisementL(Parents, Croises), % les k parents sont croises 2 � 2
  mutationL(Croises,Enfants).    % parmi ceux-l�, certains (peu) sont mutes


%*****************************************************
%************* DEBUT predicats outils ****************
%*****************************************************
createIntervalle(Start,Liste):-
  param(tailleIndividu, M),
  Start=M,
  Liste = [Start],!.
createIntervalle(Start, Liste):-
  param(tailleIndividu, M),
  Start<M,
  IPP is Start + 1,
  createIntervalle(IPP, ListeBis),
  Liste = [Start|ListeBis],!.
createIntervalle(Liste):-
  createIntervalle(1,Liste),!.

mixIntervalle(Pop):-
  createIntervalle(Intervalle),
  mixIntervalle(Intervalle, Pop),!.
mixIntervalle([S], [S]):-!.
mixIntervalle(Intervalle, Pop):-
  random_member(R, Intervalle),
  delete(Intervalle,R,IntervalleBis),
  mixIntervalle(IntervalleBis, PopBis),
  Pop = [R|PopBis],!.


generateIndividuEvalue(Indiv):-
  mixIntervalle(Parours),
  fEval(Parours, Cout),
  Indiv = i(Cout, Parours),!.
%generateIndividuEvalue(Indiv):-
  %param(tailleIndividu, Nombre),
  %generateIndividuEvalue(Nombre, IndivNonEval),
  %fEval(IndivNonEval,Cout), %cout algorithmique pas important meme sur matrice de 16
  %Indiv = i(Cout, IndivNonEval).

%generateIndividuEvalue(1, [R]):-
  %param(tailleIndividu, Max),
  %BorneSup is Max + 1,
  %random(1, BorneSup, R),!.

%generateIndividuEvalue(Nombre, Indiv):-
  %param(tailleIndividu, Max),
  %NombreMM is Nombre - 1,
  %generateIndividuEvalue(NombreMM, IndivBis),
  %BorneSup is Max + 1,
  %random(1, BorneSup, Ville),
  %eviter que la ville tirée au sort soit deja dans le parcours
  % COUT ALGORITHMIQUE IMPORTANT A CAUSE DU RANDOM
  %(member(Ville, IndivBis)->generateIndividuEvalue(Nombre,Indiv);Indiv = [Ville|IndivBis]).

generatePopulationEvaluee(Pop):-
  param(taillePopulation, Max),
  generatePopulationEvaluee(Max, Pop).

generatePopulationEvaluee(1,[Pop]):-
  generateIndividuEvalue(Pop),!.

generatePopulationEvaluee(Nombre, Pop):-
  NombreMM is Nombre - 1,
  generatePopulationEvaluee(NombreMM, PopBis),
  generateIndividuEvalue(Indiv),
  Pop = [Indiv|PopBis].


% generateRandomPositions(-P1, -P2).
generateRandomPositions(P1, P2):-
    param(tailleIndividu,Max),
    MaxPP is Max + 1,
	generateRandomPositions(MaxPP, P1, P2).
generateRandomPositions(Max, P1, P2):-
    random(1, Max, A),
    generateSecondRandom(Max, A, B),
    ((A>B)->(P1=B,P2=A);(P1=A,P2=B)).
generateSecondRandom(Max, P1, P2):-
	  %M is Max + 1,
    random(1, Max, Pi),
    ((Pi=P1)->generateSecondRandom(Max, P1, P2);P2=Pi).

% subList(+Liste, +I1, +I2, -Res).
% Res devient la sous liste de Liste de I1 à I2  INCLUS
% attention, length compte a partir de 1 pas de 0
% cas où I1 > I2
subList(Liste, I1, I2, Res):-
    I1>I2,
    subList(Liste, I2,I1, Res),!.
% cas où I1==I2, donne le singleton à la postion I
subList(Liste,I,I,Res):-
    nth1(I,Liste,E),
    Res = [E],!.
subList(Liste, I1, I2, Res):-
    nth1(I1,Liste,E),
    I1PP is I1 + 1,
    subList(Liste, I1PP, I2, ResBis),
    Res = [E|ResBis],!.



%evaluationL(+Population, -PopulationEvaluee)
%lancement r�cursif de l'appel � la fonction d'evaluation pass�e en param
%Forme d'un individu evalue: i(Val,I)  Exemple: i(21,[1,2,5,4,3])
%%% | ?- evaluationL([[1,2,3,4,5],[5,4,3,2,1],[1,2,5,4,3],[1,3,5,2,4]],R).
%%% R = [i(27,[1,2,3,4,5]),i(27,[5,4,3,2,1]),i(20,[1,2,5,4,3]),i(28,[1,3,5,2,4])] ?
evaluationL([],[]):-!.
evaluationL([I|L],[IE|LE]):-
    fEval(I, Cout),
    IE = i(Cout,I),
    evaluationL(L,LE).


%critereArret(+PopulationEval): appel � la fonction d'arret pass�e en param
 %Il faut mettre PopulationEval en argument
 %car en general, la fonction d'arret en a besoin
critereArret(PopulationEval):-
	param(fArret, F), %ex: F = arretParCompteur
	F=..LF,
	append(LF,[PopulationEval],FetSesArguments),
	But=..FetSesArguments,
	But.			%ex: arretParCompteur(PopulationEval)



%************************************************
%****************DEBUT fonction arr�t   ********
%**********  par decompte d'un compteur ********
%************************************************
%Avant de lancer la boucle g�n�rationnelle, il faut initialiser le d�compte
%  en cr�ant le fait decompteurArret(CptMax) qui indique le nb de tours de boucle � faire
% initCptArret(+CptMax)
initCptArret(CptMax) :-    %CptMax est pass� en arg du pr�dicat de lancement
	retract(decompteurArret(_)),
	assert(decompteurArret(CptMax)).     %initialise le decompte

%arretParCompteur(+Population)  : indique si le d�compte est termin�, sinon d�cr�mente
% NB: dans le cas d'un simple d�compte l'argument Population ne sert � rien
% Au lancement, le fait decompteurArret(Val) a �t� initialis� � la val CPtMax
arretParCompteur(_Population):-
	decompteurArret(0),!.       %Cas o� le nb de tours est atteint:
                                    %SUCCES du predicat arretParCompteur

arretParCompteur(_Population):-
	decompteurArret(N),              %Cas ou le d�compte n'est pas termin�:
	retract(decompteurArret(N)),
	N1 is N-1,!,
	assert(decompteurArret(N1)),     %decrement de decompteurArret
	fail.                            %et  ECHEC du predicat arretParCompteur

%************************************************
%****************FIN  fonction arr�t
%************************************************



%************************************************
%*********  Cout d'un parcours ******************
%******* =Fonction d'�valuation d'un individu ***
%************************************************
%%%fEval([5,4,1,2,3],Val).
%%%Val = 34
%On dispose de :    param(tailleIndividu,Taille) et
%                   matriceDistances(Taille,Matrice)
%Trouve le cout de parcours en partant de la première ville (proviennent du TP4, adaptés)
fEval(Parcours,Cout):-
    cout_de_parcours(Parcours,Cout),!.
cout_de_parcours([A|[B|L]],C) :-
    coutVi_Vj(A,B,C1),
    cout_de_parcours([B|L], C2, A),
    C is C2 + C1,!.
cout_de_parcours([A|[B|L]],C, VilleDepart) :-
    coutVi_Vj(A,B,C1),
    cout_de_parcours([B|L], C2, VilleDepart),
    C is C2 + C1,!.
cout_de_parcours([A,B],C, VilleDepart) :-
    coutVi_Vj(A,B,C1),
    coutVi_Vj(B,VilleDepart,C2),%attention, on ne commence pas forcement à 1 ici
    C is C1+C2,!.
coutVi_Vj(I,J,DistanceDeIaJ) :-
    param(tailleIndividu, N),
    matriceDistances(N, E),
    nth1(I, E, VI),
    nth1(J, VI, VJ),
    DistanceDeIaJ is VJ,!.

%****************************************************
%*********  Fin cout d'un parcours ******************
%********* = Fonction d'�valuation d'un individu ****
%****************************************************
