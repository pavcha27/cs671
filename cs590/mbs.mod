set VOTES;
set OTHER_ALTERNATIVES;

param special_score{v in VOTES};
param other_score{v in VOTES, a in OTHER_ALTERNATIVES};

var removed_votes{v in VOTES}, binary;

minimize modified_score: sum{v in VOTES} removed_votes[v];

s.t. special_win{a in OTHER_ALTERNATIVES}: sum{v in VOTES} ((special_score[v] - other_score[v,a]) * (1 - removed_votes[v])) >= 0;

data;
set VOTES := v1 v2 v3 v4;
set OTHER_ALTERNATIVES := a b;
param special_score := v1 1 v2 1 v3 0 v4 1;
param other_score: a b :=
                v1 2 0
                v2 2 0
                v3 1 2
                v4 0 2;
end;

// a c b
// a c b
// b a c
// b c a