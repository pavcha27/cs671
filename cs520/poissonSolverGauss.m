function [I, residual, k] = ...
    poissonSolverGauss( I, mskTgt, mixedDivG, maxIter, tauDiff )
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
    base = I(mIdx);
    arr = mIdx;

 % Using gauss-scheidel methods (new update each time)

for k = 1:maxIter
    prev = I(mIdx);
    for w = 1:length(arr)
        I(arr(w)) = ((I(arr(w)+1) + I(arr(w) - 1) + ...
            I(arr(w)+sizeI(1)) + I(arr(w )- sizeI(1)) - ...
            (mixedDivG(arr(w))) ) / 4);

%     for k = 1: maxIter
% 
%         for w = mIdx
%             I(w) = ((I(w + 1) + I(w - 1) + ...
%                   I(w + sizeI(1)) + I(w - sizeI(1)) - ...
%                   (mixedDivG(w)) ) / 4);
%             

        % previous-step solution
        %prev = I(mIdx);

        % update step
        %I(mIdx) = ((I(mIdx + 1) + I(mIdx - 1) + ...
        %            I(mIdx + sizeI(1)) + I(mIdx - sizeI(1)) - ...
        %            (mixedDivG(mIdx)) ) / 4);

    
    end
    
    residual = norm( ( I(mIdx) - prev ), 'fro' )  / nnz(nPixel);
    if ( residual ) < tauDiff
        break
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
