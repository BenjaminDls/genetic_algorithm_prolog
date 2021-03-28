%mutationL(+KParents, -KMutes) Exemple de Choix : seul le premier et le 3eme sont mut�s
%mutationL(KParents, KMutes):-
%  mutation(KParents, KMutes),!.

%mutationL(+KParents, -KMutes) Exemple de Choix : seul le premier et le 3eme sont mut�s
mutationL([K1,K2,K3|KParents], KMutes):-
  mutation(K1,K1M),
  mutation(K3,K3M),
  KMutes = [K1M, K2, K3M | KParents],!.

%!!!!!!!!!!!!!!!!  A COMPLETER : mutationL !!!!!!!!!!!!!!!!!!!!!!!!!!!!

%% mutation(+I1,-Imut�): appel � la f de mutation pass�e en param dans param(fMutationf,F)
%% | ?- mutation([1,2,3,4,5],Imute).
%%% But � ex�cuter : mutationsParEchange([1,2,3,4,5],_461)
%%% Position P1 et P2 (pour mutation par �change): 2 4
%%% Imute = [1,4,3,2,5]
mutation(I1, Imuter):-
    param(fMutation, FMutation),
    But=..[FMutation,I1,Imuter],
    %format("But à executer : ~p",[But]),nl,
    But.
%mutation(I1, Imuted):-
%    param(fMutation, mutationAdjacence),
%    mutationAdjacence(I1, Imuted),!.
%mutation(I1, Imuted):-
%    param(fMutation, mutationEchange),
%    mutationEchange(I1, Imuted),!.



%      MUTATIONS ADJACENCES CASSÉ



%************************************************
%**********DEBUT mutations d'adjacences**********
%************************************************
%%%Inversion du segment (TR2) situe entre deux positions P1 et P2 (incluses):
%%% TR1:TR2:TR3  devient  TR1:invTR2:TR3
%mutationsAdjacence(+I1,-I1mut�e)
%%% | ?- mutationAdjacence([1,2,3,4,5,6,7,8,9,10],M).
%%% Position P1 et P2 (pour mutation d'adjacence): 3 9
%%% M = [1,2,9,8,7,6,5,4,3,10] ?
mutationAdjacence(I1, Imuted):-
    %param(taillePopulation,Max),
    generateRandomPositions(P1, P2),
    mutationAdjacence(I1, P1, P2, Imuted),!.
% cas P1>1 && P2==Size % CACA
mutationAdjacence(Liste, P1, P2, Res):-
    P1>1,
    length(Liste, Size),				        % taille de la liste
    P2=Size,							              % P2 est la fin de la liste, pas de tail
    subList(Liste,1,P1, Head),			    % Head
    P1PP is P1 + 1,
    subList(Liste, P1PP, P2, ToReverse),	% sous liste a inverser
	  reverse(ToReverse, Reversed),	      % sous liste inversee
    append(Head, Reversed, Res),!.		  % concat head+reversed
% cas P1==1 && P2<Size
mutationAdjacence(Liste, P1, P2, Res):-
    P1=1,								% P1 est la tete de liste, pas de head
    length(Liste, Size),				% taille de la liste
    P2<Size,
    subList(Liste, P1, P2, ToReverse),	% sous liste a inverser
    reverse(ToReverse, Reversed),		% sous liste inversee
    P2PP is P2 + 1,
    subList(Liste, P2PP, Size, Tail),	% Tail
    append(Reversed, Tail, Res),!.		% concat reversed+tail
% cas P1>1 && P2<Size % CACA
mutationAdjacence(Liste, P1, P2, Res):-
    P1>1,
    length(Liste, Size),				% taille de la liste
    P2<Size,
    subList(Liste,1,P1, Debut),			% Head
    P1PP is P1 + 1,
    subList(Liste, P1PP, P2, ToReverse),	% sous liste a inverser
	  reverse(ToReverse, Reversed),		% sous liste inversee
    P2PP is P2 + 1,
    subList(Liste, P2PP, Size, Tail),	% Tail
    append(Debut, Reversed, Head),		% concat head+reversed
	append(Head, Tail, Res),!.			% concat (head+reversed)+tail
% cas P1==1 && P2==Size
mutationAdjacence(Liste, P1, P2, Res):-
    P1=1,
    length(Liste, Size),				% taille de la liste
    P2=Size,
    reverse(Liste, Res),!.				% liste entierement inversee

%************************************************
%**************** FIN mutations d'adjacences ***
%************************************************

%************************************************
%**************** DEBUT mutations par �change *****
%************************************************
%%% Echange des valeurs situ�es en P1 et P2 (positions tir�es au sort)
%mutationsParEchange(+I,-Imut�e)
%%% | ?- mutationEchange([1,2,3,4,5,6,7,8,9,10],M).
%%% Position P1 et P2 (...): 2 5
%%% M = [1,5,3,4,2,6,7,8,9,10] ?
mutationEchange(Liste, Res):-
    %param(taillePopulation,Max),
    generateRandomPositions(P1, P2),
    mutationEchange(Liste, P1, P2, Res).
mutationEchange(Liste, P1, P2, Res):-
    nth1(P1, Liste, E1),
    nth1(P2, Liste, E2),
    select(E2, Liste, E1, L1),!,
    select(E1, L1, E2, L2),!,
    Res = L2.

%************************************************
%**************** FIN mutations par �change *******
%************************************************
