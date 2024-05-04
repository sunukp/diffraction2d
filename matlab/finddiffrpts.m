function [dptspX, dptspY, dist2, boundaries]=finddffrpts(img, mord, unit, ...
    shiftfac, yxratio, theta, thres, boxw, dims, pix, f, is_dffr, ctr)
% Uses matlab's regionprops() (via wrapper findlargestcentroid()) to find
% diffraction patterns within the passed in img.
% img: the image that contains diffraction pts. The image needs to be in
% grayscale (2D matrix). If you need to find for individual color channels,
% extract the color channel image and pass in.
% mord: max diffraction order to seek.
% unit: ticks in the directional cosine space (lambda/d), where lambda is
% wavelength and d is the grating distance (generally in nanometers)
% shiftfac: [guessed] (x,y) shift factor of the diffration pattern
% yxratio: [guessed] y/x ratio of the diffraction grid
% theta: [guessed] rotation of the diffraction grid in degrees
% thres: intensity threshold. Only pixels having intensity > thres are
% considered diffraction pts.
% boxw: half width of the binding box.
% Returns:
% (dptspX, dptspY): diffraction points(x,y) in pixels coordinates. The 
% matrix contains NaN in case no pts exceeding prescribed thres is found in
% the bounding box.
% dist2: matrix of squared errors between the grid's image in real space
% and the found maxima.

if nargin<4 || isempty(shiftfac)
    shiftfac=[0, 0];
end
if nargin<5 || isempty(yxratio)
    yxratio=1;
end
if nargin<6 || isempty(theta)
    theta=0;
end
if nargin<7 || isempty(thres)
    thres=140;
end
if nargin<8 || isempty(boxw)
    boxw=80;
end
if nargin<9 || isempty(dims)
    dims=[4608 3456];
end
if nargin<10 || isempty(pix)
    pix=1e-3;
end
if nargin<11 || isempty(f)
    f=1.8;
end
if nargin<12 || isempty(is_dffr)
    is_dffr = true;
end
if nargin<13 || isempty(ctr)
    ctr = (dims+1)/2;
end


if is_dffr
    [X, Y] = gendiffr2d(unit, mord, shiftfac, yxratio, theta, dims, pix, f);
else
    [X, Y] = gengrid2d(unit, mord, shiftfac, yxratio, theta);
end

if isscalar(mord)
    nx = 2*mord+1;
    ny = 2*mord+1;
else
    nx = mord(2)-mord(1)+1;
    ny = mord(4)-mord(3)+1;
end

dptspX=NaN(ny, nx);
dptspY=NaN(ny, nx);
dist2=NaN(ny, nx);
boundaries=[];


for k=1:nx % x
    for j=1:ny % y
        xl=round(X(j,k)-boxw+ctr(1)); % xlower bound
        xu=round(X(j,k)+boxw+ctr(1)); % xupper bound
        yl=round(Y(j,k)-boxw+ctr(2)); % ylower bound
        yu=round(Y(j,k)+boxw+ctr(2)); % yupper bound
        boundaries=[boundaries; xl, xu, yl, yu];
        if yu<yl || xu<xl || isnan(xl) || isnan(xu) || isnan(yl) || isnan(yu)
            continue;
        end
        
        if xl<1
            xl=1;
        end
        if yl<1
            yl=1;
        end
        if xu>dims(1)
            xu=dims(1);
        end
        if yu>dims(2)
            yu=dims(2);
        end
        
        slic = img(yl:yu, xl:xu);
        dpts = findlargestcentroid(slic(:,:), thres); % diffraction pts in relative pixel coordinates

        
        if ~isnan(dpts)
            dptspX(j,k) = dpts(1) + xl - 1; % absolute pixel coordinates
            dptspY(j,k) = dpts(2) + yl - 1; % absolute pixel coordinates
            dist2(j,k) = sqrt( (X(j,k)+ctr(1)-dptspX(j,k))^2 + (Y(j,k)+ctr(2)-dptspY(j,k))^2 );
        end
    end
end


end
