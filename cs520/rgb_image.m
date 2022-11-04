%% 
clear; close all

A = imread("peppers.png");

figure(1); 
image(A); 
axis equal off

for k=1:3
  cm = zeros(256,3,"uint8");
  cm(:,k) = 0:255;

  figure(k+1); 
  image(A(:,:,k)); 
  axis equal off
  colormap(cm)
end
