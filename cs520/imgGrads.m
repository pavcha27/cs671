function [ Gx, Gy ] = imgGrads( I )
    Gx = zeros( size(I) );
    Gy = zeros( size(I) );
    for c = 1: size(I, 3)
        Itemp = padarray(I(:,:,c), [1, 0], 'replicate', 'pre');
        Gx(:,:,c) = conv2( Itemp, [1; -1], 'valid' );
        Itemp = padarray(I(:,:,c), [0, 1], 'replicate', 'pre');
        Gy(:,:,c) = conv2( Itemp, [1, -1], 'valid' );
    end
end
