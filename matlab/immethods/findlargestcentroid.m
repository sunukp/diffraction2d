function center=findlargestcentroid(img, bwthres, sigm)
% Finds the coordinates of the center of the largest object in img that
% satisfies intensity>bwthres. Smooth the img when necessary using matlab's
% imgaussfilt(). Wrapper for matlab's regionprops().
% bwthres: threshold. Please inspect the image format (uint8 or double)
% before using this function.
% sigm: standard deviation used for imgaussfilt()
if nargin < 3
    sigm=0;
end

if sigm > 0
    img=imgaussfilt(img, sigm);
end
bw = img > bwthres;


stats = regionprops(bw);

if size(stats(:), 1) > 1 
    % More than one centroid found - choose the centroid with largest area
    sz = size(stats(:), 1);
    centroids = zeros(sz, 2);
    areas = zeros(sz, 1);
    for k=1:size(stats(:), 1)
        areas(k) = stats(k).Area;
        centroids(k,:) = stats(k).Centroid;
    end
    
    [~, idx]=max(areas);
    center = round(centroids(idx,:));
else
    % One or none found
    if ~isempty(stats) && isfield(stats, 'Centroid')
        center = round(stats.Centroid);
    else
        center = NaN;
    end
end

end
