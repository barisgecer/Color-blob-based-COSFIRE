function [ allOperators ] = configureCCOSFIRE(prototypePattern, params, center, LabSpace)
% Configure(learn) filters from a given prototype
%   prototypePattern : input image
%   params : Parameters
%   center : [row, column] Center of the filter
%   allOperators : Consist of Full+Partial operators in a cell array
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

%% Process input/output arguments
if nargin <2
    params = Parameters;
end
prototypePattern = imresize(prototypePattern,params.resolution);
sz = [size(prototypePattern,1) size(prototypePattern,2)];

if nargin <3
    center = round(sz/2);
end

if nargin <4 % Convert color space from the sRGB to the L*a*b* color space.
    LabSpace = colorSpaceTransform(prototypePattern,params);
end

% Create new operators
newOperators;

% Create masks to consider only regions where there is significant color information
Masks = createMasks( LabSpace, params );

%% For each color space (a and b from Lab)

for alpha = params.ColorSpace.channels
    channel = LabSpace(:,:,alpha);
    
    %% For centre-on and off DoG filters
    for mu = [1 -1]
        i=1;
        dogResponses = zeros([size(channel) size(params.DOG.sigmalist,2)]);
        
        for sigma = mu * params.DOG.sigmalist % Size of DoGs
            dogResponses(:,:,i) = dogFilter(channel, sigma,params);
            i=i+1;
        end
        
        %% Find maximum superposition of all responses
        [maxesResp, parInd] = max(dogResponses,[],3);
        if params.COSFIRE.b(alpha)>0 % Blurring
            maxesResp = gaussianBlurring(maxesResp,params.COSFIRE.b(alpha));end
        
        %% Find Peaks
        
        regionalMax = maxesResp.*(maxesResp > params.COSFIRE.t1(alpha)*max(maxesResp(:)));
        while sum(sum(regionalMax>0))>0
            % Conditions
            [~,index] = max(regionalMax(:));
            [r c] = ind2sub(size(regionalMax),index);
            sigma = mu * params.DOG.sigmalist(parInd(index));
            radius = params.COSFIRE.disk_radius * abs(sigma);
            atInside = r+radius < sz(1) & c+radius < sz(2) & r-radius >0 & c-radius>0;
            [modified circle] = createDisk(regionalMax,r,c,radius,-1);
            noOverlap = sum( (regionalMax(:)~=-1) & circle(:) ) > sum(circle(:)) * params.COSFIRE.t2;
            
            if Masks(r,c,alpha) & atInside & noOverlap
                regionalMax = modified ;
                [phi, rho] = cart2pol(-center(2)+c, center(1)-r);
                phi = wrapTo2Pi(phi);
                fullOperator.tuples(end+1,:) = [
                    alpha , ... Color band number
                    sign(sigma), ... polarity
                    abs(sigma), ... Size of DoG
                    rho, ... Polar coordinate radius
                    phi ... Polar coordinate angle
                    ];
                %
                for jOp = 1:size(params.partial.Sz,2)
                    for iOp=1:params.partial.N
                        if norm(partialOperators{jOp,iOp}.center - [r,c]) < params.partial.Sz(jOp)
                            [phi, rho] = cart2pol(-partialOperators{jOp,iOp}.center(2)+c, partialOperators{jOp,iOp}.center(1)-r);
                            phi = wrapTo2Pi(phi);
                            partialOperators{jOp,iOp}.tuples(end+1,:) = [
                                alpha , ... Color band number
                                sign(sigma), ... polarity
                                abs(sigma), ... Size of DoG
                                rho, ... Polar coordinate radius
                                phi, ... Polar coordinate angle
                                ];
                        end
                    end
                end
            else
                % If condition for the max points does skip that point,
                % consider the next maximum value.
                regionalMax(index) = 0;
            end
        end
    end
end

if size(fullOperator.tuples,1) > params.COSFIRE.minNTuples && (strcmp(params.partial.T,'full') || strcmp(params.partial.T,'together')) 
    allOperators{1} = fullOperator;
    fprintf(1,'+');
end

%% Find the most significant partial operators for each size
for jOp = 1:size(params.partial.Sz,2)
    maxV=0;
    for iOp=1:params.partial.N
        if size(partialOperators{jOp,iOp}.tuples,1) >= maxV
            maxV = size(partialOperators{jOp,iOp}.tuples,1);
            ind = iOp;
        end
    end
    if size(partialOperators{jOp,ind}.tuples,1) > params.COSFIRE.minNTuples && (strcmp(params.partial.T,'partial') || strcmp(params.partial.T,'together')) 
        allOperators{end+1}= partialOperators{jOp,ind};        
        fprintf(1,'-');
    end
end

end
