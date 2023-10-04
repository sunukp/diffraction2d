% This script demonstrates basic usages of modules in this package.

% laser properties:
lambda = 445; % wavelength, nm
d = 5000; % diffraction grating period, nm
unit = lambda/d; % dimensionless unit in direction cosine (Q) space
mord = 7; % maximum order of diffraction we consider

% camera properties:
dims = [4608 3456]/4; % number of pixels in images
pix = 1e-3; % sensor dims in mm
f = 1.8/4; % focal length in mm
ctr=(dims+1)/2;

%% grid pattern1 - perfect grid

% To generate a symmetric (mord x mord) grid:
[X, Y] = gengrid2d(unit, mord);

figure
plot(X, Y, 'b.')
axis equal
grid on
set(gca, 'ydir', 'reverse')

%% grid pattern2 - distorted grid
shift = [0.5, 0]; % shifted 0.5 units in the x-direction only
yxratio = 0.9; % y/x=0.9
theta = 15; % rotation in degrees
% transformations are made in the shift->yxratio->theta order
[X2, Y2] = gengrid2d(unit, mord, shift, yxratio, theta);

figure
plot(X2, Y2, 'b.')
axis equal
grid on
set(gca, 'ydir', 'reverse')
%% diffraction pattern1 - perfect grating

% Internally gendiffr2d() calls gengrid2d() above and maps the grid in
% Q-space to R-space.
% We need camera properties (dims, pix, f) in order to define the R-space
shift = [];
yxratio = [];
theta = [];

[XR, YR] = gendiffr2d(unit, mord, shift, yxratio, theta, dims, pix, f);

figure
plot(XR(:)+ctr(1), YR(:)+ctr(2), 'b.')
axis equal
grid on
xlim([0, dims(1)])
ylim([0, dims(2)])
set(gca, 'ydir', 'reverse')
title('diffraction pattern of 445nm laser at focal length 0.45mm')

%% diffraction pattern2 - imperfect grating
shift = [0.5, 0]; % shifted 0.5 units in the x-direction only
yxratio = 0.9; % y/x=0.9
theta = 15; % rotation in degrees
[XR2, YR2] = gendiffr2d(unit, mord, shift, yxratio, theta, dims, pix, f);

figure
plot(XR2(:)+ctr(1), YR2(:)+ctr(2), 'b.')
% plot(XR2(:), YR2(:), 'b.')
axis equal
grid on
xlim([0, dims(1)])
ylim([0, dims(2)])
set(gca, 'ydir', 'reverse')
title('diffraction of 445nm laser at focal length 0.45mm with imperfect grid')
