function timg=imtforminv(img, U, V)
% Inverse transform passed in img using coordinate transform matrices U & V
[dimY, dimX, numch]=size(img);

U = round(U);
V = round(V);

timg=zeros(size(img), class(img));
for k=1:numch
    for i=1:dimY
        for j=1:dimX
            if V(i,j)>=1 && V(i,j)<=dimY && U(i,j)>=1 && U(i,j)<=dimX
                timg(V(i, j), U(i, j), k) = img(i, j, k);
            end
        end
    end
end
end
