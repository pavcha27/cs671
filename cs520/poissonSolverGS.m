function [I, residual, k] = ...
    poissonSolverGS( I, mskTgt, mixedDivG, maxIter, tauDiff )
    
    mIdx = find(mskTgt);
    nPixel = nnz(mIdx);
    sizeI = size(I);
    
    for k = 1: maxIter
        
        % previous-step solution
        prev = I(mIdx);
        
        %   Grid setup
        %   a   b   c
        %   d   *   f
        %   g   h   i
        %
        %   to update *:
        %       a = c = g = i = 0
        %       b, d have already been updated
        %       f, h have not been updated
        


        for i = 1:size(mIdx,1)
            I(mIdx(i)) = ( I(mIdx(i) + 1) + I(mIdx(i) - 1) + ...
                    I(mIdx(i) + sizeI(1)) + I(mIdx(i) - sizeI(1)) - ...
                    mixedDivG(mIdx(i)) ) / 4;
        end

%         I(mIdx) = new(mIdx);
                
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
