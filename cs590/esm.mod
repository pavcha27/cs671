set BIDS;
set STATES;

param v{b in BIDS};
param p{b in BIDS, s in STATES};

var accepted{b in BIDS}, binary;
var worst_case_profit;

maximize worst: worst_case_profit;

s.t. accepted_once{b in BIDS}: accepted[b] <= 1;
s.t. payout_formula{s in STATES}: sum{b in BIDS} accepted[b]*(v[b] - p[b,s]) >= worst_case_profit;

data;

set BIDS := b1 b2 b3 b4 b5;
set STATES := s1 s2 s3 s4;

param v := b1 3 b2 4 b3 5 b4 3 b5 1;
param p:
    s1  s2  s3  s4 :=
b1  0   0   11  0
b2  0   2   0   8
b3  9   9   0   0
b4  6   0   0   6
b5  0   0   0   10;
