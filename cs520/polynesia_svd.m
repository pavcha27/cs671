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

% 512 by 340 image
imagefilename = '/Users/pavanchaudhari/Desktop/Homework/COMP520/Code/HW2/inpainting/dataset/polynesia.jpeg';

% set p and q to be the partition to use
P = 20;
Q = 20;

% ... select and load an image file 

Fimag = imread( imagefilename );

[m,n, nc ] = size( Fimag );

fprintf( '\n   image size = [%d, %d, %d ] \n', m, n, nc   ); 
%% 

% convert image to double
Fimage = im2double(Fimag);

% partition image
partitions = {};
partitions{P,Q} = [];
row_pix = ceil(size(Fimage, 2)/P);
col_pix = ceil(size(Fimage, 1)/Q);
for p = 1:P
    for q = 1:Q
        if p == P && q == Q
            partitions{p,q} = Fimage((q-1)*col_pix+1:end, (p-1)*row_pix+1:end, :);
        elseif p == P
            partitions{p,q} = Fimage((q-1)*col_pix+1:q*col_pix, (p-1)*row_pix+1:end, :);
        elseif q == Q
            partitions{p,q} = Fimage((q-1)*col_pix+1:end, (p-1)*row_pix+1:p*row_pix, :);
        else
            partitions{p,q} = Fimage((q-1)*col_pix+1:q*col_pix, (p-1)*row_pix+1:p*row_pix, :);
        end
    end
end

% save the truncatedsvd sequences
Fsequences = {};
Fsequences{P,Q} = {};

fprintf( '\n\n   press any key to generate a SVD sequence ... \n');
pause 

%%
idxFig = 1; 
fprintf( '\n   ... generating truncated SVD sequence of the image \n' ); 

tau       = 0.001;   % set an error tolerance 

ranks = zeros(P,Q);

% get the truncated svd sequences for sub-images and fill in numerical 
% ranks for the heatmap
for p = 1:P
    for q = 1:Q
        Fsequences{p,q} = gen_imag_svd_sequence( [partitions{p,q}], tau, idxFig );
        
        ranks(p,q) = size([Fsequences{p,q}{1}{1}],1);
    end
end

Fsequence = gen_imag_svd_sequence( Fimage, tau, idxFig );

% recover the sub-images each truncated svd sequences
Freconds = {};
rframes = {};
Freconds{P,Q} = {};
rframes{P,Q} = {};
for j = 201:200+P*Q
    [ Freconds{j-200}, rframes{j-200} ] = play_imag_svd_sequence( Fsequences{j-200}, j);
end

% reconstruct the image by stiching the sub-images
newImage = zeros(size(Fimage));
for p = 1:P
    for q = 1:Q
        for i = 1:row_pix
            for j = 1:col_pix
                for k = 1:3
                    row = (p-1)*row_pix + i;
                    col = (q-1)*col_pix + j;
                    if (row > size(Fimage,2) || col > size(Fimage, 1))
                        break
                    end
    
                    newImage(col,row,k) = [Freconds{p,q}(j,i,k)];
                end
            end
        end
    end
end

pathname = "/Users/pavanchaudhari/Desktop/Homework/COMP520/Completed HW/HW2/Pics/";
pic_name = "polynesia";

% display images and heatmap
figure(10);
imshow(Fimage)
title(sprintf("Original image, size [%d,%d]", size(Fimage,2),size(Fimage,1)))
saveas(gcf, fullfile(pathname,sprintf("%s%d_original", pic_name, tau*1000)),"png");
RemoveWhiteSpace([], 'file', fullfile(pathname,sprintf("%s%d_original.png", pic_name, tau*1000)));
drawnow

figure(11);
imshow(newImage)
title(sprintf("Reconstructed image, size [%d,%d]", size(Fimage,2),size(Fimage,1)))
saveas(gcf, fullfile(pathname,sprintf("%s%d_reconstructed", pic_name, tau*1000)),"png");
RemoveWhiteSpace([], 'file', fullfile(pathname, sprintf("%s%d_reconstructed.png", pic_name, tau*1000)));
drawnow

% local rank heat map
figure(12)
rank_map = heatmap(ranks);
rank_map.Title = sprintf("Numerical Ranks, by sub-image, with tau = %f", tau);
saveas(gcf, fullfile(pathname, sprintf("%s%d_local_ranks_heatmap", pic_name, tau*1000)),"png");
RemoveWhiteSpace([], 'file', fullfile(pathname, sprintf("%s%d_local_ranks_heatmap.png", pic_name, tau*1000)));

% local similarity score heatmap
local_sims = zeros(P,Q);
for p = 1:P
    for q = 1:Q
        local_sims(p,q) = show_residual_images(partitions{p,q}, Freconds{p,q}, 15, false);
    end
end

figure(13)
local_sim_map = heatmap(local_sims);
local_sim_map.Title = "SSIM similarity score, by sub-image (scaled to 50th power then scaled by 100 times)";
saveas(gcf, fullfile(pathname, sprintf("%s%d_local_sims_heatmap", pic_name, tau*1000)),"png");
RemoveWhiteSpace([], 'file', fullfile(pathname, sprintf("%s%d_local_sims_heatmap.png", pic_name, tau*1000)));

% global similarity
simscore = show_residual_images(Fimage, newImage, 15, true);
saveas(gcf, fullfile(pathname, sprintf("%s%d_global_sims_heatmap", pic_name, tau*1000)),"png");
RemoveWhiteSpace([], 'file', fullfile(pathname, sprintf("%s%d_global_sims_heatmap.png", pic_name, tau*1000)));

% 
% %% ...  For Numerical Analysis, Duke CS  
% %       Xiaobai Sun 
% %% =======================================