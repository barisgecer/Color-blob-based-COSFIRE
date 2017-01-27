% Training a COSFIRE filter for the toy image and applying to the test
% image (see Figure 3-5)
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

addpath('../CCOSFIRE');

%% Parameters
params = Parameters(1);
params.resolution = 0.1; % To obtain better filters and results increase this.(i.e. 1 means use original sizes)
params.ColorSpace.name = 'Lab';
params.ColorSpace.gamma = [1 1 1];
params.DOG.sigmalist = (60:3:102)*params.resolution;
params.COSFIRE.t1 = [0.8 0.5 0.5];
params.COSFIRE.minNTuples = 1;
params.COSFIRE.lambda = 0;
params.partial.T = 'full' ; ['partial','full','together']; 

%% L a b channels
trainingImage = imread('face.png');
trainingImageLab = colorSpaceTransform(trainingImage,params);
testingImage = imread('face_others.png');
testingImageLab = colorSpaceTransform(testingImage,params);

%% Configuration
operator = configureCCOSFIRE(trainingImage, params)
operator{1}.tuples
displ(operator{1},params.resolution);

%% Apply Filter
[outputs] = applyCCOSFIRE(testingImage, operator);
figure;imshow(outputs{1}/0.2);




