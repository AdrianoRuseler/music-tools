function generateColoredBoxImage(keyLetter, imageWidth, imageHeight)
% GENERATECOLOREDBOXIMAGE Generates and saves a PNG image of a colored box with text.
%
%   GENERATECOLOREDBOXIMAGE(KEYLETTER, IMAGEWIDTH, IMAGEHEIGHT)
%   creates a PNG image with a background color determined by KEYLETTER
%   and displays KEYLETTER as text in the center.
%
%   Inputs:
%       keyLetter   - A string representing the key letter (e.g., '5A', '12B').
%                     This is also the text displayed on the image.
%       imageWidth  - The desired width of the output image in pixels.
%       imageHeight - The desired height of the output image in pixels.
%
%   Example:
%       generateColoredBoxImage('5A', 300, 100); % Creates '5A_box.png'
%       generateColoredBoxImage('10B', 400, 150); % Creates '10B_box.png'

    % Validate inputs
    if nargin < 3
        error('generateColoredBoxImage:NotEnoughInputs', 'Please provide keyLetter, imageWidth, and imageHeight.');
    end
    if ~ischar(keyLetter) || isempty(keyLetter)
        error('generateColoredBoxImage:InvalidKeyLetter', 'keyLetter must be a non-empty string.');
    end
    if ~isnumeric(imageWidth) || ~isscalar(imageWidth) || imageWidth <= 0
        error('generateColoredBoxImage:InvalidWidth', 'imageWidth must be a positive scalar number.');
    end
    if ~isnumeric(imageHeight) || ~isscalar(imageHeight) || imageHeight <= 0
        error('generateColoredBoxImage:InvalidHeight', 'imageHeight must be a positive scalar number.');
    end

    % --- 1. Get the color hex code using the previously defined function ---
    hexCode = getColorHex(keyLetter);

    % Convert hex code to RGB [0, 1] for image creation
    % Remove the '#' prefix if present
    if startsWith(hexCode, '#')
        hexCode = hexCode(2:end);
    end
    % Convert hex string to decimal values
    red = hex2dec(hexCode(1:2)) / 255;
    green = hex2dec(hexCode(3:4)) / 255;
    blue = hex2dec(hexCode(5:6)) / 255;
    bgColor = [red, green, blue];

    % --- 2. Create an image figure and axes ---
    fig = figure('Visible', 'off', ... % Make figure invisible initially
                 'Position', [100 100 imageWidth imageHeight], ...
                 'Color', bgColor, ... % Set figure background color
                 'MenuBar', 'none', ...
                 'ToolBar', 'none');

    ax = axes('Parent', fig, ...
              'Units', 'normalized', ...
              'Position', [0 0 1 1], ... % Make axes fill the figure
              'Color', bgColor, ...      % Set axes background color
              'XLim', [0 imageWidth], 'YLim', [0 imageHeight], ...
              'XTick', [], 'YTick', [], ...
              'Box', 'off'); % Remove box around axes

    % --- 3. Add the keyLetter text centered on the background ---
    text(ax, imageWidth / 2, imageHeight / 2, keyLetter, ...
         'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'middle', ...
         'Color', 'k', ... % Text color (black for contrast)
         'FontSize', min(imageWidth, imageHeight) * 0.3, ... % Dynamic font size
         'FontWeight', 'bold');

    % --- 4. Save the image as a PNG file ---
    filename = sprintf('%s_box.png', keyLetter);
    % Ensure a tight border around the image
    set(fig, 'PaperPositionMode', 'auto');
    print(fig, filename, '-dpng', sprintf('-r%d', 300)); % -r300 for 300 DPI resolution

    % Close the figure to clean up
    close(fig);

    fprintf('Image saved as %s\n', filename);
end