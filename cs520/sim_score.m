function simval = sim_score( img1, img2 )

    simval = sum(img1(:).*img2(:))/(norm(img1(:),2)*norm(img2(:),2)); 

end