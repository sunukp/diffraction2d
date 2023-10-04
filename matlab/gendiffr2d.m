function [Xp, Yp]=gendiffr2d(unit, mord, shiftfac, yxratio, theta, dims, pix, f)
% Generates theoretical diffraction pattern in centered pixel units
% unit: tick unit in idealized grid (lambda/d, where d is grating distance)
% mord: max order of diffraction
% shiftfac: shift factors in x & y. The shift fac is due to incident 
% angle.
% yxratio: y/x ratio
% theta: rotation angle of grating in degrees
% dims: pixel dimension of image
% pix: sensor pitch in mm
% f: focal length in mm
if nargin<3 || isempty(shiftfac)
    shiftfac=[0, 0];
end
if nargin<4 || isempty(yxratio)
    yxratio=1;
end
if nargin<5 || isempty(theta)
    theta=0;
end
if nargin<6 || isempty(dims)
    dims=[4608 3456];
end
if nargin<7 || isempty(pix)
    pix=1e-3; % android sensor dims in mm
end
if nargin<8 || isempty(f)
    f=1.8; % android focal length in mm
end

[X, Y]=gengrid2d(unit, mord, shiftfac, yxratio, theta);

% project up to screen (compute pixel coordinates of the projection)
Z=sqrt(1-X.^2-Y.^2);
mask= Z==real(Z);
Xp=NaN(size(X));
Yp=NaN(size(Y));

Xp(mask)=f*X(mask)./Z(mask)/pix;
Yp(mask)=f*Y(mask)./Z(mask)/pix;

end
