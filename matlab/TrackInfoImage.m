function imgname=TrackInfoImage(keyStr, tempoVal, energyVal, MainKeyConfidence, OverallVolume, numStars)
% generateTrackInfoImage creates a PNG image showing Key, Tempo, and Energy
% Inputs:
%   keyStr    - string, e.g., '5A'
%   tempoVal  - numeric, e.g., 140
%   energyVal - numeric (1–10), e.g., 7
% MainKeyConfidence - numeric (0-1), e.g., 0.84721

% OverallVolume.RMS1 = -12.5
% OverallVolume.RMS2 = -11.23
% OverallVolume.LUFS = -9

% For debug
%   keyStr= '7A';   - string, e.g., '5A'
%   tempoVal =140; - numeric, e.g., 140
%   energyVal = 7;- numeric (1–10), e.g., 7
% MainKeyConfidence= 0.84721;
%   filename  - string, output PNG filename, e.g., 'track_info.png'
% TrackInfoImage('1A', 132, 5)
% TrackInfoImage('1A', 132, 5,0.84721)

% TrackInfoImage('1A', 132, 5,0.84721,OverallVolume)
% TrackInfoImage('1A', 132, 5,0.4721,OverallVolume,7)

% Verify if the number of input arguments is correct
if nargin < 3
    error('At least three input arguments (keyStr, tempoVal, energyVal) are required.');
end

% Verify if MainKeyConfidence is provided
if nargin < 4
    MainKeyConfidence=1;
end

if nargin < 5
    % MainKeyConfidence=1;
    OverallVolume.RMS1 = 0;
    OverallVolume.RMS2 = 0;
    OverallVolume.LUFS = 0;
end

if nargin < 6
    numStars=0;
end

% Validate inputs
if energyVal < 0 || energyVal > 10
    error('Energy must be between 0 and 10');
end

% Get hex color from key
keyStr = char(keyStr);
hexColor = getColorHex(keyStr);
imgname = ['k' keyStr '_t' num2str(round(tempoVal)) '_e' num2str(energyVal) '.png'];

if energyVal == 0
    energystr = ['-fill "' hexColor '40" ']; % Initialize command string for ImageMagick
else
    energystr = ['-fill "' hexColor '" ']; % Initialize command string for ImageMagick
end
% Draw energy rectangles based on energyVal

for i = 1:10
    if i==energyVal
        energystr = [energystr, sprintf('-draw "rectangle %d,70 %d,90" -fill "%s40"  ' , 120 + (i-1)*15, 130 + (i-1)*15 ,hexColor)];
    else
        energystr = [energystr, sprintf('-draw "rectangle %d,70 %d,90" ', 120 + (i-1)*15, 130 + (i-1)*15)];
    end
end


numCount = sum(isstrprop(keyStr, 'digit'));
if numCount == 2
    keyStrPos ='+10+25';
else
    keyStrPos ='+20+25';
end


% for i = 1:20
%     disp(vuMeterColor(i, 20, 0.8))  % 80% opacity
% end
% OverallVolume.RMS1 = -12.5
% OverallVolume.RMS2 = -11.23
% OverallVolume.LUFS = -9
energyVal1= ceil(20+OverallVolume.RMS1);
energyVal2 = ceil(20 + OverallVolume.RMS2);
energyVals = ceil(20 + OverallVolume.LUFS);
energystr1 = ''; % Initialize command string for ImageMagick
for i = 1:20
    if i>energyVal1
        energystr1 = [energystr1, sprintf('-fill "%s" -draw "rectangle %d,120 %d,150" ', vuMeterColor(i, 20, 0.2), 20 + (i-1)*10, 25 + (i-1)*10)];
    else
        energystr1 = [energystr1, sprintf('-fill "%s" -draw "rectangle %d,120 %d,150" ', vuMeterColor(i, 20, 1), 20 + (i-1)*10, 25 + (i-1)*10)];
    end
end

energystr2 = ''; % Initialize command string for ImageMagick
for i = 1:20
    if i>energyVal2
        energystr2 = [energystr2, sprintf('-fill "%s" -draw "rectangle %d,170 %d,200" ', vuMeterColor(i, 20, 0.2), 20 + (i-1)*10, 25 + (i-1)*10)];
    else
        energystr2 = [energystr2, sprintf('-fill "%s" -draw "rectangle %d,170 %d,200" ', vuMeterColor(i, 20, 1), 20 + (i-1)*10, 25 + (i-1)*10)];
    end
end

energystr3 = ''; % Initialize command string for ImageMagick
for i = 1:20
    if i>energyVals
        energystr3 = [energystr3, sprintf('-fill "%s" -draw "rectangle %d,220 %d,250" ', vuMeterColor(i, 20, 0.2), 20 + (i-1)*10, 25 + (i-1)*10)];
    else
        energystr3 = [energystr3, sprintf('-fill "%s" -draw "rectangle %d,220 %d,250" ', vuMeterColor(i, 20, 1), 20 + (i-1)*10, 25 + (i-1)*10)];
    end
end

% starstr=[ '-fill gold ' ...
%     '-draw "polygon 15,260 18,13 27,13 20,18 23,27 15,22 7,27 10,18 3,13 12,13" ' ...
%     '-draw "polygon 75,260 78,13 87,13 80,18 83,27 75,22 67,27 70,18 63,13 72,13" ' ...
%     '-draw "polygon 135,260 138,13 147,13 140,18 143,27 135,22 127,27 130,18 123,13 132,13" ' ...
%     '-fill gray -draw "polygon 195,260 198,13 207,13 200,18 203,27 195,22 187,27 190,18 183,13 192,13" ' ...
%     '-draw "polygon 255,260 258,13 267,13 260,18 263,27 255,22 247,27 250,18 243,13 252,13" '];

cmd=['magick -size 300x300 xc:white ' ...
    '-fill "' hexColor '40" -draw "roundrectangle 5,5 100,100 10,10" ' ...
    '-fill "' hexColor '" -draw "roundrectangle 5,5 ' num2str(MainKeyConfidence*100, '%d') ',100 10,10" ' ...
    '-gravity northwest -pointsize 48 -fill black -font Arial ' ...
    '-annotate ' keyStrPos ' "' keyStr '" ' ...
    '-gravity northwest -pointsize 52 -annotate +110+10 "' num2str(round(tempoVal)) '" ' ...
    '-gravity northwest -pointsize 52 -annotate +235+10 "' num2str(energyVal) '" ' ...
    '-gravity northwest -pointsize 22 -annotate +2+115 "1" ' ...
    '-gravity northwest -pointsize 22 -annotate +2+165 "2" ' ...
    '-gravity northwest -pointsize 22 -annotate +2+215 "S" ' ...
    '-gravity northwest -pointsize 34 -annotate +230+115 "' num2str(abs(OverallVolume.RMS1), '%.1f') '" ' ...
    '-gravity northwest -pointsize 34 -annotate +230+165 "' num2str(abs(OverallVolume.RMS2), '%.1f') '" ' ...
    '-gravity northwest -pointsize 34 -annotate +230+215 "' num2str(abs(OverallVolume.LUFS), '%.1f') '" ' ...
    energystr energystr1 energystr2 energystr3 generateStarDrawCommands(numStars, 30, 265) imgname ];

[status, result] = system(cmd);

% Execute the command to create the image
if status ~= 0
    error('Image creation failed: %s', result);
end

% Display the generated image
% imshow(imgname);
imshow(imgname);

% 
% '-fill blue -draw "rectangle 100,70 110,90" ' ...
%     '-draw "rectangle 115,70 125,90" ' ...
%     '-draw "rectangle 130,70 140,90" ' ...
%     '-draw "rectangle 145,70 155,90" ' ...
%     '-draw "rectangle 160,70 170,90" ' ...
%     '-draw "rectangle 175,70 185,90" ' ...
%     '-fill gray -draw "rectangle 190,70 200,90" ' ...
%     '-draw "rectangle 205,70 215,90" ' ...
%     '-draw "rectangle 220,70 230,90" ' ...
%     '-draw "rectangle 235,70 245,90" ' ...
    % '-fill gray -draw "roundrectangle 5,100 100,80 10,10" ' ...

    % if energyVal == 0
    %     energystr = ''; % Initialize command string for ImageMagick
    % else
    %     energystr = ''; % Initialize command string for ImageMagick
    % end
    % % Draw energy rectangles based on energyVal

    energystr = ''; % Initialize command string for ImageMagick
    for i = 1:20
        if i>=energyVal
            energystr = [energystr, sprintf('-fill gray -draw "rectangle %d,200 %d,230" -fill gray ', 120 + (i-1)*15, 130 + (i-1)*15)];
        else
            energystr = [energystr, sprintf('-draw "rectangle %d,200 %d,230" ', 120 + (i-1)*15, 130 + (i-1)*15)];
        end
    end
