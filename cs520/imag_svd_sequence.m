% FUNCTION 
%   
function Fsequence = imag_svd_sequence( Fimag ) 
%
%  Fimag : input image in double 
% 

%% 
[m, n, kk] = size( Fimag );

Fsequence = cell(1,kk);
tau       = 0.02; 

for k = 1:kk 
  
  Fk         = Fimag(:,:,k);
  Fk_energy  = norm( Fk, 'fro' )^2; 

  [Uk, Sk, Vk] = svd( Fk, 'econ');         
  Sk           = diag( Sk );

  Sk_head  = truncate_tail( Sk, tau );
  rk       = length( Sk_head );
  
  Fsequence{k} = { Uk(:,1:rk), Vk(:,1:rk), Sk_head }; 
  
end

end 


%% ========================================
function sHead  = truncate_tail( s, tau ) 

  s2        = s.^2;
  [s2, p]   = sort( s2, 'descend' );
  s2sum     = sum( s2 );
  
  Terr = 0; 
  i = length(s); 
  while Terr < tau*s2sum & i > 1 
    Terr = Terr + s2(i); 
    i    = i - 1; 
  end

  sHead  = s(p);
  sHead  = sHead(1:i);
  
end 
