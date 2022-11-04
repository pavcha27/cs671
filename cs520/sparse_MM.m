% 
% SCRIPT: sparse_MM.m 
%
% sparse matrix-matrix multiplication

fprintf('\n\n   %s started \n', mfilename ); 

%% 
fprintf('\n   generate a sparse matrix and store it in sparse and full formats \n');   

input_default = 1; 

if input_default 
   m = 5000;        % # of rows 
   n = 4111;        % # of columns 
   nnz_row = 11;    % expected nnz per row 
else 
   m = input('enter the number of rows'); 
   n = input('enter the number of columns'); 
   nnz_row  = input('enter nnz per row'); 
end 

As  = sprand( m, n, nnz_row/m ) ; 

Af  = full( As ); 

%% 

fprintf('\n   get two gram matrices in sparse storage form'); 
tic 
As2c = As' * As ; 
As2r = As  * As'; 
tmm_ss = toc ;


fprintf('\n   get two gram matrices in full storage form'); 
tic 
Af2c = Af' * Af ; 
Af2r = Af  * Af' ; 
tmm_ff = toc; 

fprintf('\n   elapsed time: [MM_ss, MM_ff] = [%g, %g]', tmm_ss, tmm_ff ) ; 

%%
fprintf('\n\n   get two cross-products \n');

tic 
Psf = As * Af' ;
tmm_sf = toc; 

tic
% Pfs = Af * As' ;
Pfs = Psf';
tmm_fs = toc; 

fprintf('\n   elapsed time: [MM_sf, MM_fs] = [%g, %g]', tmm_sf, tmm_fs ) ; 


fprintf('\n\n   %s ended \n\n', mfilename ); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

% Take advantage of symmetry by squaring
tic
mult = As2c' * As2c;
time_multiply = toc;

fprintf('\n\n   SPARSE: elapsed time if we multiply: [%g] \n\n', time_multiply ) ; 

tic
decomp = As2c^2;
time_square = toc;

fprintf('\n\n   SPARSE: elapsed time if we square: [%g]\n\n', time_square ) ; 

tic
mult = Af2c' * Af2c;
time_multiply = toc;

fprintf('\n\n   FULL: elapsed time if we multiply: [%g] \n\n', time_multiply ) ; 

tic
decomp = Af2c^2;
time_square = toc;

fprintf('\n\n   FULL: elapsed time if we square: [%g]\n\n', time_square ) ; 


return 

%% ================= END of script ====================================
%% Programmer Xiaobai Sun 
%% Jan. 2022 





