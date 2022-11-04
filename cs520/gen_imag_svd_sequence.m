%   
function Fsequence = gen_imag_svd_sequence( Fimag, tau, idxFig ) 
%
%  Fimag : input image in double 
%  tau   : err ratio, for example tau  = 0.02;  
%  
%  Fsequence: cell array 
%        containing SVD terms for each of the color channels 
% 
% see also play_imag_svd_sequence( Fsequence ) 
% 

fprintf( '\n\n    -- enter %s ... \n', mfilename );  
    
    
[m, n, kk] = size( Fimag );

Fsequence  = cell(1,kk);

% figure(idxFig) 

%%
for k = 1:kk 
  
  Fk         = Fimag(:,:,k);
  Fk_energy  = norm( Fk, 'fro' )^2; 

  [Uk, Sk, Vk] = svd( Fk, 'econ');         
  Sk           = diag( Sk );
%   subplot(1,kk,k) 
  switch k 
      case 1 
%           loglog(Sk, 'r.') ; 
      case 2 
%           loglog(Sk, 'g.') ; 
      case 3 
%           loglog(Sk, 'b.') ;
      otherwise 
  end
%   drawnow 
  
  
  Sk_head  = truncate_tail( Sk, tau );
  rk       = length( Sk_head );
  
  Fsequence{k} = { Sk_head, Uk(:,1:rk), Vk(:,1:rk) }; 
  
end

% subplot(1,kk,1) 
% title('Singular values at three color channels');
% subplot(1,kk,k)
% xlabel('in logx-logy scale'); 
% fprintf( '\n\n    -- exit %s \n\n', mfilename );  

end 


%% ========================================
function sHead  = truncate_tail( s, tau ) 

  s2        = s.^2;
  [s2, p]   = sort( s2, 'descend' );
  s2sum     = sum( s2 );
  
  Terr = 0; 
  i = length(s); 
  while Terr < tau*s2sum && i > 1 
    Terr = Terr + s2(i); 
    i    = i - 1;
  end

  sHead  = s(p);
  sHead  = sHead(1:i);
  
end 
