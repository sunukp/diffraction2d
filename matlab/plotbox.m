function plotbox(x, y, clr)
if nargin<3
    clr='r';
end

line([x(1), x(2)], [y(1), y(1)], 'color', clr)
line([x(1), x(2)], [y(2), y(2)], 'color', clr)
line([x(1), x(1)], [y(1), y(2)], 'color', clr)
line([x(2), x(2)], [y(1), y(2)], 'color', clr)
end
