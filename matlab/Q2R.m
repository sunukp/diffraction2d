function ptsR=Q2R(ptsQ, dims, pix, f)
% Directional cosine space to screen (Q -> R) mapping
% ptsQ: nx2 points in directional cosine (Q) space
% Returns *non-centered* pixel positions.
if nargin<2 || isempty(dims)
    dims=[4608, 3456];
end
if nargin<3 || isempty(pix)
    pix=1e-3;
end
if nargin<4 || isempty(f)
    f=1.8; % android focal length in mm
end

ctr = (dims+1)/2;

ptsR_x = NaN(length(ptsQ), 1);
ptsR_y = NaN(length(ptsQ), 1);
z = NaN(length(ptsQ), 1);
mask = ptsQ(:,1).^2 + ptsQ(:,2).^2 <= 1;
z(mask) = sqrt(1 - ptsQ(mask,1).^2 - ptsQ(mask,2).^2);

ptsR_x(mask) = ptsQ(mask, 1)*f./z(mask)/pix + ctr(1);
ptsR_y(mask) = ptsQ(mask, 2)*f./z(mask)/pix + ctr(2);

ptsR = [ptsR_x, ptsR_y];
end
