set ITEMS;
set BIDDERS;
set POSITIVE_HYPEREDGES;
set NEGATIVE_HYPEREDGES;

param positive_valuation{b in BIDDERS, e in POSITIVE_HYPEREDGES};
param negative_valuation{b in BIDDERS, e in NEGATIVE_HYPEREDGES};
param occurs_in_positive{i in ITEMS, e in POSITIVE_HYPEREDGES};
param occurs_in_negative{i in ITEMS, e in NEGATIVE_HYPEREDGES};
param num_items;

var assigned{b in BIDDERS, i in ITEMS}, binary;
var positive_applies{b in BIDDERS, e in POSITIVE_HYPEREDGES}, binary;
var negative_applies{b in BIDDERS, e in NEGATIVE_HYPEREDGES}, binary;

maximize efficiency: sum{b in BIDDERS} (sum{p in POSITIVE_HYPEREDGES} positive_valuation[b,p]*positive_applies[b,p] - sum{n in NEGATIVE_HYPEREDGES} negative_valuation[b,n]*negative_applies[b,n]);

s.t. assign_once{i in ITEMS}: sum{b in BIDDERS} assigned[b,i] <= 1;

s.t. positive_constraint{b in BIDDERS, e in POSITIVE_HYPEREDGES}:  num_items * positive_applies[b,e] + sum{i in ITEMS} occurs_in_positive[i,e] - sum{i in ITEMS} occurs_in_positive[i,e] * assigned[b,i] <= num_items;

s.t. negative_constraint{b in BIDDERS, e in NEGATIVE_HYPEREDGES}:  num_items * negative_applies[b,e] + sum{i in ITEMS} occurs_in_negative[i,e] - sum{i in ITEMS} occurs_in_negative[i,e] * assigned[b,i] >= 1;

data;

set ITEMS := i_1 i_2 i_3 i_4 i_5;
set BIDDERS := b_1 b_2 b_3;
set POSITIVE_HYPEREDGES := p_1 p_2 p_3 p_4 p_5 p_6 p_7;
set NEGATIVE_HYPEREDGES := n_1 n_2;

param positive_valuation:
      p_1 p_2 p_3 p_4 p_5 p_6 p_7 :=
b_1    2   1   2   1   2   3   2
b_2    2   1   3   3   2   1   1
b_3    1   3   1   1   2   1   0;

param negative_valuation:
      n_1 n_2 :=
b_1    2   2
b_2    1   1
b_3    3   1;

param occurs_in_positive:
      p_1 p_2 p_3 p_4 p_5 p_6 p_7 :=
i_1    1   0   0   0   0   1   0
i_2    0   1   0   0   0   0   1
i_3    0   0   1   0   0   0   0
i_4    0   0   0   1   0   0   1
i_5    0   0   0   0   1   1   0;

param occurs_in_negative:
      n_1 n_2 :=
i_1    0   1
i_2    0   0
i_3    1   1
i_4    1   0
i_5    0   1;

param num_items := 5;

end;

