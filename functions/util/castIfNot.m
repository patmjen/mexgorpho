function x = castIfNot(x, className)
% castIfNot Cast x to className if it is a different class
%
% x = castIfNot(x, className)
%
% Parameters
% ----------
% x : any
%     Object to check and possibly cast.
% className : character array
%     Name of required class.
%
% Returns
% -------
% x : className
%     x cast to className if x had a different class.
%
% Example
% -------
%     % Ensure x is logical
%     x = 1;
%     x = castIfNot(x, 'logical');
%     assert(isa(x, 'logical'));
%
% Patrick M. Jensen, 2020, Technical University of Denmark

if ~isa(x, className)
    x = cast(x, className);
end