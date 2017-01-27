function [outputs] = applyCCOSFIRE(inputImage, operators)

% apply filters ('operators') to the inputImage
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

% First compute the responses for tuples with unqiue set of values of
% parameters (lambda, theta, rho, phi=0). This is done for efficiency purposes.
% The response for any given value of phi can then be computed by
% appropriate shifting.

params = operators{1}.params;
inputImage = imresize(inputImage,params.resolution);

if size(inputImage,3)==1
    for i =1:length(operators)
        operators{i}.tuples = operators{i}.tuples(operators{i}.tuples(:,1)==1,:);
    end
    LabSpace = inputImage;
else
    LabSpace = colorSpaceTransform(inputImage, params);
end

tupleResponses  = computeTuples(LabSpace,operators,params);

% Apply the given operator in a reflection-, rotation-, and scale-invariant mode
cosfirefun   = @(inputImage,operator,tupleResponses) computeCOSFIRE(inputImage,operator,tupleResponses);
scalefun     = @(inputImage,operator,tupleResponses) scaleInvariantCOSFIRE(inputImage,operator,tupleResponses,cosfirefun);
rotationfun  = @(inputImage,operator,tupleResponses) rotationInvariantCOSFIRE(inputImage,operator,tupleResponses,scalefun);

for j = 1: size(operators,2)
    if ~isequaln(operators{1}.params,operators{j}.params)
        throw(MException('Params:NotTheSame','Parameters of all the operators need to be same.Or else call this function multiple times for each set of params.'));
    end
	if size(operators{j}.tuples,1)>0
	    outputs{j} = reflectionInvariantCOSFIRE(LabSpace,operators{j},tupleResponses,rotationfun);
	else
	outputs{j} = ones(size(inputImage,1),size(inputImage,2)).*operators{j}.params.COSFIRE.eps;
	end
end



function tupleList = getTupleList(operator)
index = 1;
reflectOperator = operator;
params = operator.params;
tupleList = zeros((2^params.invariance.reflection)*length(params.invariance.scale.upsilonlist)*length(params.invariance.rotation.psilist),5);

for reflection = 1:2^params.invariance.reflection
    if reflection == 2
        reflectOperator.tuples(:,5) = mod(pi - reflectOperator.tuples(:,5),2*pi);
    end
    
    rotateOperator = reflectOperator;
    for psiindex = 1:length(params.invariance.rotation.psilist)
        rotateOperator.tuples(:,5) = mod(reflectOperator.tuples(:,5) + params.invariance.rotation.psilist(psiindex),2*pi);
        
        scaleOperator = rotateOperator;
        for upsilonindex = 1:length(params.invariance.scale.upsilonlist)
            % Scale the values of parameters lambda and rho of every tuple by a given upsilon value
            scaleOperator.tuples(:,4) = round(rotateOperator.tuples(:,4) * params.invariance.scale.upsilonlist(upsilonindex)*100)/100;
            scaleOperator.tuples(:,3) = round(rotateOperator.tuples(:,3) * params.invariance.scale.upsilonlist(upsilonindex)*100)/100;
            
            tupleList(index:(size(scaleOperator.tuples,1)+index-1),:) =scaleOperator.tuples;
            index = index + size(scaleOperator.tuples,1);
        end
    end
end

function dogResponses = computeTuples(LabSpace,operators,params)
% Get filter responses
tupleList = [];
for j = 1: size(operators,2)
	if size(operators{j}.tuples,1)>0
	    tL = getTupleList(operators{j});
	    tupleList = [tupleList; tL];
	end
end
S = tupleList(:,1:3);
inputfilterparams = unique(S,'rows'); % A unique set of (sigma, band)
ninputfilterparams  = size(inputfilterparams,1);
hashkeylist = cell(1,ninputfilterparams);
hashvaluelist = cell(1,ninputfilterparams);

for i = 1:ninputfilterparams
    hashkeylist{i} = getHashkey([inputfilterparams(i,:)]);
    [alpha,mu,sigma,~,~] = loadTuple( [inputfilterparams(i,1:3)  0 0 ] );
    response= dogFilter(LabSpace(:,:,alpha), sigma*mu, params);
    if params.COSFIRE.lambda > 0
        response = gaussianBlurring( response, params.COSFIRE.lambda );
    end
    hashvaluelist{1,i} = response;
end
dogResponses  = containers.Map(hashkeylist,hashvaluelist);


function output = reflectionInvariantCOSFIRE(inputImage,operator,tupleResponses,funCOSFIRE)
% Apply the given COSFIRE filter
output = feval(funCOSFIRE,inputImage,operator,tupleResponses);

if operator.params.invariance.reflection == 1
    % Create a COSFIRE operator which is selective for a reflected version (about
    % the y-axis) of the prototype pattern to which the given COSFIRE operator is
    % selective for.
    reflectionDetector = operator;
    
    reflectionDetector.tuples(:,5) = mod(pi - reflectionDetector.tuples(:,5),2*pi);
    
    % Apply the new filter to the inputImage
    reflectionoutput = feval(funCOSFIRE,inputImage,reflectionDetector,tupleResponses);
    
    % Take the maximum value of the output of the two COSFIRE filters
    output = max(output,reflectionoutput);
end

function output = rotationInvariantCOSFIRE(inputImage,operator,tupleResponses,funCOSFIRE)

output = zeros(size(inputImage,1),size(inputImage,2),size(operator.params.conc,2));
rotateDetector = operator;

for psiindex = 1:length(operator.params.invariance.rotation.psilist)
    % Create a COSFIRE operator which is selective for a rotated version of the
    % prototype pattern to which the given operator is selective for. This
    % is achieved by shifting the values of parameters (theta,rho) of every
    % tuple by a given psi value
    
    rotateDetector.tuples(:,5) = operator.tuples(:,5) + operator.params.invariance.rotation.psilist(psiindex);
    
    % Compute the output of the new COSFIRE filter for the given psi value
    rotoutput = feval(funCOSFIRE,inputImage,rotateDetector,tupleResponses);
    
    % Take the maximum over the COSFIRE outputs for all given values of psi
    output = max(rotoutput,output);
end

function output = scaleInvariantCOSFIRE(inputImage,operator,tupleResponses,funCOSFIRE)

output = zeros(size(inputImage,1),size(inputImage,2),size(operator.params.conc,2));
scaleDetector = operator;

for upsilonindex = 1:length(operator.params.invariance.scale.upsilonlist)
    % Create a COSFIRE operator which is selective for a scaled version of the
    % prototype pattern to which the given operator is selective for. This
    % is achieved by scaling the values of parameters (lambda,rho) of every
    % tuple by a given upsilon value
    
    scaleDetector.tuples(:,3) = round(operator.tuples(:,3) * operator.params.invariance.scale.upsilonlist(upsilonindex)*100)/100;
    scaleDetector.tuples(:,4) = round(operator.tuples(:,4) * operator.params.invariance.scale.upsilonlist(upsilonindex)*100)/100;
    
    % Compute the output of the new COSFIRE filter for the given psi value
    scaleoutput = feval(funCOSFIRE,inputImage,scaleDetector,tupleResponses);
    
    % Take the maximum over the COSFIRE outputs for all given values of upsilon
    output = max(output,scaleoutput);
end

function output = computeCOSFIRE(inputImage,operator,tupleResponses)
%Sum all the sizes of tuples

tupleweightsigma = sqrt(-max(operator.tuples(:,4))^2/(2*log(operator.params.COSFIRE.mintupleweight)));
operator.tuples(:,6) = exp(-operator.tuples(:,4).^2./(2*tupleweightsigma*tupleweightsigma));

totalWeight = sum(operator.tuples(:,6));
if strcmp(operator.params.COSFIRE.outputweightfunction,'geometric')
    weightedMean = ones(size(inputImage,1),size(inputImage,2));
elseif strcmp(operator.params.COSFIRE.outputweightfunction,'arithmetic')
    weightedMean = zeros(size(inputImage,1),size(inputImage,2));
end

if strcmp(operator.params.COSFIRE.outputweightfunction,'geometric')
    weightedMeanCh = ones(size(inputImage,1),size(inputImage,2),size(operator.params.ColorSpace.channels,2));
elseif strcmp(operator.params.COSFIRE.outputweightfunction,'arithmetic')
    weightedMeanCh = zeros(size(inputImage,1),size(inputImage,2),size(operator.params.ColorSpace.channels,2));
end

for tupleT = operator.tuples'
    tuple = tupleT';
    [alpha,~,~,rho,phi,weight] = loadTuple(tuple);
    dogResponse = tupleResponses(getHashkey(tuple(1:3)));
    
    %Shifting Responses
    [c , r] = pol2cart(phi,rho);
    shiftedResponse = imshift(dogResponse ,fix(r),-fix(c)) + operator.params.COSFIRE.eps;
    
    %Weight Function
    if strcmp(operator.params.COSFIRE.outputweightfunction,'geometric')
        weightedMeanCh(:,:,alpha) = weightedMeanCh(:,:,alpha) .* (shiftedResponse.^(weight/totalWeight));
    elseif strcmp(operator.params.COSFIRE.outputweightfunction,'arithmetic')
        weightedMeanCh(:,:,alpha) = weightedMeanCh(:,:,alpha) + (shiftedResponse.*(weight/totalWeight));
    end
end

for channel = operator.params.ColorSpace.channels
    weightedMean=weightedMean.*weightedMeanCh(:,:,channel);
    weightedMeanCh(:,:,channel) = weightedMeanCh(:,:,channel)...
        .^(totalWeight/sum(operator.tuples(operator.tuples(:,1)==channel,6)));
end
output = [];
for c = 1:size(operator.params.conc,2)
    if operator.params.conc(c) == 0
        output(:,:,c) = weightedMean;
    else
        output(:,:,c) = weightedMeanCh(:,:,operator.params.conc(c));
    end
end



