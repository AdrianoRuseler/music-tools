function hex = vuMeterColor(segmentIndex, totalSegments, opacity)
% vuMeterColor returns the RGBA hex color code for a VU meter segment
% Inputs:
%   segmentIndex    - Index of the segment (1 to totalSegments)
%   totalSegments   - Total number of segments in the meter
%   opacity         - Opacity value from 0 (transparent) to 1 (opaque)
% Output:
%   hex             - RGBA hex color code string (e.g., '#66FF0080')

if nargin < 3
    opacity=1;
end

% Clamp inputs
segmentIndex = max(1, min(segmentIndex, totalSegments));
opacity = max(0, min(opacity, 1));

% Normalize position (0 to 1)
t = (segmentIndex - 1) / (totalSegments - 1);

% Interpolate RGB across green → yellow → red
if t < 0.5
    % Green to Yellow
    R = round(2 * t * 255);
    G = 255;
else
    % Yellow to Red
    R = 255;
    G = round((1 - 2 * (t - 0.5)) * 255);
end
B = 0;

% Convert opacity to hex (00 to FF)
A = round(opacity * 255);

% Format as RGBA hex
hex = sprintf('#%02X%02X%02X%02X', R, G, B, A);
end
