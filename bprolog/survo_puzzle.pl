/*

  Survo puzzle in B-Prolog.

  http://en.wikipedia.org/wiki/Survo_Puzzle
  """
  Survo puzzle is a kind of logic puzzle presented (in April 2006) and studied 
  by Seppo Mustonen. The name of the puzzle is associated to Mustonen's 
  Survo system which is a general environment for statistical computing and 
  related areas.
  
  In a Survo puzzle the task is to fill an m * n table by integers 1,2,...,m*n so 
  that each of these numbers appears only once and their row and column sums are 
  equal to integers given on the bottom and the right side of the table. 
  Often some of the integers are given readily in the table in order to 
  guarantee uniqueness of the solution and/or for making the task easier.
  """
  
  See also
  http://www.survo.fi/english/index.html
  http://www.survo.fi/puzzles/index.html
 
  References:
  Mustonen, S. (2006b). "On certain cross sum puzzles"
  http://www.survo.fi/papers/puzzles.pdf 
  Mustonen, S. (2007b). "Enumeration of uniquely solvable open Survo puzzles." 
  http://www.survo.fi/papers/enum_survo_puzzles.pdf 
  Kimmo Vehkalahti: "Some comments on magic squares and Survo puzzles" 
  http://www.helsinki.fi/~kvehkala/Kimmo_Vehkalahti_Windsor.pdf
  R code: http://koti.mbnet.fi/tuimala/tiedostot/survo.R

  Model created by Hakan Kjellerstrand, hakank@gmail.com
  See also my B-Prolog page: http://www.hakank.org/bprolog/

*/



pretty_print(X, RowSums, ColSums) :-
        [N,M] @= [X^length, X[1]^length],

        foreach(I in 1..N,
                [R],
                (
                    foreach(J in 1..M,
                            [XX],
                            (
                                XX is X[I,J],
                                format('~2d ', XX)
                            )
                           ),
                    R is RowSums[I],
                    write(' = '), writeln(R)
                )
               ),
        nl,
        foreach(K in 1..M, 
                [C],
                (
                    C is ColSums[K],
                    format('~2d ', C)
                )
        ),
        nl,nl.


survo_puzzle(Num) :-

        writeln('\nProblem:':Num),
        problem(Num, RowSums, ColSums, Problem),
        [R,C] @= [Problem^length, Problem[1]^length],
        ProblemVar @= [P : I in 1..R, J in 1..C, [P], P @= Problem[I,J]],
        ProblemVar :: 1..R*C,

        % get rowsums
        foreach(I in 1..R,
                RowSums[I] #= sum([P : J in 1..C, [P], P @= Problem[I,J]])
        ),
        % get colsums
        foreach(J in 1..C,
                ColSums[J] #= sum([P : I in 1..R, [P], P @= Problem[I,J]])
        ),
        alldifferent(ProblemVar),

        labeling(ProblemVar),

        pretty_print(Problem, RowSums, ColSums).


go :-
        survo_puzzle(1),
        survo_puzzle(2).


go2 :-
        foreach(P in 1..5,
                time(survo_puzzle(P))).

%
% Data
%

% http://en.wikipedia.org/wiki/Survo_Puzzle, first example
%
% Solution:
%  12 6 2 10
%  8 1 5 4
%  7 9 3 11
%
problem(1,
        [](30,18,30),      % rowsums
        [](27,16,10,25),   % colsums
        []([](_, 6, _, _), % the problem
           [](8, _, _, _),
           [](_, _, 3, _))).



% http://en.wikipedia.org/wiki/Survo_Puzzle, second example
% difficulty 0
problem(2, 
        [](9, 12),       % rowsums
        [](9, 7, 5),     % colsums
        []([](_, _, 3),  % problem
           [](_, 6, _))).
        


% http://en.wikipedia.org/wiki/Survo_Puzzle, third example
% difficulty 150 ("open puzzle", i.e. no hints)
% It's an unique solution.
% (817 propagations with Gecode/fz, and 33 failures, 88 commits)
% r = 3;
% c = 4;
% rowsums = [24,15,39];
% colsums = [21,10,18,29];
% matrix = array2d(1..r, 1..c, 
%   [
%     0, 0, 0, 0,
%     0, 0, 0, 0,
%     0, 0, 0, 0
%   ]);
% Note: this version has no hints
problem(3, 
        [](24,15,39),      % rowsums
        [](21,10,18,29),   % colsums
        []([](_, _, _, _), % problem
           [](_, _, _, _),
           [](_, _, _, _))).




% same as above but with hints: difficulty 0
% (15 propagations with Gecode/fz, no failures, no commits)
% matrix = array2d(1..r, 1..c, 
%    [
%      7, 0, 5, 0,
%      0, 1, 0, 8,
%      0, 0, 11, 0
%    ]);
problem(4, 
        [](24,15,39),      % rowsums
        [](21,10,18,29),   % colsums
        []([](7, _, 5, _), % problem
           [](_, 1, _, 8),
           [](_, _, 11, _))).



% http://en.wikipedia.org/wiki/Survo_Puzzle, under "Swapping method"
% (open puzzle)
% Gecode/fz: 13374 propagations, 706 failures
% r = 4;
% c = 4;
% rowsums = [51,36,32,17];
% colsums = [51,42,26,17];
% matrix = array2d(1..r, 1..c, 
%   [
%     0, 0, 0, 0,
%     0, 0, 0, 0,
%     0, 0, 0, 0,
%     0, 0, 0, 0
%   ]);


% http://www.survo.fi/puzzles/280708.txt, third puzzle
% Survo puzzle 128/2008 (1700) #364-35846
%
%    A  B  C  D  E  F
% 1  *  *  *  *  *  * 30
% 2  *  * 18  *  *  * 86
% 3  *  *  *  *  *  * 55
%   22 11 42 32 27 37
problem(5, 
        [](30, 86, 55),             % rowsums
        [](22, 11, 42, 32, 27, 37), % colsums
        []([](_, _,  _, _, _, _),   % problem
           [](_, _, 18, _, _, _),
           [](_, _,  _, _, _, _))).
