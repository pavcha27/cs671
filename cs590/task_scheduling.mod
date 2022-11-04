set TASKS;

param max_time;
param time_between{i in TASKS, j in TASKS};
var scheduled_time{i in TASKS}, >=0;
var last_time;
var earlier_than{i in TASKS, j in TASKS}, binary;

minimize total_time: last_time;

s.t. one_earlier{i in TASKS, j in TASKS}: 
	earlier_than[i,j]+earlier_than[j,i] <= 1;

s.t. last_one{i in TASKS}: last_time >= scheduled_time[i];

s.t. time_difference_constraint{i in TASKS, j in TASKS}: 
	# YOUR TASK IS TO COMPLETE THIS
	# similar code to hotdog problem: only bind constraint when i is before j
	# in the case when j is before i, add max_time to unbind the constraint!
	scheduled_time[j] - scheduled_time[i] - time_between[i,j] + max_time*earlier_than[j,i] >= 0;

data;

set TASKS := tA tB tC;

param max_time := 100;
param time_between :
	tA	tB	tC :=
tA 	0	10	10
tB	8	0	4
tC	5	10	0;

end;
