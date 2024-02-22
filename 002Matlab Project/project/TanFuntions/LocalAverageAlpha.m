function [alpha, count] = LocalAverageAlpha(a, b, alpha, count, unknownAlpha, width, height)
% Calculates the local average of alpha values around a specified pixel
% to smooth the initial alpha matte.
%
% Inputs:
%   a, b - The coordinates of the current pixel.
%   alpha - The current alpha value for the pixel (initially set to 0).
%   count - The count of neighboring pixels considered in the average.
%   unknownAlpha - The matrix of initial alpha values.
%   width, height - Dimensions of the alpha matrix.
%
% Outputs:
%   alpha - The updated alpha value after local averaging.
%   count - The updated count of neighboring pixels considered.

% Iterate over the 3x3 neighborhood centered at (a, b)
% calculate alpha value with average for smooth
% the points nearby this point which are unknown points
for x = max(a-1, 1):min(a+1, width)
    for y = max(b-1, 1):min(b+1, height)
        if ~(x == a && y == b) % Exclude the center pixel
            alpha = alpha + unknownAlpha(x, y);
            count = count + 1;
        end
    end
end

