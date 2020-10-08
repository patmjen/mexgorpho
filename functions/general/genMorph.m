function res = genMorph(vol, strel, op, varargin)
% genMorph Grayscale morphology with grayscale structuring element
%
% res = genMorph(vol, strel, op)
% res = genMorph(___, name, value)
%
% Parameters
% ----------
% vol : numeric 3d array
%     Input grayscale volume.
% strel : numeric 3d array
%     Grayscale structuring element.
% op : numeric scalar
%     Number specifying morphological operation:
%     0 : Dilation
%     1 : Erosion
%
% Key-Value Parameters
% --------------------
% BlockSize : numeric vector or scalar, default: [256, 256, 256]
%     Block size for GPU processing as a length 3 vector or scalar.
% 
% Returns
% -------
% res : numeric 3d array
%     Result of morphological operation.
%
% See also
% --------
% genDilate genErode
%
% Example
% -------
%     % Simple dilation with an 11 x 11 x 11 box structuring element
%     vol = zeros(100,100,100);
%     vol(end/2,end/2,end/2) = 1;
%     strel = ones(11,11,11);
%     res = genMorph(vol, strel, 0); % Dilation
%
% Patrick M. Jensen, 2020, Technical University of Denmark

% Parse inputs
ensureGpuAvail();
narginchk(3, inf);
parser = inputParser;
% Required
addRequired(parser, 'vol', @(x) validateattributes(x, ...
    {'numeric'}, {'3d', 'nonsparse', 'real'}));
addRequired(parser, 'strel', @(x) validateattributes(x, ...
    {'numeric'}, {'3d', 'nonsparse', 'real'}));
addRequired(parser, 'op', @(x) validateattributes(x, ...
    {'numeric'}, {'scalar', 'real', 'integer', 'nonnegative', '<=', 5}));
% Key-value parameters
addParameter(parser, 'BlockSize', 256, @(x) validateattributes(x, ...
    {'numeric'}, {'integer', 'vector', 'positive', 'finite', 'nonnan'}));
parse(parser,vol,strel,op,varargin{:});
opts = parser.Results;

% Ensure blocks are not bigger than volume
opts.BlockSize = min(opts.BlockSize, size(vol));

% Run operation
res = gorpho_mex_genMorphOp(vol, strel, op, opts.BlockSize);