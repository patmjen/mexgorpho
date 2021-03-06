function res = flatClose(vol, strel, varargin)
% flatClose Grayscale closing with flat structuring element
%
% res = flatClose(vol, strel)
% res = flatClose(___, name, value)
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
%     Result of Closeing.
%
% See also
% --------
% flatDilate flatErode flatOpen flatTophat flatBothat flatMorph
%
% Example
% -------
%     % Simple closing with an 11 x 11 x 11 box structuring element
%     vol = ones(100,100,100);
%     vol(10:15,10:15,48:53) = 0; % Small box
%     vol(60:80,60:80,40:60) = 0; % Big box
%     strel = ones(11,11,11);
%     res = flatClose(vol, strel);
%
% Patrick M. Jensen, 2020, Technical University of Denmark

res = flatMorph(vol, strel, 3, varargin{:});