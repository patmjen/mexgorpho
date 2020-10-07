function res = flatDilate(vol, strel, varargin)
% flatDilate Grayscale dilation with flat structuring element
%
% res = flatDilate(vol, strel)
% res = flatDilate(___, name, value)
%
% Parameters
% ----------
% vol : numeric 3d array
%     Input grayscale volume.
% strel : numeric 3d array
%     Flat structuring element.
%
% Key-Value Parameters
% --------------------
% BlockSize : numeric vector or scalar, default: [256, 256, 256]
%     Block size for GPU processing as a length 3 vector or scalar.
% 
% Returns
% -------
% res : numeric 3d array
%     Result of dilation.
%
% Example
% -------
%     % Simple dilation with an 11 x 11 x 11 box structuring element
%     vol = zeros(100,100,100);
%     vol(end/2,end/2,end/2) = 1;
%     strel = ones(11,11,11);
%     res = flatDilate(vol, strel);
%
% Patrick M. Jensen, 2020, Technical University of Denmark

res = flatMorph(vol, strel, 0, varargin{:});