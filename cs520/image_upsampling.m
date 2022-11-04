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
[ LresImag, x1 ]  = get_samples_fromGT( 1 );
[m1, n1] = size( LresImag );

fprintf( '\n\n   ... get a higher-resolution resolution image \n' );
kup       = 12; 
[ HresImag, xk ]  = get_samples_fromGT( kup );
[mk, nk]  = size( HresImag ); 

%% Dimension separated interpolation 
%% upsampling

fprintf( '\n    ... press any key to generate 1D-upsampled images ');
pause 

% save images
images = {};
images{7} = [];

% image types
image_type = ["original", "1-D constant", "1-D linear", "1-D cubic", ...
                "1-D spline", "2-D linear", "2-D cubic"];

% original image
images{1} = HresImag;

% constant upsampling
VimagX = upsampling1D(LresImag, x1, xk, 'constant');
VimagXY = upsampling1D(VimagX', x1, xk, 'constant');
TF = isnan(VimagXY);
for i = 1:kup*m1
    for j = 1:kup*n1
        if TF(i,j) == 1
            VimagXY(i,j) = 1;
        end
    end
end


images{2} = VimagXY';

% linear upsampling
VimagX = upsampling1D(LresImag, x1, xk, 'linear');
VimagXY = upsampling1D(VimagX', x1, xk, 'linear');
TF = isnan(VimagXY);
for i = 1:kup*m1
    for j = 1:kup*n1
        if TF(i,j) == 1
            VimagXY(i,j) = 1;
        end
    end
end
images{3} = VimagXY';

% cubic upsampling
VimagX = upsampling1D(LresImag, x1, xk, 'cubic');
VimagXY = upsampling1D(VimagX', x1, xk, 'cubic');
TF = isnan(VimagXY);
for i = 1:kup*m1
    for j = 1:kup*n1
        if TF(i,j) == 1
            VimagXY(i,j) = 1;
        end
    end
end
images{4} = VimagXY';

%
VimagX = upsampling1D(LresImag, x1, xk, 'spline');
VimagXY = upsampling1D(VimagX', x1, xk, 'spline');
for i = 1:kup*m1
    for j = 1:kup*n1
        if isnan(VimagXY(i,j))
            VimagXY(i,j) = 0;
        end
    end
end
images{5} = VimagXY';

%% 2d upsampling

% scale up LresImage to get known datapoints
% interpolate in between using griddata

% datapoints
% so we go through each datapoint and scale it up as a midpoint, since the
% high res image has kup*m*n points
    % 1:m1, 1:n1 takes the m datapoints
    % *kup scales them to the same size as high res image
    % -kup/2 makes it the midpoint of each interval
    % +1 just for matlab reasons, since it's 1 indexed
    % thus we scale low res to same size as high res
x = ((1:m1)*kup) - (kup/2) + 1;
y = ((1:n1)*kup) - (kup/2) + 1;

% query points in the middle
[xq, yq] = meshgrid(1:mk, 1:nk);


% cubic upsampling
VimagXY = griddata(x , y, LresImag, xq, yq, 'linear');
TF = isnan(VimagXY);
for i = 1:kup*m1
    for j = 1:kup*n1
        if TF(i,j) == 1
            VimagXY(i,j) = 1;
        end
    end
end
images{6} = VimagXY';

% spline upsampling
VimagXY = griddata(x , y, LresImag, xq, yq, 'cubic');
TF = isnan(VimagXY);
for i = 1:kup*m1
    for j = 1:kup*n1
        if TF(i,j) == 1
            VimagXY(i,j) = 1;
        end
    end
end
images{7} = VimagXY';

for j = 1:7    
    figure
    imagesc( images{j} ) 
    axis equal             % drop the defaul ratio 
    axis off 
    colormap( gray ) 
    [my, nx] = size( images{j} ); 
    msgStr   = sprintf('XY %s image of size [%d, %d]', image_type(j), my, nx );
    title( msgStr ) 
    saveas(gcf, sprintf("/Users/pavanchaudhari/Desktop/Homework/COMP520/Completed HW/HW2/Pics/%s",image_type(j)),"png");
end

sim_scores = zeros(7,7);
for p = 1:7
    for q = 1:7
        sim_scores(p,q) = ssim(images{p}, images{q});
    end
end

figure
h = heatmap(sim_scores);
h.YDisplayLabels = image_type;
h.XDisplayLabels = image_type;
saveas(gcf, "/Users/pavanchaudhari/Desktop/Homework/COMP520/Completed HW/HW2/Pics/sim_scores", "png");

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