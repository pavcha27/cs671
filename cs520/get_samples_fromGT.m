function [ Simag, xk] = get_samples_fromGT( kup )   
% 
%  [ Simag, xk ]  = get_samples_fromGT(kup); 
% 
%  Input
%  -----
%  kup : positive integer, when kup=1, default; otherwise, kup is the 
%        upsampling factor 
%        
%        Default:
%            ground-truth data 
%            f(x,y) = sin( 0.5 * r^2 );      r^2 = x^2 + y^2; 
%            sampling spacing: h = 0.132119066l, 
%            grid size and location: 64x64, in the first quad 
% 
%            Here, 2h is the distance between the 22nd and 23rd zeros of f(r) 
% 
%            When kup > 1, 
%            spacing: hdk = h/k ; 
%            grid size: (kup*64) x (kup*64), in the first quad 
% 
%  Output
%  -------
%  Simag: 2D image of (kup*64)x(kup*64) pixels from the grond truth function
%  

%  Note: 
%  f(x,y)  is not band-limited, can not be reconstructed exactly 
% 
%  F( wx, wy) = cos( 0.5 * rho^2 );  rho^2 = wx^2 + wy^2 
%  
 
% interpolation for display to 
% horizontal samples : 100/in 
% vertical samples   : 96/in 
% 3.5 in^2 : 350 x 336  
% at least two samples between each zero crossing within the sample
% region 
% 

% ... default setting for the low-resolution image   

h = 0.132119066 ;  
n = 64 ;

% ... with upsampling factor kup 

hk  = h/kup; 
nk  = n*kup; 

msgStr = sprintf( 'Generated image: %dx%d pixels spaced by h = %g', ... 
                  nk, nk, hk); 

xk = (0:kup*64-1) + 1/2;           % the midpoint per pixel  
[ X, Y ] = meshgrid ( xk );

Simag = sin( hk^2 * ( X.^2 + Y.^2 ) );

xk = xk*hk; 

%% 
fprintf( '\n    ... display the generated image '); 

figure 
imagesc( Simag ) 
axis equal 
axis off 
title( msgStr ) 
colormap( gray ) 

return 

%% ========= programmers 
%% Initially, a script by Tiancheng Liu in 2020 
%% Restructured and revised into a driver script and functions 
%% by Xiaobai Sun in Feb. 2022   
%% 

%% References: the test image is transcribed from the article 
% 
%   IEEE Transactions on Acoustics, Speech and Signal Processing IEEE (ASSP)
%   vol. 29, No. 6, Dec. 1981 
%   Title: Cubic Convolution Interpolation for Digital Image Processing
%   Author: Robert G. Keys 
% 