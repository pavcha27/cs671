% demo_root_Basins.m 
% SCRIPT 
% 
% Callee function 
%    root_Basins( ... ) 
%    root_res_scale( ... ) 

close all 
clear all

%% 

fprintf( '\n\n   %s BEGAN \n\n', mfilename ); 

%% 

alpha1 = 5 - 1i*8;                    % a small number 
alpha2 = 511 + 1i* 137 ;              % not a small number

mycase = input( '\n   choose a prefixed study case [1,5] = ' ) ; 

switch mycase 
    case 1 
        nth   = 6 ; 
        u_res = 1 ; 
        alpha = alpha1 ; 
    case 2 
        nth   = 5 ; 
        u_res = 1; 
        alpha = alpha1 ; 
    case 3 
        nth   = 5 ; 
        u_res = 1.1; 
        alpha = alpha1 ; 
    case 4 
        nth   = 5 ; 
        u_res = 1; 
        alpha = alpha2; 
    case 5 
        nth    = 5 ;
        u_res  = 1.5 ; 
        alpha  = alpha2; 
    otherwise
                
end


%%   input arguments for root extratiion to be chosen  

 nth   = input( '   Specify the root order ( nth > 1 ) =  ' ); 
%  alpha = input( '   Enter a (complex) number alpha + i* beta = ' ); 
%  u_res = input( '   Choose a resolution unit = ' );                  

[ beta, u_beta ] = root_res_scale( alpha, u_res, nth ); 

%% ... decompose search domain and make distributed initial guesses 

m        = 512 ;  % grid size 
iterMax  = 11 ;   % max. iteration number 


%% ... generate initial values at the grid points 

fprintf( '\n\n   generate a grid of initial values ' );

a     = linspace( -1, 1, m )' ;               % equispaced samle points 

X0    = ones(m,1) * a' + 1i * a * ones(1,m) ;  % grid points in Complex plane
X0    = beta * X0;

Xk2   = root_Basins( beta , nth, X0, iterMax ) ; 

Xk    = u_beta * Xk2;

fprintf( '\n\n   %s FINISHED \n\n', mfilename ); 

%% -----------------------------
%   Programmer : 
%    Xiaobai Sun 
%    Duke CS 
%    Last revision : 
%    March 2021 
% ----------------------------