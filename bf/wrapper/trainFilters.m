function [operators,Allprototypes,traintime] = trainFilters(trainingImages,conf)
% Train COSFIRE filters from training images of traffic signs
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

tic
operators={};

for class = conf.classes % For each class
    fprintf(1,'Training %d. category... Iterations:',class);
    %% Get the images from the class
    prototypes={};
    idx = find(trainingImages.Classes == class)';
    for i = idx(1:min(conf.frames,length(idx)))
		inputImage = imread(trainingImages.Paths(i,:));
		sz = [size(inputImage,1) size(inputImage,2)];
		prototypes{end+1} =  imresize(inputImage,sqrt(conf.totalPixel/(sz(1)*sz(2))));        
    end
    % Configurations
    allOperators = confMultiCCOSFIRE(prototypes,conf.params);
    for iOp = 1:length(allOperators)
        allOperators{iOp}.class = class;
        operators{end+1} = allOperators{iOp};
    end
    fprintf(1,'\n');
    Allprototypes{class==conf.classes} = prototypes;
end

%% Finalizing
nFullFilter = 0; nPartialFilter = 0;
for op = operators
    if op{1}.partial
        nPartialFilter = nPartialFilter + 1;
    else
        nFullFilter = nFullFilter + 1;
    end
end
nOfFilter = nPartialFilter + nFullFilter;
traintime = toc;
fprintf(1,'Configuration is done!\n%d full %d partial %d total filters are configured.\nTraining time is %f min\n',nFullFilter,nPartialFilter,nOfFilter,traintime/60);
