function res = flatErode(vol, strel, varargin)
% flatErode Grayscale erosion with flat structuring element
%
% res = flatErode(vol, strel)
% res = flatErode(___, name, value)
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
%     Result of erosion.
%
% See also
% --------
% flatDilate flatOpen flatClose flatTophat flatBothat flatMorph
%
% Example
% -------
%     % Simple erosion with an 11 x 11 x 11 box structuring element
%     vol = ones(100,100,100);
%     vol(end/2,end/2,end/2) = 0;
%     strel = ones(11,11,11);
%     res = flatErode(vol, strel);
%
% Patrick M. Jensen, 2020, Technical University of Denmark

res = flatMorph(vol, strel, 1, varargin{:});