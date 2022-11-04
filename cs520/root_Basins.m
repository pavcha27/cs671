function   Xk  = root_Basins( alpha, nth, X0, kiter )
% 
%    Xk  = root_Basins( alpha, nth, X0, kiter ) ; 
% 
%  Returns Xk as approximate solution to the nth roots 
%
%          f(X) = X^{nth} - alpha = 0 
% 
%  using a verison of Newton-Ralph iteration ; 
% 
%  Renders also the convergene and divergence maps and the basins of 
%  attractions if X0 has multiple grid points, see demo_rooExtraction 
% 
%  Input 
%  -----
%   alpha : any complex number, assumed modest (via scaling)  
%   nth   : integrer, nth > 1 
%   X0    : multiple initial values, abs( X0 ) <= alpha 
%   kiter : interger, kiter > 0 
%
%  Output 
%  -------
%   Xk    : the iterates at the step KITER , with corresponding initial
%           values 
% 
%  Note : the color scheme for the third map may break down ; 
%         the visualization problem CAN be fixed 
% 

%% ---------------------------------------------------------------

fun_name = 'root_Basins' ;
fprintf( '\n\n %s BEGAN', fun_name );

fprintf( '\n\n   iterative extraction of the %d-th root \n', nth ) ; 
                 
%% ---- part 1. ITERATION : simultaneous & synchronized pointwise operations 

Xk   = X0 ; 

for k = 1 : kiter 
    
   Qk  = Xk.^(nth-1); 
   Fk  = Xk.*Qk - alpha ;                  % calculating the residuals 
   Xk  = Xk - Fk./( nth*Qk ) ;             % iterate update 

end

%% ... part 2. RENDERING : visual maps for convergence and divergence regions 

% ... detect digerved ones and create the divergence map  

Xnans       = ~isfinite( Xk.^nth ) ;  

Xk ( Xnans ) = 0; 

Xdiverged  = abs(Xk.^nth-alpha)/abs(alpha) > 1 ;  % non-convergent   

Xk ( Xdiverged ) = 0 ;


%% ... Show the convergence and divergence maps 

fprintf( '\n\n   show the convergence map \n\n' ); 
figure 
spy( abs(Xk) ) 
axis equal off  
title( 'Convergence Map' ) ;

fprintf("number of elements in convergence map: %d",nnz(Xk))

kdiverged = sum( Xdiverged(:) + Xnans(:) ) ;

msg = sprintf( '%d diverged' ); 

if kdiverged > 0 
    fprintf( '\n\n   show the divergence map \n\n' ); 
    figure 
    spy( Xdiverged + Xnans ) 
    axis equal off 
    title( ['Divergence Map  ', msg ] );

    fprintf("number of elements in divergence map: %d",kdiverged)
end


%% ... color coding the convergent complext values  
%   (trick: to break the symmetry between and within real and imag parts ) 
%    note: the coloring scheme may fail when the convergence regions shrink 

Yk    = Xk + nth*alpha ;
Yk    = real(Yk) + nth*imag(Yk)  ;           
Yk( Xdiverged | Xnans ) = 0 ; 

fprintf( '\n\n   show the basins of attractions ' ); 

figure
imagesc( Yk ) 
axis equal off 
title( ' The Basins of Attractions ' ); 



fprintf( '\n\n %s FINISHED \n\n', fun_name)  ;

return 

%% -------------------------------------------------
%   Programmer : 
%    Xiaobai Sun 
%    Duke CS 
%   Last revision : 
%    March 2015 
%   Observations with different values of alpha : 
%      real valued vs. complex valued 
%      inside or outside of the unit circle 
%      close to the center or far 
%   observations with different values of nth :
%      low-order vs. higher order 
% ---------------------------------------------------