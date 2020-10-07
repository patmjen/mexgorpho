function res = flatOpen(vol, strel, varargin)
% flatOpen Grayscale opening with flat structuring element
%
% res = flatOpen(vol, strel)
% res = flatOpen(___, name, value)
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
%     Result of opening.
%
% See also
% --------
% flatDilate flatErode flatClose flatTophat flatBothat flatMorph
%
% Example
% -------
%     % Simple opening with an 11 x 11 x 11 box structuring element
%     vol = zeros(100,100,100);
%     vol(10:15,10:15,48:53) = 1; % Small box
%     vol(60:80,60:80,40:60) = 1; % Big box
%     strel = ones(11,11,11);
%     res = flatOpen(vol, strel);
%
% Patrick M. Jensen, 2020, Technical University of Denmark

res = flatMorph(vol, strel, 2, varargin{:});