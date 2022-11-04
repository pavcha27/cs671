% 
% SCRIPT: sparse_MM.m 
%
% sparse matrix-matrix multiplication

function s = sparse_function(m, n, nnz_row)
    
    times = zeros(4);
    
%     fprintf('\n\n   %s started \n', mfilename ); 
    
    %% 
%     fprintf('\n   generate a sparse matrix and store it in sparse and full formats \n');
    
    As  = sprand( m, n, nnz_row/n ) ; 
    
    Af  = full( As ); 
    
    %% 
    
%     fprintf('\n   get two gram matrices in sparse storage form'); 
    tic 
    As2c = As' * As ; 
    As2r = As  * As'; 
    times(1,1) = toc ;
    
    
%     fprintf('\n   get two gram matrices in full storage form'); 
    tic 
    Af2c = Af' * Af ; 
    Af2r = Af  * Af' ; 
    times(2,1) = toc; 
    
    fprintf('\n   elapsed time: [MM_ss, MM_ff] = [%g, %g]', times(1,1), times(2,1) ) ; 
    
    
%     fprintf('\n\n   get two cross-products \n');
    
    tic 
    Psf = As * Af' ;
    times(3,1) = toc; 
    
    tic
    Pfs = Af * As' ;
    times(4,1) = toc; 
    
    fprintf('\n   elapsed time: [MM_sf, MM_fs] = [%g, %g]', times(3,1), times(4,1) ) ; 
    
    
%     fprintf('\n\n   %s ended \n\n', mfilename ); 
    
    % return
    
    s = times;

end

%% ================= END of script ====================================
%% Programmer Xiaobai Sun 
%% Jan. 2022 





