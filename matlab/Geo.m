classdef Geo
    % A collection of geometry methods

    methods(Static)
        function pt=lintersect(l1, l2)
            % Computes the intersection beween lines l1 and l2
            % Line (2d) representation in [a b c] for ax+by+c=0
            cr = cross(l1, l2);
            if cr(3)==0
                % parallel lines; meets at infinity - we don't care about which
                % infinity or NaN
                pt = [Inf Inf];
            else
                pt = hom2cart(cr);
            end
        end

        function ln=lthrupts(pt1, pt2)
            % Computes the 2d line through 2 pts pt1 & pt2.
            % Line ln represented as [a b c] (ax+by+c=0), so ln is unique only up to sign.
            ln = cross(cart2hom(pt1), cart2hom(pt2));
        end

        function [pt, t]=rayplaneintersect(ln0, ln1, nvec, d)
            % Intersection of line given by line=ln0+t*ln1, and the plane defined by n, d,
            % {x: dot(n, x)+d=0} where
            % ln0: initial point of ray (may be size of (n, 3))
            % ln1: direction of ray (may be size of (n, 3))
            % nvec: normal vector to the plane
            % d: distance of plane to origin
            t = -(ln0*nvec' + d) ./ (ln1*nvec');
            pt = ln0 + t.*ln1;
        end

        function theta=vec_angle(v1, v2)
            % Computes the angle between v1 and v2 in 3d.
            % theta in radians
            % v1, v2 can be (n, 3)
            nv1 = Geo.rownorm(v1);
            nv2 = Geo.rownorm(v2);
            theta = acos(dot(v1, v2)/(nv1 * nv2));
        end

        function theta=vec_angle2(v1, v2)
            % Computes the angle between v1 and v2, in 2d measured from v1
            % theta in radians
            % v1, v2 can be (n, 2)
            theta = atan2(v1(:, 1).* v2(:, 2) - v1(:, 2).*v2(:, 1), ...
                v1(:, 1).*v2(:, 1)+v1(:, 2).*v2(:, 2));
        end

        function proj=vec_proj(v1, v2)
            % Computes the projection of v1 onto v2
            proj = sum(v1.*v2) ./ sum(v2.*v2) .* v2;
        end

        function circPts=circAt(nvec, d, r, res)
            % Returns res number of circle points on the plane defined by (nvec, d)
            % of radius r. Convention plane = {x: dot(nvec, x)+d=0}.
            % This version assumes z component is nonzero.
            % Expects nvec as row vector. Return shape (n, 3)
            if nargin < 4
                res=100;
            end

            v1 = [0 nvec(3) -nvec(2)];
            v2 = [nvec(3) 0 -nvec(1)];


            tdom = linspace(0, 2*pi, res)';
            pt = d/norm(nvec)*nvec; % point on plane at distance d from origin (in case nvec is not unit)

            fun = @(t) pt + r*cos(t).*v1 + r*sin(t).*v2;
            circPts = fun(tdom);
        end

        
        function r=rownorm(v)
            r = sqrt(sum(v.^2, 2));
        end

        function rmat=rodriguesmat(n, theta)
            % Computes the Rodrigues rotation matrix
            % n: the UNIT vector about which we seek to rotate
            % theta in radians
            ncmat = Geo.ncross_mat(n);
            rmat = eye(3) + sin(theta)*ncmat + (1-cos(theta))*ncmat^2;
        end

        function mat=ncross_mat(n)
            % This is just an alternate method to compute cross products.
            % For any vector n, v, cross(n, v) = ncross_mat(n)*v
            mat = [0 -n(3) n(2); n(3) 0 -n(1); -n(2) n(1) 0];
        end

        function rmat=eulermat(eulerang, seq)
            % eulerang=[yzang zxang xyang] is the euler angles in radians
            % about x, y, z
            % seq is the sequence in which the rotations are applied
            % defaults to about z -> about y -> about x
            if nargin < 2
                seq = [3 2 1];
            end
            rot{1} = [1 0 0; 0 cos(eulerang(1)) -sin(eulerang(1)); 0 sin(eulerang(1)) cos(eulerang(1))];
            rot{2} = [cos(eulerang(2)) 0 sin(eulerang(2)); 0 1 0; -sin(eulerang(2)) 0 cos(eulerang(2))];
            rot{3} = [cos(eulerang(3)) -sin(eulerang(3)) 0; sin(eulerang(3)) cos(eulerang(3)) 0; 0 0 1];

            rmat = rot{seq(3)}*rot{seq(2)}*rot{seq(1)};
        end
    end

end