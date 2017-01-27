function [ output ] = colorSpaceTransform( image, params)
% Convert color space from the sRGB to the L*a*b* color space.
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

if strcmp(params.ColorSpace.name, 'gray')
    output = im2double(rgb2gray(uint8(image)));
end

if strcmp(params.ColorSpace.name, 'Lab')
    C = makecform('srgb2lab');
    output = (applycform(im2double(uint8(image)),C));
    
    output(:,:,1) = output(:,:,1) / 100;
    output(:,:,2) = (output(:,:,2) + 128) ./ 255;
    output(:,:,3) = (output(:,:,3) + 128) ./ 255;
end

if strcmp(params.ColorSpace.name, 'ycbcr')
    output = rgb2ycbcr(im2double(uint8(image)));
end
if strcmp(params.ColorSpace.name, 'hsv')
    output = rgb2hsv(image);
end
if strcmp(params.ColorSpace.name, 'No')
    output = image;
end

%% Gamma Correction
for alpha=params.ColorSpace.channels
    output(:,:,alpha)= imadjust(output(:,:,alpha),[0; 1],[0; 1],params.ColorSpace.gamma(alpha));
end

end

