function res = flatLinearOpen(vol, lineSteps, lineLens, varargin)
% flatLinearOpen Grayscale opening with flat linear structuring elements
%
% res = flatLinearOpen(vol, lineSteps, lineLens)
% res = flatLinearOpen(___, name, value)
%
% Parameters
% ----------
% vol : numeric 3d array
%     Input grayscale volume.
% lineSteps : numeric matrix
%     Step vectors for line segments. Must be N x 3.    
% lineLens : numeric vector
%     Number of steps for line segments.
%
% Key-Value Parameters
% --------------------
% BlockSize : numeric vector or scalar, default: [512, 128, 128]
%     Block size for GPU processing as a length 3 vector or scalar.
% 
% Returns
% -------
% res : numeric 3d array
%     Result of opening.
%
% See also
% --------
% flatLinearErode flatLinearMorph
% flatBallApprox
%
% Example
% -------
%     % Simple opening with an 11 x 11 x 11 box structuring element
%     vol = zeros(100,100,100);
%     vol(10:15,10:15,48:53) = 1; % Small box
%     vol(60:80,60:80,40:60) = 1; % Big box
%     lineSteps = [1 0 0; 0 1 0; 0 0 1];
%     lineLens = [11 11 11];
%     res = flatLinearOpen(vol, lineSteps, lineLens);
%
% Patrick M. Jensen, 2020, Technical University of Denmark

res = flatLinearErode(vol, lineSteps, lineLens, varargin{:});
res = flatLinearDilate(res, lineSteps, lineLens, varargin{:});