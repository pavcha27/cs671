set ROUTES;
set BIDS;

param max_number_of_routes_allowed;
param contained_in{r in ROUTES, b in BIDS};
param value{b in BIDS};

var accepted{b in BIDS}, binary;
var kept{r in ROUTES}, binary;

maximize total_value: sum{b in BIDS} accepted[b]*value[b];

s.t. less_than_max: sum{r in ROUTES} kept[r] <= max_number_of_routes_allowed;

s.t. consistent{b in BIDS}: accepted[b] <= ((sum{r in ROUTES} kept[r]*contained_in[r, b])/(sum{r in ROUTES} contained_in[r, b]));

data;

set ROUTES := a b c d e f g;
set BIDS := v w x y z;

param max_number_of_routes_allowed := 4;

param contained_in: v   w   x   y   z :=
                a   1   1   1   0   0
                b   1   0   0   1   0
                c   1   0   1   0   0
                d   0   1   0   0   0
                e   0   1   0   0   1
                f   0   1   0   0   1
                g   0   0   1   1   1;

param value := v 5 w 10 x 3 y 3 z 6;