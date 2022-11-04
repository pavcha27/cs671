set CUSTOMERS;
set STANDS;

param total_stretch;
param willing_to_walk{i in CUSTOMERS};
param demand{i in CUSTOMERS};
param location{i in CUSTOMERS};

var served{i in CUSTOMERS}, binary;
var served_by{i in CUSTOMERS, j in STANDS}, binary;
var placement{j in STANDS};

maximize demand_served: sum{i in CUSTOMERS} served[i]*demand[i];

s.t. service{i in CUSTOMERS}: sum{j in STANDS} served_by[i,j] - served[i] >= 0;

s.t. reach_to_left{i in CUSTOMERS, j in STANDS}: location[i] - placement[j] - willing_to_walk[i] - total_stretch + total_stretch*served_by[i,j] <= 0;

s.t. reach_to_right{i in CUSTOMERS, j in STANDS}: placement[j] - location[i] - willing_to_walk[i] - total_stretch + total_stretch*served_by[i,j] <= 0;

data;

# code that was changed from class
# 8 customers
set CUSTOMERS := c1 c2 c3 c4 c5 c6 c7 c8;

# 3 stands to place
set STANDS := s1 s2 s3;

# set parameters given in problem
param total_stretch := 50;
param willing_to_walk := c1 2 c2 3 c3 2 c4 1 c5 2 c6 6 c7 1 c8 7;
param demand := c1 5 c2 2 c3 4 c4 5 c5 2 c6 4 c7 3 c8 5;
param location := c1 3 c2 5 c3 6 c4 8 c5 10 c6 11 c7 12 c8 15;

end;
