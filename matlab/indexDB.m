% Read all songs

% https://claude.ai/chat/adc9a1ab-6f16-497c-93a4-ab9c4cc91599

songData = readSongTable('A:\DJPOOL\TheMashUp.db');

% fieldnames(songData)
% songData = readSongTable('A:\DJPOOL\crack-4-djs\MIKStore.db');
% songData = readSongTable('A:\DJPOOL\All In One Partybreaks And Remixes\MIKStore.db');
DestinationDir = 'G:\DJPOOL\TheMashUp'; % CHANGE THIS to your desired output folder
bpmMin = 120; % Define minimum BPM threshold
bpmMax = 150; % Define maximum BPM threshold

n=height(songData);
for i = 1:n
    filename=songData.File(i);
    [filepath, name, ext] = fileparts(filename);

    % Skip if contains Acapella in the name
    if contains(name, 'Acapella', 'IgnoreCase', true)
        fprintf('  Skipped (%d of %d): %s\n',i,n, name);
        continue; % Skip this iteration if the filename contains 'Acapella'
    end

    % Skip if contains Tools in the name
    if contains(name, 'Tools', 'IgnoreCase', true)
        fprintf('  Skipped (%d of %d): %s\n',i,n, name);
        continue; % Skip this iteration if the filename contains 'Tools'
    end

    songDuration=(songData.FileSize(i)*8)/(songData.Bitrate(i)*1000); % In seconds
    % Skip if songDuration is under 90s
    if songDuration < 90 
        fprintf('  Skipped (%d of %d) Duration (90s): %s\n', i, n, name);
        continue; % Skip this iteration if BPM is out of the defined range
    end

    % get number before .mp3
    tokens = regexp(filename, '(\d+)\.mp3$', 'tokens', 'once');

    if ~isempty(tokens)
        songData.BPM(i) = str2double(tokens{1});
    else
        songData.BPM(i) = round(songData.Tempo(i));
    end

    % Skip if songData.BPM(i) is under bpmmin or over bpmmax
    if songData.BPM(i) < bpmMin || songData.BPM(i) > bpmMax
        fprintf('  Skipped (%d of %d) BPM out of range: %s\n', i, n, name);
        continue; % Skip this iteration if BPM is out of the defined range
    end
    
    Energy = songData.OverallEnergy(i);    

    % Find the lower bound of the 10-BPM range
    % The lower bound will be the BPM number rounded down to the nearest 10.
    % E.g., 103 -> 100, 97 -> 90.
    lowerBound = floor(songData.BPM(i) / 10) * 10;

    % The upper bound is the lower bound plus 10
    upperBound = lowerBound + 10;

    % Create the folder name string (e.g., '100-110')
    folderName = sprintf('%d-%d/%d', lowerBound, upperBound,Energy);
    % 3. Create the destination folder path
    targetDir = fullfile(DestinationDir, folderName);

    % Create the range folder if it doesn't exist
    if ~isfolder(targetDir)
        mkdir(targetDir);
    end
    % 4. Copy the file
    fullTargetPath = fullfile(targetDir, [char(name) char(ext)]);
    fullSourcePath = songData.File(i);
    try
        % The 'f' flag overwrites if the file already exists
        copyfile(fullSourcePath, fullTargetPath, 'f');
        fprintf('  Copied (%d of %d): %s to %s\n',i,n, name, folderName);
    catch ME
        fprintf('  ERROR copying %s: %s\n', fileName, ME.message);
    end

end

%% v02


songData = readSongTable('C:\Users\ruseler\AppData\Local\Mixed In Key\Mixed In Key\11.0\MIKStore.db');
% songData = readSongTable('A:\DJPOOL\All In One Partybreaks And Remixes\MIKStore.db');
DestinationDir = 'A:\DJPOOL\All In One Partybreaks And Remixes\BPM-Sorted2'; % CHANGE THIS to your desired output folder
DestinationDir = 'G:\DJPOOL\TheMashUp';

n=height(songData);
for i = 1:n
    filename=songData.File(i);
    [filepath, name, ext] = fileparts(filename);

    % Skip if contains Acapella in the name
    if contains(name, 'Acapella', 'IgnoreCase', true)
        continue; % Skip this iteration if the filename contains 'Acapella'
    end

    % get number before .mp3
    % tokens = regexp(filename, '(\d+)\.mp3$', 'tokens', 'once');
    % 
    % if ~isempty(tokens)
    %     songData.BPM(i) = str2double(tokens{1});
    % else
    %     songData.BPM(i) = round(songData.Tempo(i));
    % end

    songData.BPM(i) = round(songData.Tempo(i));
    Energy = songData.OverallEnergy(i);


    % Find the lower bound of the 10-BPM range
    % The lower bound will be the BPM number rounded down to the nearest 10.
    % E.g., 103 -> 100, 97 -> 90.
    lowerBound = floor(songData.BPM(i) / 10) * 10;

    % The upper bound is the lower bound plus 10
    upperBound = lowerBound + 10;

    % Create the folder name string (e.g., '100-110')
    folderName = sprintf('%d-%d/%d', lowerBound, upperBound,Energy);
    % 3. Create the destination folder path
    targetDir = fullfile(DestinationDir, folderName);

    % Create the range folder if it doesn't exist
    if ~isfolder(targetDir)
        mkdir(targetDir);
    end
    % 4. Copy the file
    fullTargetPath = fullfile(targetDir, [char(name) char(ext)]);
    fullSourcePath = songData.File(i);
    try
        % The 'f' flag overwrites if the file already exists
        copyfile(fullSourcePath, fullTargetPath, 'f');
        fprintf('  Copied (%d of %d): %s to %s\n',i,n, name, folderName);
    catch ME
        fprintf('  ERROR copying %s: %s\n', fileName, ME.message);
    end

end

%% Loop trough names

n=height(songData);
for i = 1:n
    filename=songData.File(i);
    [filepath, name, ext] = fileparts(filename);

    % info = audioinfo(filename);
    % disp(info.Duration); % Returns duration in seconds

    

    % fprintf('Song Duration: %.2f seconds\n', songDuration);

    songDuration=(songData.FileSize(i)*8)/(songData.Bitrate(i)*1000); % In seconds
    % Skip if songDuration is under 90s
    if songDuration < 90 
        fprintf('  Skipped (%d of %d) Duration (90s): %s\n', i, n, name);
        continue; % Skip this iteration if BPM is out of the defined range
    end

    % % Skip if contains Acapella in the name
    % if contains(name, 'Acapella', 'IgnoreCase', true)
    %     fprintf('  Skipped (%d of %d): %s\n',i,n, name);
    %     continue; % Skip this iteration if the filename contains 'Acapella'
    % end

    % Skip if contains Tools in the name
    % if contains(name, 'Tools', 'IgnoreCase', true)
    %     fprintf('  Skipped (%d of %d): %s\n',i,n, name);
    %     continue; % Skip this iteration if the filename contains 'Tools'
    % end
    % Skip if contains bars in the name
    % if contains(name, ' bar ', 'IgnoreCase', true)
    %     fprintf('  Skipped (%d of %d): %s\n',i,n, name);
    %     continue; % Skip this iteration if the filename contains 'Tools'
    % end
    % 
    % if contains(name, '1-bar', 'IgnoreCase', true)
    %     fprintf('  Skipped (%d of %d): %s\n',i,n, name);
    %     continue; % Skip this iteration if the filename contains 'Tools'
    % end
    % if contains(name, 'bars', 'IgnoreCase', true)
    %     fprintf('  Skipped (%d of %d): %s\n',i,n, name);
    %     continue; % Skip this iteration if the filename contains 'Tools'
    % end

end

%% Specify the full path and filename for your .db file
dbfile = 'C:\Users\ruseler\AppData\Local\Mixed In Key\Mixed In Key\11.0\MIKStore.db';

% Get specific columns only
basicInfo = readSongTable(dbfile, ...
    'Columns', {'File','Tempo', 'OverallEnergy', 'MainKey', 'MainKeyConfidence', 'OverallVolumeRMS1', 'OverallVolumeRMS2', 'OverallVolumeLUFS','Rating'});
disp(basicInfo(1, :));

% (keyStr, tempoVal, energyVal, MainKeyConfidence, OverallVolume, numStars)
for i = 1:2 % height(basicInfo)
    keyStr  = basicInfo.MainKey(i);
    tempoVal = basicInfo.Tempo(i);
    energyVal = basicInfo.OverallEnergy(i);
    MainKeyConfidence = basicInfo.MainKeyConfidence(i);
    OverallVolume.RMS1 = basicInfo.OverallVolumeRMS1(i);
    OverallVolume.RMS2 = basicInfo.OverallVolumeRMS2(i);
    OverallVolume.LUFS = basicInfo.OverallVolumeLUFS(i);
    numStars = 2*basicInfo.Rating(i);
    ArtWorkFile{i} = TrackInfoImage(keyStr, tempoVal ,energyVal,MainKeyConfidence, OverallVolume, numStars);
end


addCoverToMP3(basicInfo.File(i), ArtWorkFile{i})


% OverallVolume.RMS1 = -12.5
% OverallVolume.RMS2 = -11.23
% OverallVolume.LUFS = -9
% ArtWorkFile=TrackInfoImage('1A', 132.87, 5,0.4721,OverallVolume,7);




songs2 = readSongTable(dbfile);

songs = readSongTable(dbfile);
% songs = readSongDatabase(dbfile);
% Error using readSongDatabase (line 99)
% Error reading database: Input #2 expected to be a cell array, was int64 instead.
% Check the data
disp(songs2(1, {'ArtistName', 'SongName', 'Tempo', 'Year'}));

disp(songs2(1, :));
% Filter by tempo and year
fastSongs = readSongTable(dbfile, ...
    'WhereClause', 'Tempo > 120 AND Year >= 2020');

% LastAnalyzedUtc NaT
TimeInfo = readSongTable(dbfile,'Columns', {'LastAnalyzedUtc', 'LastModifiedUtc', 'DateAdded'});

% Get top 50 songs ordered by date
recent = readSongTable(dbfile, ...
    'OrderBy', 'DateAdded DESC', ...
    'Limit', 50);

% Complex query
myFavorites = readSongTable(dbfile, ...
    'WhereClause', 'Rating >= 4 AND Genre = "Rock"', ...
    'OrderBy', 'ArtistName, Album, SongName', ...
    'Limit', 100);


% conn = sqlite(dbfile, 'readonly');
% result = fetch(conn, 'SELECT IFNULL(ArtistName, '''') AS ArtistName, IFNULL(SongName, '''') AS SongName FROM Song LIMIT 5');
% close(conn);
% class(result)
% size(result)


conn = sqlite(dbfile, 'readonly');
result = fetch(conn, 'SELECT DateAdded FROM Song WHERE DateAdded IS NOT NULL LIMIT 5');
result
close(conn);


dates = readSongTable(dbfile, 'Columns', {'LastAnalyzedUtc', 'LastModifiedUtc', 'DateAdded'});
dates(1:5,:)

dates = readSongTable(dbfile, 'Columns', {'DateAdded'});

