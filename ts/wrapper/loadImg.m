function [Images ImagesOrg] = loadImg(images,Crops,conf)
% Load images and do the color transformation (i.e. from RGB to LAB)
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

w=conf.sz(1); h=conf.sz(2);
chs = conf.params.ColorSpace.channels;
chsOrg = 1:3;
Images = zeros(w*h*size(chs,2),size(images,1));
for i = 1:size(images,1)
    fullImg = imread(images(i,:));
    croppedImg = fullImg(Crops(i, 2) + 1:Crops(i, 4) + 1, Crops(i, 1) + 1:Crops(i, 3) + 1,:);
    ImgOrg = imresize(croppedImg,conf.sz);
    Img = colorSpaceTransform(ImgOrg,conf.params);
    Images(1:w*h*size(chs,2),i) = reshape(Img(:,:,chs),w*h*size(chs,2),1);   % Make a column vector
    ImagesOrg(1:w*h*size(chsOrg,2),i) = reshape(ImgOrg(:,:,chsOrg),w*h*size(chsOrg,2),1);   % Make a column vector
end