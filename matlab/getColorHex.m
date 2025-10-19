function hexCode = getColorHex(keyLetter)
% GETCOLORHEX Returns the approximate color hex code for a key letter from a color wheel.
%
%   HEXCODE = GETCOLORHEX(KEYLETTER) takes a string KEYLETTER
%   (e.g., '1A', '5B') and returns the corresponding approximate
%   background color hex code as a string.
%
%   Input:
%       keyLetter - A string representing the key letter (e.g., '1A', '12B').
%
%   Output:
%       hexCode   - A string containing the 6-digit hex color code (e.g., '#25D5E0').
%                   Returns '#FFFFFF' (White) if the key letter is not found.

    % Define the color map using a switch statement
    switch upper(keyLetter)
        % Ring A (Inner Ring - generally lighter/softer tones)
        case '1A'
            hexCode = '#25D5E0'; % Light Cyan/Teal
        case '2A'
            hexCode = '#4ED94E'; % Bright Green
        case '3A'
            hexCode = '#6DCF38'; % Lime Green
        case '4A'
            hexCode = '#E0DD39'; % Yellow-Green
        case '5A'
            hexCode = '#E2A941'; % Deep Yellow/Orange
        case '6A'
            hexCode = '#E17565'; % Light Coral/Salmon
        case '7A'
            hexCode = '#DD5590'; % Fuschia/Deep Pink
        case '8A'
            hexCode = '#C857BE'; % Lavender/Light Violet
        case '9A'
            hexCode = '#9E67D1'; % Light Indigo/Purple
        case '10A'
            hexCode = '#6692E1'; % Light Blue
        case '11A'
            hexCode = '#4DBAE3'; % Sky Blue
        case '12A'
            hexCode = '#38D4E5'; % Bright Cyan

        % Ring B (Outer Ring - generally stronger/deeper tones)
        case '1B'
            hexCode = '#15C6D1'; % Cyan/Teal
        case '2B'
            hexCode = '#38CB3A'; % Green
        case '3B'
            hexCode = '#55C31D'; % Strong Green
        case '4B'
            hexCode = '#D8D321'; % Vivid Yellow-Green
        case '5B'
            hexCode = '#DB9C2A'; % Burnt Orange
        case '6B'
            hexCode = '#DE6055'; % Coral/Salmon
        case '7B'
            hexCode = '#D63F7F'; % Vivid Pink
        case '8B'
            hexCode = '#BD44B2'; % Deep Lavender/Violet
        case '9B'
            hexCode = '#8E52C6'; % Indigo/Purple
        case '10B'
            hexCode = '#5081D9'; % Medium Blue
        case '11B'
            hexCode = '#34ACC7'; % Cyan Blue
        case '12B'
            hexCode = '#20C9D1'; % Strong Cyan

        % Default case for invalid input
        otherwise
            warning('getColorHex:InvalidKey', 'Key letter "%s" not found in the color map. Returning White.', keyLetter);
            hexCode = '#FFFFFF';
    end
end