% Read all songs

% https://claude.ai/chat/adc9a1ab-6f16-497c-93a4-ab9c4cc91599

% Specify the full path and filename for your .db file
dbfile = 'C:\Users\ruseler\AppData\Local\Mixed In Key\Mixed In Key\11.0\MIKStore.db'; 

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

% Get specific columns only
basicInfo = readSongTable(dbfile, ...
    'Columns', {'Tempo', 'OverallEnergy', 'MainKey', 'MainKeyConfidence', 'OverallVolumeRMS1', 'OverallVolumeRMS2', 'OverallVolumeLUFS'});
disp(basicInfo(1, :));



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