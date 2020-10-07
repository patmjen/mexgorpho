function [lineSteps, lineLens] = flatBallApprox(radius, varargin)
% flatBallApprox Line segment approximation to flat ball strel
%
% [lineSteps, lineLens] = flatBallApprox(radius)
% [lineSteps, lineLens] = flatBallApprox(radius, approxType)
%
% Parameters
% ----------
% radius : numeric scalar
%     Radius of ball.
% approxType : numeric scalar, default: 1
%     Type of approximation: 
%     0 : Approximation is contained inside the ball.
%     1 : Best possible.
%     2 : Approximation is contains the ball.
%
% Returns
% -------
% lineSteps : int32 matrix
%     N x 3 matrix with step vectors for line segments.
% lineLens : int32 vector
%     N x 1 vector with length sof line segments (in steps).
%
% See also
% --------
% flatLinearDilate flatLinearErode flatLinearMorph
%
% Example
% -------
%     % Dilation with ball approximation of radius 25
%     vol = zeros(100,100,100);
%     vol(end/2,end/2,end/2) = 1;
%     [lineSteps, lineLens] = flatBallApprox(25);
%     res = flatLinearDilate(vol, lineSteps, lineLens);
%
% Patrick M. Jensen, 2020, Technical University of Denmark

% The approximation is computed according to:
%
% Jensen, P. M., Trinderup, C. H., Dahl, A. B., & Dahl, V. A. (2019). 
% "Zonohedral Approximation of Spherical Structuring Element for Volumetric 
% Morphology". In Proceedings of Scandinavian Conference on Image Analysis
% (pp. 128-139). DOI: https://doi.org/10.1007/978-3-030-20205-7_11

% Parse inputs
narginchk(1, 2);
parser = inputParser;
addRequired(parser, 'radius', @(x) validateattributes(x, ...
    {'numeric'}, {'scalar', 'nonsparse', 'real', 'integer', 'positive'}));
addOptional(parser, 'approxType', 1, @(x) validateattributes(x, ...
    {'numeric'}, {'3d', 'nonsparse', 'real', 'integer', '>=', 0,...
    '<=', 2}));
parse(parser, radius, varargin{:});
approxType = parser.Results.approxType;

% Get result
[lineSteps, lineLens] = gorpho_mex_flatBallApprox(radius, approxType);