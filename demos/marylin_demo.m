% Training a COSFIRE filter with Marylin image (see Figure 2 and 9)
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

addpath('../CCOSFIRE');
% Load image
im = imresize(imread('marylin.jpg'),0.1);
% Load parameters
params = Parameters;
params.partial.T = 'full';
params.DOG.sigmalist = (30:1:80)/10;
% Train filter
alloperators = configureCCOSFIRE(im,params);
displ(alloperators{1},0.2)
% Test it
outputs = applyCCOSFIRE(im, alloperators);
max(outputs{1}(:))
