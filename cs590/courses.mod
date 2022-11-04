######################
# given code
set REQUIREMENTS;
set COURSES;

param points_required{i in REQUIREMENTS};
param points_contributed{i in REQUIREMENTS, j in COURSES};
param effort{j in COURSES};
#####################
# check whether course is taken or not
# add integer in here for integrality version
var course_taken{j in COURSES}, >=0, <=1;

# minimize effort
minimize total_effort: sum{j in COURSES} effort[j]*course_taken[j];

# need to meet all requirements
s.t. 
reqs_met{i in REQUIREMENTS}: sum{j in COURSES} points_contributed[i,j]*course_taken[j] >= points_required[i];

data;

# set up details from problem
set REQUIREMENTS := natural_sciences social_sciences humanities;
set COURSES := neuroscience history biophysics global_warming;


param points_required := natural_sciences 10 social_sciences 10 humanities 10;

param points_contributed :
			neuroscience 	history 	biophysics 	global_warming :=
natural_sciences	8		3		5		4
social_sciences		6		6		3		2
humanities		4		8		1		2;


param effort := neuroscience 5 history 5 biophysics 2 global_warming 2;

end;
