# outcomes
set OUTCOMES;
# probability distribution over the outcomes
set DISTRIBUTIONS;

# this will hold the probabilities of each outcome for each preference
param probs{d in DISTRIBUTIONS, o in OUTCOMES};
# save which preference is preferred to which others
param prefs{d1 in DISTRIBUTIONS, d2 in DISTRIBUTIONS};
# value that is larger than all others
param large_val;

# calculate the utilities of each outcome
var u{o in OUTCOMES}, >=0, <=1;

# margin between constraint
var eps;

# maximize margin of constraint
maximize margin: eps;

# every ordering has to have at most one distribution (and make sure no negatives)
s.t. one_preferred_lesser{d1 in DISTRIBUTIONS, d2 in DISTRIBUTIONS}: prefs[d1,d2] + prefs[d2,d1] <= 1;
s.t. one_preferred_greater{d1 in DISTRIBUTIONS, d2 in DISTRIBUTIONS}: prefs[d1,d2] + prefs[d2,d1] >= 0;

# every distribution sums to 1
s.t. valid_dist{d in DISTRIBUTIONS}: sum{o in OUTCOMES} probs[d,o] = 1;

# consistency
s.t. consistent{d1 in DISTRIBUTIONS, d2 in DISTRIBUTIONS}: large_val - large_val*prefs[d1,d2] + sum{o in OUTCOMES} ((probs[d1,o] - probs[d2,o])*u[o]) >= eps;

data;

set OUTCOMES := a b c d;
set DISTRIBUTIONS := d1 d2 d3 d4 d5 d6 d7 d8;

param probs:    a   b   c   d :=
            d1  0.1 0.2 0.3 0.4
            d2  0.1 0.2 0.4 0.3
            d3  0.4 0.4 0.1 0.1
            d4  0.4 0.2 0.2 0.2
            d5  0.6 0.1 0   0.3
            d6  0.4 0.3 0.3 0
            d7  0.4 0.3 0.2 0.1
            d8  0.5 0.5 0   0;

param prefs:    d1  d2  d3  d4  d5  d6  d7  d8 :=
            d1  0   1   0   0   0   0   0   0
            d2  0   0   0   0   0   0   0   0
            d3  0   0   0   1   0   0   0   0
            d4  0   0   0   0   0   0   0   0
            d5  0   0   0   0   0   1   0   0
            d6  0   0   0   0   0   0   0   0
            d7  0   0   0   0   0   0   0   1
            d8  0   0   0   0   0   0   0   0;

param large_val := 100;