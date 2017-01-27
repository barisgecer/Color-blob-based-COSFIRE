function key = getHashkey(tuple)
% Generate hash key
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

tuple = [abs(tuple) tuple<0];
primelist = [2 3 5 7 11 13];%(1:length(tuple))*3;
key = prod(primelist(1:length(tuple)).^tuple);