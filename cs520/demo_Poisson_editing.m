
%
% script_poission_editing.m
% Poisson Image Editing Demo
%
% Compsci 520, 2020 Spring
% Tiancheng Liu     tcliu@cs.duke.edu
%


%% CLEAR
clc;
clear;
close all;

%% (START)
fprintf('\n\n   ******** START SCRIPT [%s] ******** \n\n ', mfilename);

%% Parameters


filePath = '/Users/pavanchaudhari/Desktop/Homework/COMP520/Code/HW3/';

% options

fileNames = {'airplane_terrain', 'writing_wall'};
editModes = {'Over blending', 'Max blending'};
solveMethods = {'Jacobi', 'Gauss-Seidel', 'Gauss', 'SOR', 'Multi-grid', 'FFT'};

% the position 
coordsTopLft = {[60, 100], ...
                [20, 20]};

            
fileNum = input( sprintf('   enter the index to the file collection [1, %d] = ', length(fileNames) ) ); 


modeNum = 1;
methodNum = input( sprintf('   enter the index to the method [1, %d] = ', length(solveMethods) ) ); ;

% parameters for iterative methods

maxIter = 5000;
tauDiff = 1e-15;




%% LOADING DATA
fprintf('\n       -- Loading data [%s] ... \n', fileNames{fileNum});
tic;
fName = [filePath, fileNames{fileNum}];
load(fName);

fprintf('           -- Elapsed time: %.2f s \n', toc);

figure
imagesc(src)
axis image
title('Source image')

% figure
% imagesc(msk)
% axis image
% title('Mask (on source)')

figure
imagesc(tgt)
axis image
title('Target image')

fprintf( '\n\n   press any key to continue ... \n');
pause 

%% GENERATING MASK ON THE TARGET IMAGE
fprintf('\n       -- Generating mask on the target image ... \n');
tic;
% initializations
msktgt = false(size(tgt)); % 3-channel mask
mskCoords = coordsTopLft{fileNum}; % top-left corner of the mask
mskSrcSize = size(msk);
% copy-paste the src mask onto the target mask
msktgt(mskCoords(1): mskSrcSize(1)+mskCoords(1)-1, ...
       mskCoords(2): mskSrcSize(2)+mskCoords(2)-1, :) = msk;
fprintf('           -- Elapsed time: %.2f s \n', toc);

figure
imagesc(src)
axis image
title('Source image')

figure
imagesc(tgt)
axis image
title('Target image')

figure
imagesc(msk)
axis image
title('Mask (on source)')

figure
imagesc(msktgt)
axis image
title('Mask (on target)')

fprintf( '\n\n   press any key to continue ... \n');
pause


%% SUPERIMPOSING SOURCE IMAGE ON TARGET IMAGE
fprintf('\n       -- Superimposing source image on target image ... \n');
tic;
I = tgt;
I(msktgt) = src(msk);
fprintf('           -- Elapsed time: %.2f s \n', toc);

figure
imagesc(I)
axis image
title('Source image superposition on target image')

fprintf( '\n\n   press any key to continue ... \n');
pause


%% GUIDANCE GRADIENT FIELD
fprintf('\n       -- Generating guidance gradient field [%s] ... \n', ...
                                                    editModes{modeNum});
tic;

% gradients
[GxSrc, GySrc] = utilities.imgGrads(src);
[GxTgt, GyTgt] = utilities.imgGrads(tgt);

% mix the gradients
GxMixed = GxTgt;
GyMixed = GyTgt;

switch modeNum
    case 1 % over blending
        GxMixed(msktgt) = GxSrc(msk);
        GyMixed(msktgt) = GySrc(msk);
    otherwise
        fprintf('       + the specified gradient mixing mode is not implemented yet \n');    
end

fprintf('           -- Elapsed time: %.2f s \n', toc);


%% DIVERGENCE OF THE GRADIENT FIELD
fprintf('\n       -- Calculating divergence ... \n');
tic;
mixedDivG = zeros(size(GxMixed));
for c = 1: size(mixedDivG, 3)
    mixedDivG(:,:,c) = conv2(GxMixed(:,:,c), [1; -1], 'same') + ...
                       conv2(GyMixed(:,:,c), [1, -1], 'same');
end
fprintf('           -- Elapsed time: %.2f s \n', toc);


%% SOLVING POISSON EQUATION
fprintf('\n       -- Solving Poisson equation via [%s] ... \n', ...
                                                solveMethods{methodNum});

switch methodNum
    case 1
        r = mixedDivG;
        
        tic;

        [Iedited, residual, iterStep] = ...
            Jacobi.poissonSolverJacobi( I, msktgt, mixedDivG, ...
                                        maxIter, tauDiff );
        
        fprintf('           -- Elapsed time: %.2f s \n', toc);

        % % dedicated timing measuring
        % g = @() Jacobi.poissonSolverJacobi( I, msktgt, mixedDivG, ...
        %                                    maxIter, tauDiff );
        % t = timeit(g);
        % fprintf('           -- Solver execution time: %.2f s \n', t);
    case 2
        tic;

        [Iedited, residual, iterStep] = ...
            Jacobi.poissonSolverGS( I, msktgt, mixedDivG, ...
                                        maxIter, tauDiff );
        
        fprintf('           -- Elapsed time: %.2f s \n', toc);
    case 3
        tic;

        [Iedited, residual, iterStep] = ...
            Jacobi.poissonSolverGauss( I, msktgt, mixedDivG, ...
                                        maxIter, tauDiff );
        
        fprintf('           -- Elapsed time: %.2f s \n', toc);
    case 4
        tic;

        [Iedited, residual, iterStep] = ...
            Jacobi.poissonSolverSOR( I, msktgt, mixedDivG, ...
                                        maxIter, tauDiff );
        
        fprintf('           -- Elapsed time: %.2f s \n', toc);

    otherwise
        fprintf('       + the specified solver is not implemented yet \n');
end


%% VISUALIZATIONS
% figure
% imagesc(src)
% axis image
% title('Source image')
% 
% figure
% imagesc(tgt)
% axis image
% title('Target image')
% 
% figure
% imagesc(msk)
% axis image
% title('Mask (on source)')
% 
% figure
% imagesc(msktgt)
% axis image
% title('Mask (on target)')
 
figure
imagesc(I)
axis image
title('Source image superposition on target image')

figure
imagesc(Iedited)
axis image
title('Fused image');

%% (END)
fprintf('\n\n   ******** END SCRIPT [%s] ******** \n', mfilename);