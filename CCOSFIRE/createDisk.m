function [ image, onlyCircle ] = createDisk(image,x,y,rad,v)
% Create a logical image of a circle with specified
% diameter, center, and image size.
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

% First create the image.
[r c] =  meshgrid(1:size(image,2), 1:size(image,1));
% Next create the circle in the image.
%circlePixels = (rowsInImage - y).^2 ...
%    + (columnsInImage - x).^2 <= r.^2;
% circlePixels is a 2D "logical" array.
% Now, display it.
pixels = ((r - y).^2 + (c - x).^2) < rad.^2;
image(pixels)=v;
onlyCircle = zeros(size(image));
onlyCircle(pixels)=1;
end

