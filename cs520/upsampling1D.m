function Vimag = upsampling1D( LresImag, x1, xq, method ) 
% 
% Vimag = upsampling1D( LresImag, x1, xk, method ); 
% 
% Input
% LresImag: 2D array of real-valued numbers/pixels 
% x1      : spatial locations for the row(s) of LresImag 
% xq      : query locations for upsampling 
% method  : charater string for specifying upsampling method 
%           currently supported: 
%           'linear'   -- matlab built-in  
%           'constant' -- provided by the programmer 
% Output 
% Vimag   : 2D array of real-valued numbers/pixels 
%            size( Vimag ) = [ size(LresImag,1), length(xq) ]
% 

%% 
[ m, n ] = size( LresImag );
nk       = length( xq );
Vimag    = zeros( m, nk);

for i = 1:m
    yi = LresImag(i,:); 
    switch method 
        case 'constant'
            zi = interp0( x1, yi, xq );       
        case 'linear' 
            zi = interp1( x1, yi, xq, method ); 
        case 'nearest'
            zi = interp1( x1, yi, xq, method );
        case 'cubic'
            zi = interp1( x1, yi, xq, method );
        case 'spline'
            zi = interp1( x1, yi, xq, method );

        otherwise error('un-supported upsampling method'); 
    end
    Vimag(i,:) = zi; 
end


%% 

end

%% ===============================================
%% Programmer: 
%  Xiaobai Sun 
%  Duke CS 
%  For the class of Numerical (Data) Analysis 
%  Feb., 2022 
%  