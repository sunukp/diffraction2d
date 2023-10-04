function [dptspX, dptspY, dist2, boundaries]=finddiffrpts(img, mord, unit, ...
    shiftfac, yxratio, theta, thres, boxw, dims, pix, f)
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

% We need ctr to be int, unlike in other functions in this lib, as we will
% use it in img coordinates
ctr=round(dims/2); 

[X, Y]=gendiffr2d(unit, mord, shiftfac, yxratio, theta, dims, pix, f);
dptspX=NaN(2*mord+1);
dptspY=NaN(2*mord+1);
dist2=NaN(2*mord+1);
boundaries=[];

for k=1:2*mord+1 % x
    for j=1:2*mord+1 % y
        xl=round(X(j,k)-boxw)+ctr(1); % xlower bound
        xu=round(X(j,k)+boxw)+ctr(1); % xupper bound
        yl=round(Y(j,k)-boxw)+ctr(2); % ylower bound
        yu=round(Y(j,k)+boxw)+ctr(2); % yupper bound
        boundaries=[boundaries; xl, xu, yl, yu];
        if yu<yl || xu<xl
            continue;
        end
        
        if xl<1 % XXX need this bound for upper etc too
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
