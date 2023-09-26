function timg=imtform(img, U, V)
% Transform passed in img using coordinate transform matrices U & V
[dimY, dimX, numch]=size(img);

timg=zeros(size(img), class(img));
for k=1:numch
    for i=1:dimY
        for j=1:dimX
            if V(i,j)>=1 && V(i,j)<=dimY && U(i,j)>=1 && U(i,j)<=dimX
                timg(i, j, k) = img(V(i,j), U(i,j), k);
            end
        end
    end
end
end
