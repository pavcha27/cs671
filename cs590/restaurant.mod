set RESTAURANTS;
set PEOPLE;

param val_rest{p in PEOPLE, r in RESTAURANTS};
param val_together{p in PEOPLE, q in PEOPLE};

var is_rest{p in PEOPLE, r in RESTAURANTS}, binary;
var is_together{p in PEOPLE, q in PEOPLE}, binary;

maximize utility: sum{p in PEOPLE} ((sum{r in RESTAURANTS} val_rest[p,r]*is_rest[p,r]) + (sum{q in PEOPLE} val_together[p,q]*is_together[p,q]));

s.t. one_rest{p in PEOPLE}: sum{r in RESTAURANTS} is_rest[p,r] <= 1;

s.t. together1{p in PEOPLE, q in PEOPLE, r in RESTAURANTS}: is_together[p,q] <= (1 - (is_rest[p, r] - is_rest[q,r]));

s.t. together2{p in PEOPLE, q in PEOPLE, r in RESTAURANTS}: is_together[p,q] <= (1 - (is_rest[q, r] - is_rest[p,r]));

data;

set RESTAURANTS := f i m;
set PEOPLE := a b c;

param val_rest :    f   i   m :=
                a   10  0   0
                b   0   12  0
                c   0   0   11;

param val_together :    a   b   c :=
                    a   0   8   0
                    b   0   0   7
                    c   9   0   0;                