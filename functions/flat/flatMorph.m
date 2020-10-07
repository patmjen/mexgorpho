function res = flatMorph(vol, strel, op, varargin)
% FLATMORPH Grayscale morphology with flat structuring element
%
% res = flatMorph(vol, strel, op)
% res = flatMorph(___, name, value)
%
% Parameters
% ----------
% vol : numeric 3d array
%     Input grayscale volume.
% strel : numeric 3d array
%     Flat structuring element.
% op : numeric scalar
%     Number specifying morphological operation:
%     0 : Dilation
%     1 : Erosion
%     2 : Opening
%     3 : Closing
%     4 : Tophat
%     5 : Bothat
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
% flatDilate flatErode flatOpen flatClose flatTophat flatBothat
%
% Example
% -------
%     % Simple dilation with an 11 x 11 x 11 box structuring element
%     vol = zeros(100,100,100);
%     vol(end/2,end/2,end/2) = 1;
%     strel = ones(11,11,11);
%     res = flatMorph(vol, strel, 0); % Dilation
%
% Patrick M. Jensen, 2020, Technical University of Denmark

% Parse inputs
narginchk(3, inf);
parser = inputParser;
% Required
addRequired(parser, 'vol', @(x) validateattributes(x, ...
    {'numeric', 'logical'}, {'3d', 'nonsparse', 'real'}));
addRequired(parser, 'strel', @(x) validateattributes(x, ...
    {'numeric', 'logical'}, {'3d', 'nonsparse', 'real'}));
addRequired(parser, 'op', @(x) validateattributes(x, ...
    {'numeric'}, {'scalar', 'real', 'integer', 'nonnegative', '<=', 5}));
% Key-value parameters
addParameter(parser, 'BlockSize', 256, @(x) validateattributes(x, ...
    {'numeric'}, {'integer', 'vector', 'positive', 'finite', 'nonnan'}));
parse(parser,vol,strel,op,varargin{:});
opts = parser.Results;

% Ensure strel is logical
strel = castIfNot(strel, 'logical');

% Ensure blocks are not bigger than volume
opts.BlockSize = min(opts.BlockSize, size(vol));

if islogical(vol)
    % If vol is logical we first cast it to uint8 and then recast res back
    % to logical
    vol = cast(vol, 'uint8');
    res = gorpho_mex_flatMorphOp(vol, strel, op, opts.BlockSize);
    res = cast(res, 'logical');
else
    res = gorpho_mex_flatMorphOp(vol, strel, op, opts.BlockSize);
end