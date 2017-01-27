function [X Y t] = filterImages(inputImages,operators,totalPixel)
% Filter inputImages with given filters
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

tic;

X = []; Y = [];

for imgId = 1:size(inputImages.Paths,1)
	inputImage = imread(inputImages.Paths(imgId,:));
	sz = [size(inputImage,1) size(inputImage,2)];
    inputImage = imresize(inputImage,sqrt(totalPixel/(sz(1)*sz(2))));
    outputs = applyCCOSFIRE(inputImage, operators);
    maxResps = [];
    for i =1:length(operators)
        maxResps = [maxResps max(max(outputs{i}))];
    end    
    X(end+1,:)= maxResps;
    Y(end+1,:)= inputImages.Classes(imgId);
    fprintf(1,'+');
end
fprintf(1,'\n');
t = toc;
end
