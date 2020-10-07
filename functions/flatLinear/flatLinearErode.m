function res = flatLinearErode(vol, lineSteps, lineLens, varargin)
% flatLinearErode Grayscale erosion with flat linear structuring elements
%
% res = flatLinearErode(vol, lineSteps, lineLens)
% res = flatLinearErode(___, name, value)
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
%     Result of erosion.
%
% Example
% -------
%     % Simple erosion with an 11 x 15 x 21 box structuring element
%     vol = ones(100,100,100);
%     vol(end/2,end/2,end/2) = 0;
%     lineSteps = [1 0 0; 0 1 0; 0 0 1];
%     lineLens = [11 15 21];
%     res = flatLinearErode(vol, lineSteps, lineLens);
%
% Patrick M. Jensen, 2020, Technical University of Denmark

res = flatLinearMorph(vol, lineSteps, lineLens, 1, varargin{:});