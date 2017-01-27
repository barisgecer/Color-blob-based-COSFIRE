function [ output ] = colorSpaceTransformT( image, params)
% Convert color space from the sRGB to the L*a*b* color space.
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

%% Gamma Correction
for alpha=1:3
    image(:,:,alpha)= imadjust(image(:,:,alpha),[0; 1],[0; 1],1/params.ColorSpace.gamma(alpha));
end

if strcmp(params.ColorSpace.name, 'Lab')
    C = makecform('lab2srgb');    
    image(:,:,1) = image(:,:,1) * 100;
    image(:,:,2) = (image(:,:,2)*255 - 128);
    image(:,:,3) = (image(:,:,3)*255 - 128) ;
    output = uint8(applycform(image,C)*255);
end
if strcmp(params.ColorSpace.name, 'ycbcr')
    output = ycbcr2rgb(uint8(image));
end
if strcmp(params.ColorSpace.name, 'hsv')
    output = hsv2rgb(image);
end
if strcmp(params.ColorSpace.name, 'No')
    output = image;
end
    
end
