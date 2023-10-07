function [nvec, theta]=findvecrot(vec_incidence, vec_basis)
% Find vector and angle of rotation. Expect the returned values to be used
% with rodrigues() function. In this formulation vec_basis rotates to match
% vec_incidence.
% Returns:
% nvec: unit axis of rotation
% theta: in radians
if nargin < 2
    vec_basis=[0 0 1];
end
nvec = cross(vec_basis, vec_incidence);
nvec = nvec/norm(nvec);
theta = acos(dot(vec_basis, vec_incidence) / (norm(vec_basis) * norm(vec_incidence)));
end
