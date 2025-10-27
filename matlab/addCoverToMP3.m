function addCoverToMP3(mp3File, coverImage)
% addCoverToMP3 embeds a PNG image as cover art into an MP3 file using FFmpeg
%
% Inputs:
%   mp3File    - string, path to the MP3 file (e.g., 'song.mp3')
%   coverImage - string, path to the PNG image (e.g., 'track_info.png')
%  mp3File = basicInfo.File(i)
% coverImage = ArtWorkFile{i}
% Output:
%   Creates a new MP3 file with embedded cover art named '[original]_with_cover.mp3'
mp3File = char(mp3File);
coverImage = char(coverImage);

% Validate inputs
if ~isfile(mp3File)
    error('MP3 file not found: %s', mp3File);
end
if ~isfile(coverImage)
    error('Cover image not found: %s', coverImage);
end

% Generate output filename
[folder, name, ext] = fileparts(mp3File);
outputFile = fullfile(folder, [name '_with_cover' ext]);

% Build FFmpeg command OK!
cmd = sprintf('ffmpeg -i "%s" -i "%s" -map 0:a -map 1:v -c copy -id3v2_version 3 "%s"', mp3File, coverImage, outputFile);
% cmd = sprintf('ffmpeg -y -i "%s" -i "%s" -map 0 -map 1 -c copy -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" "%s"', ...
%               mp3File, coverImage, outputFile);

% Execute command
status = system(cmd);

if status == 0
    fprintf('✅ Cover art added successfully: %s\n', outputFile);
else
    error('❌ FFmpeg failed to add cover art. Make sure FFmpeg is installed and accessible.');
end
end
