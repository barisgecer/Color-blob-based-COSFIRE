function params = Parameters(resolution)
% Initialize parameters
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

if nargin > 0 % Set the resolution to speed up
    params.resolution = resolution; 
else
    params.resolution = 1;
end

% Color Space attributes
params.ColorSpace.name = 'Lab'; %['Lab','ycbcr','No']
params.ColorSpace.illumination = 1;
params.ColorSpace.color = [2 ,3];
params.ColorSpace.gamma = [0.4 1 1] ; % Gamma correction parameter look 'doc imadjust'
params.ColorSpace.channels = [params.ColorSpace.illumination params.ColorSpace.color];

% Centre/surround cell ratio (?). sigma1 = coeff* sigma2;
params.DOG.gamma = 0.5;

% Parameters of some geometric invariances
params.invariance.rotation.psilist    = 0; %(0:22.5:359)*pi/180;
params.invariance.scale.upsilonlist   = 1; %2.^(-1.5:0.3:1.5);
params.invariance.reflection          = 0; % Reflection invariance about the y-axis. 0 = do not use, 1 = use.

%% Configuration of a CCOSFIRE

% The sigma list of DoG filter (sigma)
params.DOG.sigmalist = params.resolution * (5:2.5:150); 

% Threshold parameter used to suppress the input filters responses that are
% less than a fraction t1 of the maximum response 
params.COSFIRE.t1 = [0.2 0.55 0.55]; % Different in each channel 
%(i.e. for L a b respectively) and (0<=t1<=1)

% Minumum non-overlapping area percent of a new blob
params.COSFIRE.t2 = 0.4; % (% 0<=t2<=1)

% Sigma parameter of the Gaussian function used to blur input filter
params.COSFIRE.b = [0 0 0]* params.resolution;

% Take the disk out around matched point.
params.COSFIRE.disk_radius  = 0.96;

% Omit filters that has lower than 'minNTuples' number of tuples
params.COSFIRE.minNTuples = 10; % [0:Inf]

%% Response of a CCOSFIRE

% Sigma parameter of the Gaussian Blurring function that blurs DoG responses
params.COSFIRE.lambda = 4.5 * params.resolution;

% very small value to avoid zero values (i.e. 1e-8)
params.COSFIRE.eps = 0;

% The weight assigned to the peripherial contour parts
params.COSFIRE.mintupleweight = 0.5;

% Mean method of combining shifted filter responses
params.COSFIRE.outputweightfunction = 'geometric'; %['arithmetic','geometric']

params.conc = 0; % concatenation of responses of channels, 0: reponse of
%all channels, 1: response of only first channel i.e. L*.

%% Part(Partial) - Pattern(Full) Selectivity Options

params.partial.T = 'together' ; ['partial','full','together']; % Use any or both of them.
params.partial.Sz =  [120 120 120 120 120]* params.resolution; % Size of parts
params.partial.N = 3 ; % Number of randomly chosen regions for each part
