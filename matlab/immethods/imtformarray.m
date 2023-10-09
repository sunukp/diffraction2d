function timg=imtformarray(img, U, V)
% Wrapper for matlab's tformarrray() function
tmap_B = cat(3, U, V);
resamp = makeresampler('cubic', 'fill');
timg = tformarray(img, [], resamp, [2 1], [1 2], [], tmap_B, 0);
end

