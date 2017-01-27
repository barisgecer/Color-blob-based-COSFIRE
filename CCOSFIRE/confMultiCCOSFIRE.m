function [ allOperators ] = confMultiCCOSFIRE(prototypePatterns, params, center, LabSpace)
% Configure(learn) filters from multiple prototypes
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

if nargin <2
    params = Parameters;
end
allOperators = {};
for i = 1 : size(prototypePatterns,2)
    prototypePattern = prototypePatterns{i};
    operators = [];
    if nargin <3
        operators = configureCCOSFIRE(prototypePattern, params);
    elseif nargin <4
        operators = configureCCOSFIRE(prototypePattern, params, center{i});
    else
        operators = configureCCOSFIRE(prototypePattern, params, center{i}, LabSpace{i});
    end
    for op = operators
        op{1}.imgId = i;
        allOperators{end+1} = op{1};
    end
end
end

