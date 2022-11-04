%   
function [ Frecon, rmax] = play_imag_svd_sequence( Fsequence, idxFig ) 
%
%  Fsequence: cell array 
%        containing SVD terms for each of the color channels 
%  Frecon : reconstructed image with rmax frames 
% 
% see gen_imag_svd_sequence( Fsequence ) 
% 
 
%%
fprintf( '\n\n    -- enter %s ... \n\n', mfilename ); 

kk = length( Fsequence );            % the number of color channels 
m  = size( Fsequence{1}{2}, 1 );     % length of left  s-vector  
n  = size( Fsequence{1}{3}, 1 );     % length of right s-vector 

rankc = zeros(3,1);
for k = 1:kk
   rankc(k) = length( Fsequence{k}{1} );  
end
rmax    = max( rankc ) ; 

Sc      = zeros( rmax, kk) ;

for k = 1:kk     % zero padding 
   Sc( 1:rankc(k) , k) =  Fsequence{k}{1} ;  
end


Frecon = zeros( m, n , kk ); 

% figure( idxFig ) 
fprintf('   '); 

for t = 1:rmax  

  tframe  = zeros( m, n, kk); 
  
  for k = 1:kk % color channel 
      if Sc( t, k ) > eps 
          tframe( :, :, k) = Sc(t,k) * ...
              Fsequence{k}{2}(:,t) * Fsequence{k}{3}(:,t)';
      end
  end
  
  Frecon = Frecon + tframe ; 
  
%   if mod(t,5)==0 
%     imshow( Frecon )   
%     pause( 1/2 ) 
%     fprintf( '.'); 
%   end 
end 

% imshow( Frecon )   
% pause( 1/2 ) 
% msgStr = sprintf('reconstructed image with %d svd tuples', rmax );
% title( msgStr ) 

fprintf( '\n\n    -- exit %s \n\n', mfilename );  

end


%% ==========================
%  Numerical Analysis 
%  Duke CS 
%  Xiaobai Sun 

