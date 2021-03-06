/*
  Tue Jan  1 18:24:42 2008/hakank@bonetmail.com

  Winston OR, page 478: Capital budgeting.
  This is a knapsack problem


This AMPL model was created by Hakan Kjellerstrand, hakank@gmail.com
See also my AMPL page: http://www.hakank.org/ampl/


*/

set stocks;
var x{stocks} binary;
param npv{stocks} >= 0;
param budget >= 0;
param cash_flow{stocks} >= 0; 

maximize z:
        sum{i in stocks} x[i]*npv[i];

subject to c1:
        sum{i in stocks} x[i]*cash_flow[i] <= budget;

data;

param budget := 14;

param: stocks: npv cash_flow := 
        1 16 5
        2 22 7
        3 12 4
        4  8 3 
        
;


# option cplex_option "sensitivity";
option solver cplex;
# option solver minos;
# option solver cbc;
# option solver snopt;
# option solver gjh;
# option solver ipopt;
# option solver bonmin;
# option solver lpsolve;
# option solver donlp2;
# option solver loqo;

solve;

display z;
display x;

#display _obj;
#display _varname, _var, _var.rc, _var.lb, _var.ub, _var.slack;
#display _conname, _con, _con.lb, _con.ub, _con.slack;
#display _varname, _var, _var.rc, _var.lb, _var.ub, _var.slack, _var.down, _var.current, _var.up;
#display _conname, _con, _con.lb, _con.ub, _con.slack, _con.down, _con.current, _con.up;
