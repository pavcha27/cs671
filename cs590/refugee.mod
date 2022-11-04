set FAMILIES;
set STATES;
set NEEDS;

var x{f in FAMILIES, S in STATES}, binary;

param v{f in FAMILIES};
param a{s in STATES, n in NEEDS};
param d{f in FAMILIES, n in NEEDS};

maximize value: sum{s in STATES} (sum{f in FAMILIES} x[f,s]*v[f]);

s.t. one_state{f in FAMILIES}: sum{s in STATES} x[f,s] <= 1;

s.t. available{s in STATES, n in NEEDS}: sum{f in FAMILIES} x[f,s]*d[f,n] <= a[s,n];

data;

set STATES := a b;
set FAMILIES := one two three four;
set NEEDS := school housing;

param v := one 2 two 4 three 3 four 3;

param a:    school  housing :=
        a   4       3
        b   3       2;

param d:        school  housing :=
        one     2       1
        two     3       3
        three   2       2
        four    3       1;