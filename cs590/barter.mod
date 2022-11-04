set AGENTS;
set ITEMS;

param value{a in AGENTS, i in ITEMS};
param currently_owns{a in AGENTS, i in ITEMS};

var obtains{a in AGENTS, i in ITEMS}, binary;
var epsilon, >= 0;

maximize margin: epsilon;

s.t. at_most_once{i in ITEMS}: sum{a in AGENTS} obtains[a,i] <= 1;
s.t. at_least_once{i in ITEMS}: sum{a in AGENTS} obtains[a,i] >= 1;

s.t. consistent{a in AGENTS}: sum{i in ITEMS} (obtains[a,i] - currently_owns[a,i])*value[a,i] >= epsilon;

data;

set AGENTS := me you;
set ITEMS := a b c;

param value:    a   b   c :=
            me  2   2   2
            you 4   1   0;

param currently_owns:   a   b   c :=
                    me  1   0   0
                    you 0   1   1;