function res = flatBothat(vol, strel, varargin)
% flatBothat Grayscale bothat with flat structuring element
%
% res = flatBothat(vol, strel)
% res = flatBothat(___, name, value)
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
%     Result of bothat.
%
% Example
% -------
%     % Simple bothat with an 11 x 11 x 11 box structuring element
%     vol = ones(100,100,100);
%     vol(10:15,10:15,48:53) = 0; % Small box
%     vol(60:80,60:80,40:60) = 0; % Big box
%     strel = ones(11,11,11);
%     res = flatBothat(vol, strel);
%
% Patrick M. Jensen, 2020, Technical University of Denmark

res = flatMorph(vol, strel, 5, varargin{:});