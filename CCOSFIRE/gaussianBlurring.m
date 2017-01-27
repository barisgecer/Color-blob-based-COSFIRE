function [ blurred ] = gaussianBlurring( image , gaus_sigma )
% Gaussian blurring
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

G_filter = fspecial('gaussian',2*ceil(2.5*gaus_sigma)+1,gaus_sigma);
blurred = conv2(double(image) , G_filter,'same');
blurred(blurred<0) = 0 ; % Eliminating small negative numbers

end

