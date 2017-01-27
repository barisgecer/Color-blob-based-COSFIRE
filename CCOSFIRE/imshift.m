function A = imshift(im, shiftRows, shiftCols)
% Image shifting
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.
A = zeros(size(im));

if shiftRows >= 0 && shiftCols >= 0
    A(1+shiftRows:end,1+shiftCols:end) = im(1:end-shiftRows,1:end-shiftCols);
elseif shiftRows >= 0 && shiftCols < 0
    A(1+shiftRows:end,1:end+shiftCols) = im(1:end-shiftRows,1-shiftCols:end);
elseif shiftRows < 0 && shiftCols >= 0
    A(1:end+shiftRows,1+shiftCols:end) = im(1-shiftRows:end,1:end-shiftCols);
else
    A(1:end+shiftRows,1:end+shiftCols) = im(1-shiftRows:end,1-shiftCols:end);
end