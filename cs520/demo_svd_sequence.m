% SCRIPT: demo_svd_sequence.m 
% purpose:
% to show the use of SVD for image compression, transmission and
% reconstruction
% 

%% =================================================================
clc 
clear
close all

fprintf( '\n\n   *** BEGIN %s ... \n\n', mfilename ); 

%% ... add paths data files 


datapath = '/Users/pavanchaudhari/Desktop/Homework/COMP520/Code/HW2/inpainting/dataset/';

% ... image file gallary

fprintf( '\n   list the image files in a collection \n' ); 
imageFileNames = { ...
                   'transport_clean.png', ...
                   'transport_input.png', ...
                   'polynesia.jpeg', ...
                   'brands.jpeg', ...
                   'sprite.jpeg', ...
                     }; 
                   

% ... select and load an image file 
 
fprintf("    %s\n", imageFileNames{:} );

i = input( '\n   select an image file by index = ') ; 

imagfilename = [ datapath imageFileNames{i} ];  
Fimag        = imread( imagfilename );

[m,n, nc ] = size( Fimag );

fprintf( '\n   image size = [%d, %d, %d ] \n', m, n, nc   ); 
%% 
fprintf( '\n\n   press any key to generate a SVD sequence ... \n');
pause 

%%
idxFig = 1; 
fprintf( '\n   ... generating truncated SVD sequence of the image \n' ); 

tau       = 0.003;   % set an error tolerance 
Fsequence = gen_imag_svd_sequence( im2double( Fimag), tau, idxFig );

size(Fsequence{1}{2})

fprintf( '\n   ... displaying singular values in Figure%d \n', idxFig ); 

%% 
fprintf( '\n\n   press any key to display SVD-truncated image sequence ... \n'); 
pause 

fprintf( '\n   ... displaying image seqence by truncated SVDs in Figure%d \n', idxFig ); 

idxFig = idxFig+1 ; 
[ Frecond, rframes]  = play_imag_svd_sequence( Fsequence, idxFig );

fprintf( '\n\n   press any key to see the original image ... \n');
pause 

%% 
idxFig = gcf;
idxFig = idxFig.Number + 1; 
fprintf( '\n   ... showing the original image in Figure%d \n', idxFig  ); 
% 
figure( idxFig ) 
imshow( Fimag ); 
msgTitle = sprintf('the original image of size [%d,%d]', m,n); 
title( msgTitle );

%%
fprintf( '\n\n   press any key to see the residual images ... \n');
pause 

idxFig = idxFig + 1; 
sim = show_residual_images( Fimag, Frecond, idxFig);

%% 
fprintf( '\n\n   *** END %s \n\n', mfilename ); 

return 


%% ...  For Numerical Analysis, Duke CS  
%       Xiaobai Sun 
%% =======================================