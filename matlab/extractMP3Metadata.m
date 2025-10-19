function metadata = extractMP3Metadata(mp3File)
% extractMP3Metadata extracts metadata from an MP3 file using ffprobe
%
% Input:
%   mp3File - string, path to the MP3 file
%
% Output:
%   metadata - struct with fields: title, artist, album, genre, duration

    if ~isfile(mp3File)
        error('MP3 file not found: %s', mp3File);
    end

    % Build ffprobe command to extract metadata in JSON format
    cmd = sprintf('ffprobe -v quiet -print_format json -show_format "%s"', mp3File);
    [status, result] = system(cmd);

    if status ~= 0
        error('ffprobe failed to extract metadata. Ensure ffprobe is installed and in your system path.');
    end

    % Parse JSON result
    jsonData = jsondecode(result);
    formatTags = jsonData.format.tags;

    % Extract fields safely
    metadata.title   = getFieldSafe(formatTags, 'title');
    metadata.artist  = getFieldSafe(formatTags, 'artist');
    metadata.album   = getFieldSafe(formatTags, 'album');
    metadata.genre   = getFieldSafe(formatTags, 'genre');
    metadata.duration = str2double(jsonData.format.duration);
end

function value = getFieldSafe(structure, fieldName)
% Helper to safely extract field from struct
    if isfield(structure, fieldName)
        value = structure.(fieldName);
    else
        value = '';
    end
end
