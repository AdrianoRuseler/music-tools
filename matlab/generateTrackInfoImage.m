function generateTrackInfoImage(keyStr, tempoVal, energyVal, filename)
% generateTrackInfoImage creates a PNG image showing Key, Tempo, and Energy
% Inputs:
%   keyStr    - string, e.g., '5A'
%   tempoVal  - numeric, e.g., 140
%   energyVal - numeric (1–10), e.g., 7
%   filename  - string, output PNG filename, e.g., 'track_info.png'

% Validate inputs
if energyVal < 0 || energyVal > 10
    error('Energy must be between 0 and 10');
end

% Create figure
fig = figure('Visible', 'off', 'Position', [100, 100, 300, 150]);
axes('Position', [0 0 1 1]); axis off;

% Background
rectangle('Position', [0, 0, 1, 1], 'FaceColor', [0.95 0.95 0.95], 'EdgeColor', 'none');
% Get hex color from key
hexColor = getColorHex(keyStr);
rgbColor = sscanf(hexColor(2:end), '%2x%2x%2x', [1 3]) / 255;

% Draw Key box with dynamic color
% rectangle('Position', [0.05, 0.65, 0.25, 0.25], 'FaceColor', rgbColor, 'EdgeColor', 'none');
% rectangle('Position', [0, 0, 1, 1], 'FaceColor', rgbColor, 'EdgeColor', 'none');

% Key box
rectangle('Position', [0.05, 0.65, 0.25, 0.25], 'FaceColor', rgbColor, 'EdgeColor', 'none');
% rectangle('Position', [0.05, 0.65, 0.25, 0.25], 'FaceColor', [1.0, 0.8, 0.6], 'EdgeColor', 'none');
text(0.175, 0.8, 'Key', 'FontSize', 10, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(0.175, 0.7, keyStr, 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

% Tempo
text(0.4, 0.8, 'Tempo', 'FontSize', 10, 'FontWeight', 'bold');
text(0.4, 0.7, sprintf('%d BPM', tempoVal), 'FontSize', 12, 'FontWeight', 'bold');

% Energy label
text(0.7, 0.8, 'Energy', 'FontSize', 10, 'FontWeight', 'bold');
text(0.7, 0.7, sprintf('%d', energyVal), 'FontSize', 12, 'FontWeight', 'bold');

% Energy bar
barWidth = 0.2;
barHeight = 0.05;
maxBars = 10;
filledBars = energyVal;
barX = 0.7;
barY = 0.6;

for i = 1:maxBars
    x = barX + (i-1)*(barWidth/maxBars);
    color = [0.8 0.8 0.8]; % gray
    if i <= filledBars
        color = [0.2 0.6 1.0]; % blue
    end
    rectangle('Position', [x, barY, barWidth/maxBars - 0.005, barHeight], ...
              'FaceColor', color, 'EdgeColor', 'none');
end

% Save image
exportgraphics(fig, filename, 'Resolution', 150);
close(fig);
end
