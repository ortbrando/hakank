/*

  Set covering in B-Prolog.

  Placing of firestations, from Winston "Operations Research", page 486


  Model created by Hakan Kjellerstrand, hakank@gmail.com
  See also my B-Prolog page: http://www.hakank.org/bprolog/

*/

go :-
        problem(1, MinDistance, Distance),

        writeln(min_distance:MinDistance),

        % distance between the cities
        NumCities @= Distance^length,
        writeln(num_cities:NumCities),

        % where to place the fire stations: 1 if placed in this city.
        length(X, NumCities),
        X :: 0..1,

        % calculate the number of covered fire stations
        foreach(J in 1..NumCities,
                sum([X[I] : I in 1..NumCities, Distance[I,J] #=< MinDistance]) #>= 1
        ),

        % objective: minimize the number of fire stations
        Z #= sum(X),
        writeln(here1),
        minof(labeling(X),Z),
        writeln(z:Z),
        writeln(x:X).


%
% data
%

%
% Placing of firestations, from Winston "Operations Research", page 486
%
problem(1,
        15, % minimum distance 
        []([](0,10,20,30,30,20),  % distances between the cities
           [](10,0,25,35,20,10),
           [](20,25,0,15,30,20),
           [](30,35,15,0,15,25),
           [](30,20,30,15,0,14),
           [](20,10,20,25,14,0))).
