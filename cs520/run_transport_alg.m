% SCRIPT: run_transport_alg.m 

clc 
clear
close all

fprintf( '\n\n   *** BEGIN %s ... \n\n', mfilename ); 

%% ... add paths 

addpath ./lib
addpath ./dataset
addpath ./results 


%% ... Transport Inpainting

% ... create the corrupted image with the mask

cleanfilename = 'transport_clean.png';
maskfilename  = 'transport_mask.png';

[u,mask]      = create_image_and_mask(cleanfilename,maskfilename);
imwrite(u,'./dataset/transport_input.png')

inputfilename  = 'transport_input.png';
outputfilename = 'transport_output.png'; 

Icorrupt = imread( inputfilename );
Icorrupt = im2double( Icorrupt );


fprintf( '\n   ... displaying images \n', mfilename ); 

figure(1) 
imshow( cleanfilename ); 

figure(2) 
imshow( inputfilename );

figure(3) 
imshow( outputfilename ); 

fprintf( '\n\n   *** END %s \n\n', mfilename ); 

return 

%% ===================  run the algorithm =====================

% parameters
tol           = 1e-5;
maxiter       = 50;
dt            = 0.1;
param.M       = 40; % number of steps of the inpainting procedure;
param.N       = 2;  % number of steps of the anisotropic diffusion;
param.eps     = 1e-10;

% inpainting
tic
inpainting_transport(u,mask,maxiter,tol,dt,param);
toc

return 

%% ...  For Numerical Analysis, Duke CS  
%       image displays are added by Xiaobai Sun 
% 
%%  Orginal source: 
% 
% MATLAB Codes for the Image Inpainting Problem
%
% Authors:
% Simone Parisotto          (email: sp751 at cam dot ac dot uk)
% Carola-Bibiane Schoenlieb (email: cbs31 at cam dot ac dot uk)
%      
% Address:
% Cambridge Image Analysis
% Centre for Mathematical Sciences
% Wilberforce Road
% CB3 0WA, Cambridge, United Kingdom
%  
% Date:
% September, 2016
%
% Licence: BSD-3-Clause (https://opensource.org/licenses/BSD-3-Clause)
%
