function ptsQ=R2Q(ptsR, dims, pix, f)
% R -> Q mapping (screen space to directional cosine space)
% ptsR: points in pixel coordinates (not centered)
% For default values for dims, pix, f, please refer to:
% https://www.camerafv5.com/devices/manufacturers/samsung/sm-g9708_beyond0q_2/
if nargin<2 || isempty(dims)
    dims=[4608, 3456];
end
if nargin<3 || isempty(pix)
    pix=1e-3;
end
if nargin<4 || isempty(f)
    f=1.8; % android wide angle focal length in mm
end

% ctr=round(dims/2);
ctr = (dims+1)/2;
ptsR = ptsR-ctr;
ptsRmm = ptsR*pix;

dist2 = sqrt(ptsRmm(:,1).^2 + ptsRmm(:,2).^2 + f^2); % 3d distance
ptsQ = ptsRmm./dist2;

end
