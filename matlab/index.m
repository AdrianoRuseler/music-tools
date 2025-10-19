% Example 1: Get the hex code for 5B
color = getColorHex('5B');
% color will be: '#DB9C2A'

% Example 2: Input is not case-sensitive (due to upper(keyLetter))
color2 = getColorHex('3a');
% color2 will be: '#6DCF38'

% Example 3: Invalid input
color3 = getColorHex('XX');
% color3 will be: '#FFFFFF' (and a warning will be displayed)

% To create an image for '5A' with dimensions 200x80 pixels:
generateColoredBoxImage('5A', 200, 80);
% This will create a file named '5A_box.png' in your current MATLAB directory.

% To create an image for '12B' with dimensions 300x120 pixels:
generateColoredBoxImage('5A', 300, 120);
% This will create a file named '12B_box.png'.

generateTrackInfoImage('5A', 140, 7, 'track_info5a.png');
% This will create a PNG image named 'track_info.png' displaying the key '5A',


generateTrackInfoImage('11A', 140, 7, 'track_info11a.png');


addCoverToMP3('my_track.mp3', 'track_info.png');
