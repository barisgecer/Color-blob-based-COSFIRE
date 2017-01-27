function [X Y t] = filterTS(inputImages,operators,conf)
% Filter inputImages with given filters
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

tic;
if conf.gausWeSigma == 0
    gaussian = ones(conf.sz);
else
    gaussian = fspecial('gaussian',conf.sz,conf.gausWeSigma);
    gaussian = gaussian / max(gaussian(:));
end

gaussian = repmat(gaussian,[1,1,length(conf.params.conc)]);

X = []; Y = [];
crops = inputImages.Crops;

for imgId = 1:size(inputImages.Paths,1)
    fullImg = imread(inputImages.Paths(imgId,:));
    croppedImg = fullImg(crops(imgId, 2) + 1:crops(imgId, 4) + 1, crops(imgId, 1) + 1:crops(imgId, 3) + 1,:);
    inputImage = imresize(croppedImg,conf.sz);
    outputs = applyCCOSFIRE(inputImage, operators);
    maxResps = [];
    for i =1:length(operators)
        if operators{i}.partial
            maxResps = [maxResps splitMax(outputs{i},conf.splitGrid)];
        else
            maxResps = [maxResps reshape(max(max(outputs{i}.*gaussian)),1,length(conf.params.conc))];
        end
    end    
    X(end+1,:)= maxResps;
    Y(end+1,:)= inputImages.Classes(imgId);
    fprintf(1,'+');
end
fprintf(1,'\n');
t = toc;
end

function maxes = splitMax(response,s)
maxes = [];
for d = 1:size(response,3)
    resp = response(:,:,d);
    f = mat2cell( resp , repmat(floor(size(resp,1)/s(1)) ,1,s(1)) + [size(resp,1)-floor(size(resp,1)/s(1))*s(1) repmat(0 ,1,s(1)-1)], repmat(floor(size(resp,2)/s(2)),1,s(2))  + [size(resp,2)-floor(size(resp,2)/s(2))*s(2) repmat(0 ,1,s(2)-1)]);
    for i=1:size(f(:),1)
        maxes(end+1) = max(f{i}(:));
    end
end
end