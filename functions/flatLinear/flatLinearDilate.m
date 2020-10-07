function res = flatLinearDilate(vol, lineSteps, lineLens, varargin)
% flatLinearDilate Grayscale dilation with flat linear structuring elements
%
% res = flatLinearDilate(vol, lineSteps, lineLens)
% res = flatLinearDilate(___, name, value)
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
%     Result of dilation.
%
% See also
% --------
% flatLinearErode flatLinearMorph
% flatBallApprox
%
% Example
% -------
%     % Simple dilation with an 11 x 15 x 21 box structuring element
%     vol = zeros(100,100,100);
%     vol(end/2,end/2,end/2) = 1;
%     lineSteps = [1 0 0; 0 1 0; 0 0 1];
%     lineLens = [11 15 21];
%     res = flatLinearDilate(vol, lineSteps, lineLens);
%
% Patrick M. Jensen, 2020, Technical University of Denmark

res = flatLinearMorph(vol, lineSteps, lineLens, 0, varargin{:});