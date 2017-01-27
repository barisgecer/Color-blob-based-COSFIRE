% Create new operators
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.
allOperators = {};

fullOperator.tuples = [];
fullOperator.params = params;
fullOperator.size = sz;
fullOperator.center = center;
fullOperator.partial = false;

partialOperators = cell(size(params.partial.Sz,2),params.partial.N);

for jOp = 1:size(params.partial.Sz,2)
    partials = ones(sz(1),sz(2));
    for iOp=1:params.partial.N % partialN operators are configured, than the
        % most significant one is chosen at the end.
        %rng('shuffle');
        f = find(partials);
        if size(f,1) == 0
            partials = ones(sz(1),sz(2));            
            f = find(partials);
        end
        [r c] = ind2sub(size(partials),f(1+floor(rand(1)*size(f,1))));
        partials  = createDisk(partials,r,c,params.partial.Sz(jOp),0);
        
        partialOperators{jOp,iOp}.tuples = [];
        partialOperators{jOp,iOp}.params = params;
        partialOperators{jOp,iOp}.size = sz;
        partialOperators{jOp,iOp}.center = [r c];
        partialOperators{jOp,iOp}.partial = true;
    end
end
