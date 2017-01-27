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
warning('off', 'stats:kmeans:EmptyCluster');

for class = conf.classes % For each class
    fprintf(1,'Training %d. category... Iterations:',class);
    %% Get the images from the class
    idx = trainingImages.Classes == class; 
    [Imgs ImgsOrg] = loadImg(trainingImages.Paths(idx,:),trainingImages.Crops(idx,:),conf);
    
    %% Configure a filter for the mean image which is also to get relevant positions
    meanPrototype = reshape(mean(Imgs,2),conf.sz(1),conf.sz(2),length(conf.params.ColorSpace.channels));
    temp = conf;
    if strcmp(temp.params.partial.T,'partial')
        temp.params.partial.T = 'together';
    end
    operatorsOfMean = configureCCOSFIRE(meanPrototype, temp.params, conf.sz/2, meanPrototype);
    operatorForClutering = operatorsOfMean{1};
    startId = 1 + double(strcmp(conf.params.partial.T,'partial') && strcmp(temp.params.partial.T,'together'));
    for iOp = startId:length(operatorsOfMean)
        operatorsOfMean{iOp}.class = class;
        operators{end+1} = operatorsOfMean{iOp};
    end
    
    %% Cluster images 
    %operatorForClutering has relevant positions for clustering images
    prototypes = ClusterImages(Imgs,ImgsOrg,operatorForClutering,conf);
    
    %% and configure a filter for each
    centers = {}; % Get centre of each prototypes
    for i = 1:length(prototypes)
        centers{i} = [round(size(prototypes{i},1)/2) round(size(prototypes{i},2)/2)];
    end
    % Configurations
    allOperators = confMultiCCOSFIRE(prototypes,conf.params,centers,prototypes);
    % Save the operators
    for iOp = startId:length(allOperators)
        allOperators{iOp}.class = class;
        operators{end+1} = allOperators{iOp};
    end
    fprintf(1,'\n');
    
    prototypes{end+1} = meanPrototype;
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
