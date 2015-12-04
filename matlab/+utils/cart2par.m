% *************************************************************************
% * Copyright 2014 University of Bonn
% *
% * authors:
% *  - Sebastian Merzbach <merzbach@cs.uni-bonn.de>
% *
% * last modification date: 2014-09-10
% *
% * This file is part of btflib.
% *
% * btflib is free software: you can redistribute it and/or modify it under
% * the terms of the GNU Lesser General Public License as published by the
% * Free Software Foundation, either version 3 of the License, or (at your
% * option) any later version.
% *
% * btflib is distributed in the hope that it will be useful, but WITHOUT
% * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
% * License for more details.
% *
% * You should have received a copy of the GNU Lesser General Public
% * License along with btflib.  If not, see <http://www.gnu.org/licenses/>.
% *
% *************************************************************************
%
% This function converts cartesian coordinates specified as an N x 3 or 3 x N
% array into parabolic coordinates according to the equation x_{par} = x_{car} /
% (1 + z_{car]) and returns the parabolic x- and y-coordinates in an N x 2 or 2
% x N array.
%
% Usage:
%   xy_par = cart2par(xyz)
%   xy_par = cart2par(x, y, z)
% 
% where all input arrays are N x 3, 3 x N, N x 1 or 1 x N respectively and the
% output array is N x 2 or 2 x N.
function par = cart2par(varargin)
    % input parsing
    if numel(varargin) < 3
        % one input matrix of dimensions n x 3
        if size(varargin{1}, 1) == 3
            x = varargin{1}(1, :);
            y = varargin{1}(2, :);
            z = varargin{1}(3, :);
        else
            x = varargin{1}(:, 1);
            y = varargin{1}(:, 2);
            z = varargin{1}(:, 3);
        end
    elseif numel(varargin) >= 3
        % three separate matrices
        x = varargin{1};
        y = varargin{2};
        z = varargin{3};
    end
    n = size(x);
    
    par = zeros([2, prod(n)], class(x)); %#ok<ZEROLIKE>
    
    par(1, :) = reshape(x ./ (1 + z), 1, []);
    par(2, :) = reshape(y ./ (1 + z), 1, []);
    
    % let's try to maintain the array orientation
    if numel(n) == 2 && any(n == 1)
        % special case: 2D array -> keep orientation
        if (numel(varargin) < 3 && size(varargin{1}, 2) == 3 || ...
                numel(varargin) >= 3 && size(varargin{1}, 2) == 1)
            par = par';
        else
            par = reshape(par, [2, n(2)]);
        end
    else
        % otherwise we default to putting the xyz-coordinates into the first
        % dimension and keeping the the shape of the input
        par = reshape(par, [2, n]);
    end
end
