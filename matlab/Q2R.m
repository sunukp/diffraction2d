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

ptsR = NaN(length(ptsQ), 2);
Z = NaN(length(ptsQ), 1);

ptsQrad = sqrt(ptsQ(:,1).^2 + ptsQ(:,2).^2);
mask = ptsQrad <= 1;
Z(mask) = sqrt(1 - ptsQrad(mask).^2);

ptsR(mask, :) = ptsQ(mask, :)*f./Z(mask)/pix + ctr;
end
