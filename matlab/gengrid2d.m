function [X, Y]=gengrid2d(unit, mord, shiftfac, yxratio, theta)
% Creates a centered (mord x mord) grid in the direction cosine space with 
% pitch=unit, then shifts (translates), adjusts aspect ratio, and rotates, 
% when necessary.
% shiftfac: shift factor, translates the coordinates by shiftfac*unit
% yxration: y/x ratio
% theta: rotation angle in degrees
if nargin<3 || isempty(shiftfac)
    shiftfac=[0 0];
end
if nargin<4 || isempty(yxratio)
    yxratio=1;
end
if nargin<5 || isempty(theta)
    theta=0;
end

x = (-mord:mord)*unit;
[X, Y] = meshgrid(x, x);

% shift grid to be projected to screen by a factor of the unit
if abs(shiftfac(1))>0 || abs(shiftfac(2))>0
   X = X + shiftfac(1)*unit;
   Y = Y + shiftfac(2)*unit;
end

% adjust Y X ratio
if abs(yxratio) > 0
    Y = Y*yxratio;
end

% rotate
if abs(theta) > 0
   R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
   XY = [X(:) Y(:)]*R';
   X = reshape(XY(:,1), size(X));
   Y = reshape(XY(:,2), size(Y));
end
end
