%
function yc = interp0( x1, y1, xq )
% yc = interp0( x1, y1, xq ); 
% 
% Input 
% x1, y1: input sample data to be upsampled 
% xq    : query locations for upsampling 
%         x1 and xq each is in increasing ordering 
% Output 
% yc    : the interpolated values at query locations of xq 
% 
% Interpolation method: 
%      upsampling by constant of the mid-value 
%      with the least assumption on the relationship between x1 and xq 

%%
n1 = length(x1); 
nq = length(xq); 
yc = zeros(nq,1);

j = 1; 
 
%%
while xq(j) < x1(1)              % the left-most interval  
      yc(j) = y1(1);
      j = j+1;
end
  
%%
for k = 1:n1-1                   % the middle intervals 
      while (j > 1 & j <= nq)  & xq(j) >= x1(k) & xq(j) < x1(k+1) 
          yc(j) = ( y1(k) + y1(k+1) )/2;
          j    = j+1; 
      end
end

%% 
while j <= nq & xq(j) >= x1(n1) % the right-most interval 
      yc(j) = y1(n1);
      j = j+1;
end

%% 
return 


%% ===============================================
%% Programmer: 
%  Xiaobai Sun 
%  Duke CS 
%  For the class of Numerical (Data) Analysis 
%  Feb., 2022 
%  