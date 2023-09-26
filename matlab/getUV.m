function [U, V]=getUV(tform, dims, pix, f, int_idx_flag)
% This function computes the coordinate transforms U, V that can be used to
% undo the distortion caused by diffraction and the imperfections of the
% grating.
%
% tform: the projective transformation that corrects distortion in Q space.
% Defaults to the identity matrix (no distortion in Q space).
% pix: pitch (mm/pixel). Currently assuming pitch is symmetric in x & y
% f: focal length of camera in mm
% int_idx_flag: matlab's tformarray() does not require integer indices for 
% matrices. Set this to true if you need integer indices for U, V.
if nargin<1 || isempty(tform)
    tform = projective2d(eye(3));
end
if nargin<2 || isempty(dims)
    dims = [4608, 3456];
end
if nargin<3 || isempty(pix)
    pix = 1e-3;
end
if nargin<4 || isempty(f)
    f = 1.8;
end
if nargin<5 || isempty(int_idx_flag)
    int_idx_flag=false;
end

ctr = (dims+1)/2;
if int_idx_flag
    ctr = round(ctr);
end

% Rectangles in Q are mapped to barrels in R.
% So we project barrel max points in R down to Q.
% This step is not strictly necessary as we resample the image during
% transformation (see imtformarray()). However we do need to scale the
% image, which this step achieves.
bptR = [dims(1), ctr(2)];
bptQ = R2Q(bptR, dims, pix, f);

% To make resolution symmetric; assuming dimX > dimY
x=linspace(-bptQ(1), bptQ(1), dims(1));
[X, Y] = meshgrid(x, x);
[X2, Y2] = transformPointsForward(tform, X, Y);

% The usual diffraction transformation
Z = sqrt(1 - X2.^2 - Y2.^2);
U = f*X2./Z/pix + ctr(1);
V = f*Y2./Z/pix + ctr(2);

% Deal with imaginary numbers: point to pixels outside of the image
imagmask = U~=real(U) | V~=real(V);
U(imagmask) = 2*dims(1);
V(imagmask) = 2*dims(2);

if int_idx_flag
    U = round(U);
    V = round(V);
end

% Take the middle chunk of y
yidx = round((dims(1)-dims(2))/2)+1:round((dims(1)+dims(2))/2);
U = U(yidx, :);
V = V(yidx, :);
end
