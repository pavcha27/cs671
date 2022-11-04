% SCRIP: demo_image_upsampling.m  
% 
%  Learning objectives: get familiar with the following 
%  (1) Interpolation for obtaining a high-resolution image; 
%      interpolation methods differ in several aspects: 
%         - dimension separated or integrated, 
%         - lower or higher order of piecewise interpolation 
%         - smooth conditions and boundary conditions 
%  (2) Test method: 
%      use of synthetic image with the ground truth, not band-limited, 
%      for sampling the pixels at various resolution levels.   
%  (3) Evaluation methods: 
%      similarity and difference between images (local and global)   
%  

%% ===================== script body =====================================
clc ; clear ; close all

fprintf( '\n\n   *** BEGIN %s ... \n\n', mfilename );  

 

%% ... get two images: one is of low resolution, one is higher resolution  

fprintf( '\n\n   ... get a low resolution image \n' ); 
kup   = 1; 
[ LresImag, x1 ]  = get_samples_fromGT( kup );
[m1, n1] = size( LresImag );

fprintf( '\n\n   ... get a higher-resolution resolution image \n' );
kup       = 12; 
[ HresImag, xk ]  = get_samples_fromGT( kup );
[mk, nk]  = size( HresImag ); 

%%  ... 
fprintf( '\n\n   ... display the difference in intensity in one row of pixels\n' );

msgInput = sprintf( '\n     select a row between [0,%d] =  ', n1-1 ); 
rowi  = input( msgInput ); 


rowik = rowi*kup; 

figure 
yi  = LresImag(rowi,:); 
yik = kron( yi, ones(1,kup) );    % constant over kup high-res pixels
plot( xk, yik,  'r.' );
hold on;
% 
plot( xk, HresImag(rowik,:), 'b-' );
legend('low resolution', 'higher resolution', 'Location', 'best' ); 
msgTitle = sprintf( 'the difference in intensity in row-%d', rowi ); 
title( msgTitle ) 
ylabel('intensity') 
xlabel('pixels at higher resolution'); 

%% Dimension separated interpolation 

kup   = 12 ; 

fprintf( '\n    ... press any key to generate 1D-upsampled images ');
pause 

% VimagX  = upsampling1D( LresImag, x1, xk, 'constant' );
% VimagXY = upsampling1D( VimagX',  x1, xk, 'constant' ); 

VimagX  = upsampling1D( LresImag, x1, xk, 'cubic' );
VimagXY = upsampling1D( VimagX',  x1, xk, 'cubic' ); 


VimagXY = VimagXY'; 

figure
imagesc( VimagX ) 
% axis equal 
axis off 
colormap( gray ) 
[my, nx] = size( VimagX ); 
msgStr   = sprintf('the X-1D-upsampled %dx%d image', my, nx );
title( msgStr ) 

figure
imagesc( VimagXY ) 
axis equal             % drop the defaul ratio 
axis off 
colormap( gray ) 
[my, nx] = size( VimagXY ); 
msgStr   = sprintf('the XY-1D-upsampled %dx%d image', my, nx );
title( msgStr ) 

%% ... looking into details 

VXrowi = VimagX( rowi, :); 
figure 
plot( xk, yik, 'r.' );
hold on;
plot( xk, HresImag(rowik,:), 'b-' ); 
hold on; 
plot( xk, VXrowi, 'g.' );
% 
legend('low resolution', 'higher resolution', 'VimagX', 'Location', 'best' ); 
title( msgTitle ) 
ylabel('intensity') 
xlabel('pixels at higher resolution'); 


VXYrowi = VimagXY( rowik, :); 
figure 
plot( xk, yik, 'r.' );
hold on;
plot( xk, HresImag(rowik,:), 'b-' ); 
hold on; 
plot( xk, VXYrowi, 'g.' );
% 
legend('low resolution', 'higher resolution', 'VimagXY', 'Location', 'best' ); 
title( msgTitle ) 
ylabel('intensity') 
xlabel('pixels at higher resolution'); 


%% Upsampling via interpolation 
fprintf( '\n\n   *** END %s \n\n', mfilename ); 

return 

%% ===========================================================
%% Programmer: Xiaobai Sun 
%% Initial (very) raw script: Tiancheng Liu, 2021 
%% Last revision: Feb., 2022 
%% 

%%  Reference: the test image transcribed from the article 
% 
%   IEEE TRANSACTIONS ON ACOUSTICS,PEECH, AND SIGNAL
%   PROCESSING,VOL. ASSP-29,NO. 6, DECEMBER 1981 
%   Title:
%   Cubic Convolution Interpolation for Digital Image Processing
%   Author:
%   ROBERT G. KEYS
% 