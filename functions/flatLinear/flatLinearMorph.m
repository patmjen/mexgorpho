function res = flatLinearMorph(vol, lineSteps, lineLens, op, varargin)
% flatLinearMorph Grayscale morph. with flat linear structuring elements
%
% res = flatLinearMorph(vol, lineSteps, lineLens, op)
% res = flatLinearMorph(___, name, value)
%
% Parameters
% ----------
% vol : numeric 3d array
%     Input grayscale volume.
% lineSteps : numeric matrix
%     Step vectors for line segments. Must be N x 3.    
% lineLens : numeric vector
%     Number of steps for line segments.
% op : numeric scalar
%     Number specifying morphological operation:
%     0 : Dilation
%     1 : Erosion
%
% Key-Value Parameters
% --------------------
% BlockSize : numeric vector or scalar, default: [512, 128, 128]
%     Block size for GPU processing as a length 3 vector or scalar.
% 
% Returns
% -------
% res : numeric 3d array
%     Result of morphological operation.
%
% See also
% --------
% flatLinearDilate flatLinearErode
% flatBallApprox
%
% Example
% -------
%     % Simple dilation with an 11 x 15 x 21 box structuring element
%     vol = zeros(100,100,100);
%     vol(end/2,end/2,end/2) = 1;
%     lineSteps = [1 0 0; 0 1 0; 0 0 1];
%     lineLens = [11 15 21];
%     res = flatLinearMorph(vol, lineSteps, lineLens, 0); % Dilation
%
% Patrick M. Jensen, 2020, Technical University of Denmark

% Parse inputs
narginchk(3, inf);
parser = inputParser;
% Required
addRequired(parser, 'vol', @(x) validateattributes(x, ...
    {'numeric', 'logical'}, {'3d', 'nonsparse', 'real'}));
addRequired(parser, 'lineSteps', @(x) validateattributes(x, ...
    {'numeric'}, {'2d', 'nonsparse', 'real', 'integer', 'ncols', 3}));
addRequired(parser, 'lineLens', @(x) validateattributes(x, {'numeric'},...
    {'vector', 'nonsparse', 'real', 'integer', 'nonnegative'}));
addRequired(parser, 'op', @(x) validateattributes(x, ...
    {'numeric'}, {'scalar', 'real', 'integer', 'nonnegative', '<=', 5}));
% Key-value parameters
addParameter(parser, 'BlockSize', [512, 128, 128],...
    @(x) validateattributes(x, {'numeric'},...
    {'integer', 'vector', 'positive', 'finite', 'nonnan'}));
parse(parser,vol,lineSteps,lineLens,op,varargin{:});
opts = parser.Results;

if size(lineSteps, 1) ~= length(lineLens)
    error('Number of step vectors and number of line lengths must be equal');
end

% Ensure blocks are not bigger than volume
opts.BlockSize = min(opts.BlockSize, size(vol));

% Ensure lineSteps and lineLens are class int32
lineSteps = castIfNot(lineSteps, 'int32');
lineLens = castIfNot(lineLens, 'int32');

if islogical(vol)
    % If vol is logical we first cast it to uint8 and then recast res back
    % to logical
    vol = cast(vol, 'uint8');
    res = gorpho_mex_flatLinearMorphOp(vol, lineSteps, lineLens, op,...
        opts.BlockSize);
    res = cast(res, 'logical');
else
    res = gorpho_mex_flatLinearMorphOp(vol, lineSteps, lineLens, op,...
        opts.BlockSize);
end