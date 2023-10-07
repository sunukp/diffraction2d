function rotmat=rodriguesmat(nvec, theta, homo)
% Returns a Rodrigues matrix for rotation about unit normal vector nvec 
% for angle theta.
% nvec: unit vector about which rotation takes place
% theta: in radians
% homo: set to true if a 4x4 matrix in homogeneous coordinates is needed,
% else 3x3 in cartesian
if nargin < 3
    homo = false;
end

if homo
    nvec_cross = [
        0, -nvec(3), nvec(2), 0;
        nvec(3), 0, -nvec(1), 0;
        -nvec(2), nvec(1), 0, 0;
        0, 0, 0, 0
        ];
    rotmat = eye(4) + sin(theta)*nvec_cross + (1-cos(theta))*nvec_cross*nvec_cross;
else
    nvec_cross = [
        0, -nvec(3), nvec(2);
        nvec(3), 0, -nvec(1);
        -nvec(2), nvec(1), 0;
        ];

    rotmat = eye(3) + sin(theta)*nvec_cross + (1-cos(theta))*nvec_cross*nvec_cross;
end
end
