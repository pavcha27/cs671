function sim = show_residual_images( Fimag, Frecond, idxFig, disp)
%  sim = show_residual_images( Fimag, Frecond, idxFig); 
% 
%  Input:
%  Fimag:   referene or original image 
%  Frecond: reconstructed image 
%  idxFig: integer  
%
%  Output: 
%  Visual display of residual images 
%  sim: similarity score between the two input images in real-valued field 


%% ... compute the similarity score 

FimagD2 = im2double( Fimag ); 

sim = sum(FimagD2(:).*Frecond(:))/(norm(FimagD2(:),2)*norm(Frecond(:),2)); 

%% ... compute residual images 

E = zeros( size( Fimag ) );

if (disp)
    figure( idxFig ) ;
end

for k = 1:size( Fimag, 3) 
    
    %% ... calculate residual errors 
    
    E(:,:,k) = FimagD2(:,:,k) - Frecond(:,:,k)   ; 
    maxPk = max( max( FimagD2(:,:,k) ) ); 
    maxEk = norm( E(:,:,k), 'inf' );  

    %% ... display residual error per color channel 
    
    cm = zeros( 256, 3, "uint8" );
    cm(:,k) = (0:255);
    if (disp)
        h = subplot(2,2,k); 
        imagesc( E(:,:,k)*1000 ) ; 
        colormap(h, cm )
    end

end

if (disp)
    subplot(2,2,1)
    msgStr = sprintf( 'residual images at color channels'); 
    title( msgStr )
end

if (disp)
    subplot(2,2,k+1) 
    imagesc(E*1000)
    xlabel('entire image amplified 1,000x');
end

return 


%% ...  For Numerical Analysis, Duke CS  
%       Xiaobai Sun 
%% =======================================