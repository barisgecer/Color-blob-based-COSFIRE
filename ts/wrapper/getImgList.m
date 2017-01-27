function trainingImages = getImgList(conf)
%
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

classes = conf.classes;
frames = conf.frames;
trainingImages.Paths = char();
trainingImages.Crops = [];
trainingImages.Classes = [];
for classId = classes
    sPath = [conf.datasetdir,'Final_Training/Images/', num2str(classId, '%05d')];
    [ImgFiles, Rois, ~] = readSignData([sPath, '/GT-', num2str(classId, '%05d'), '.csv']);
    % Get the images
    nImage = size(ImgFiles,1);
    for i = 1:nImage
        if any(mod(i-1,30)+1==frames)
            path = ([sPath, '/', ImgFiles{i}]);
            trainingImages.Paths(end+1,:) = char(path);
            trainingImages.Crops(end+1,:) = Rois(i,:);
            trainingImages.Classes(end+1,:) = classId;
       end
    end
end
