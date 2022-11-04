function [I, residual, k] = ...
    poissonSolverJacobi( I, mskTgt, mixedDivG, maxIter, tauDiff )
%
% poissonSolverJacobi -- Jacobi iterative solver for poisson equation
%   
% SYNTAX
%
%   [IGrad, residual, k] = ...
%       poissonSolverJacobi( I, mskTgt, mixedDivG, maxIter, tauDiff )
%
% INPUT
%
%   I           Image to be edited                      [M-by-N]
%   Mask        Mask of the solution domain             [M-by-N, logical]
%   mixedDivG   Mixed divergence of the gradients       [M-by-N]
%   maxIter     The maximum iteration of the solver     [integer]
%   tau         The error tolerance level               [scalar]
%
% OUTPUT
%
%   I           Edited image                            [M-by-N]
%   residual    Average residual (in Frobenius norm)    [scalar]
%   k           The maximum iteration number reached    [scalar]
%
% DESCRIPTION
%
%   [I, residual, k] = poissonSolverJacobi( I, mskTgt, mixedDivG, ...
%   maxIter, tauDiff ) solves the poisson equation using Jacobi 
%   iteration. 
%   
% REFERENCE(S)
%
%   Perez, Patrick, Michel Gangnet, and Andrew Blake. 
%   "Poisson image editing." ACM Transactions on Graphics (TOG). 
%   Vol. 22. No. 3. ACM, 2003.
%
%  
    
    mIdx = find(mskTgt);
    nPixel = nnz(mIdx);
    sizeI = size(I);

    for k = 1: maxIter
        
        % previous-step solution
        prev = I(mIdx);


        I(mIdx) = ( I(mIdx + 1) + I(mIdx - 1) + ...
                    I(mIdx + sizeI(1)) + I(mIdx - sizeI(1)) - ...
                    mixedDivG(mIdx) ) / 4;
                
        % termination criteria: in terms of 2-norm
        residual = norm( ( I(mIdx) - prev ), 'fro' )  / nnz(nPixel);
        if ( residual ) < tauDiff
            break
        end
        
        
    end
    
end

%%------------------------------------------------------------
%
% AUTHORS
%
%   Tiancheng Liu       tcliu@cs.duke.edu
%   Numerical Analysis, Spring 2020
%
% ------------------------------------------------------------
