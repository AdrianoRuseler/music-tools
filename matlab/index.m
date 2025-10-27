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


generateTrackInfoImage('11A', 140, 7, 'track_info11aX.png');
generateTrackInfoImage('11A', 140, 7, 'track_info11a.jpg');

%% Not tested
addCoverToMP3('my_track.mp3', 'track_info.png');

[info,jsonData] = extractMP3Metadata('A:\DJPOOL\All In One Partybreaks And Remixes\Sep 2020\$Uicideboy$ - Fuck Your Culture (Dj Friendly Short Edit) (Dirty).mp3');
disp(info);

generateTrackInfoImage(info.tkey, info.tbpm, info.energylevel, 'track_info_test.png');

addCoverToMP3('A:\DJPOOL\All In One Partybreaks And Remixes\Sep 2020\$Uicideboy$ - Fuck Your Culture (Dj Friendly Short Edit) (Dirty).mp3', 'track_info_test.png');
%% Move files
moveAllMP3s('C:\Users\YourName\Music', 'C:\Users\YourName\MP3Archive');

moveAudioToTopLevelAndClean('A:\DJPOOL\crack-4-djs')


moveAudioToTopLevelAndClean('A:\DJPOOL\All In One Partybreaks And Remixes\Sep 2020')


moveAudioToTopLevelAndClean('E:\TMP\Techno, Tech & Deep House Pack\Tech House')


%% DB 

% Specify the full path and filename for your .db file
dbfile = 'C:\Users\ruseler\AppData\Local\Mixed In Key\Mixed In Key\11.0\MIKStore.db'; 

% Create the SQLite connection object
conn = sqlite(dbfile,'readonly');

% Example SQL query to select certain columns and filter rows
sqlQuery = 'SELECT name FROM sqlite_master WHERE type=''table'';';

% Execute the query and fetch the results
results = fetch(conn, sqlQuery);

sqlQuery = ['SELECT ' ...
  'Id, File, ArtistName, SongName, Comment, Tempo, OverallVolume, OverallEnergy, EnergySegmentsCount, ' ...
  'StandardPitch, KeyResultSummary, ClippedPeaksCount, Genre, Album, Year, ' ...
  'MainKey, MainKeyConfidence, SecondKey, SecondKeyConfidence, OverallVolumeRMS1, OverallVolumeRMS2, OverallVolumeLUFS, ' ...
  'FileType, FileSize, Bitrate, SampleRate, Rating FROM Song'];

sqlQuery = ['SELECT ' ...
  'Id, File, ArtistName, SongName, Comment, Tempo, OverallVolume, OverallEnergy, EnergySegmentsCount, ' ...
  'StandardPitch, KeyResultSummary, ClippedPeaksCount, Genre, Album, ' ...
  'MainKey, MainKeyConfidence, SecondKey, SecondKeyConfidence, OverallVolumeRMS1, OverallVolumeRMS2, OverallVolumeLUFS, ' ...
  'FileType, FileSize, Bitrate, SampleRate, Rating FROM Song'];

% 3. Execute the fixed query
data = fetch(conn, sqlQuery);

% Close the SQLite connection
close(conn);



% TrackInfoImage('1A', 132, 5,0.84721,OverallVolume)
% TrackInfoImage('1A', 132, 5,0.4721,OverallVolume,7)


% 
% CREATE TABLE [Song] (
%   [Id] TEXT PRIMARY KEY NOT NULL,
%   [File] TEXT NULL,
%   [FilePathHash] TEXT NULL,
%   [ArtistName] TEXT NULL,
%   [SongName] TEXT NULL,
%   [Comment] TEXT NULL,
%   [Tempo] REAL NULL,
%   [OverallVolume] REAL NULL,
%   [OverallEnergy] INTEGER NULL,
%   [EnergySegmentsCount] INTEGER NULL,
%   [StandardPitch] REAL NULL,
%   [KeyResultSummary] TEXT NULL,
%   [DateAdded] TEXT NULL,
%   [ClippedPeaksCount] INTEGER NULL,
%   [Artwork] BLOB NULL,
%   [LastAnalyzedUtc] TEXT NULL,
%   [Genre] TEXT NULL,
%   [Album] TEXT NULL,
%   [Grouping] TEXT NULL,
%   [Year] INTEGER NULL,
%   [MainKey] TEXT NULL,
%   [MainKeyConfidence] REAL NULL,
%   [SecondKey] TEXT NULL,
%   [SecondKeyConfidence] REAL NULL,
%   [IsAnalyzed] INTEGER NULL,
%   [HasPNTag] INTEGER NULL,
%   [PNTagIsProcessed] INTEGER NULL,
%   [PNTagAppliedClipRepair] INTEGER NULL,
%   [PNTagVolumeAnalysisVersion] INTEGER NULL,
%   [PNTagVolumeUnits] TEXT NULL,
%   [PNTagOutputVolume] REAL NULL,
%   [LastModifiedUtc] TEXT NULL,
%   [OverallVolumeRMS1] REAL NULL,
%   [OverallVolumeRMS2] REAL NULL,
%   [OverallVolumeLUFS] REAL NULL,
%   [DiskIsRemovable] INTEGER NULL,
%   [DiskLabel] TEXT NULL,
%   [DiskSerialNumber] TEXT NULL,
%   [Label] TEXT NULL,
%   [Remixer] TEXT NULL,
%   [Composer] TEXT NULL,
%   [FileType] TEXT NULL,
%   [FileSize] BIGINT NULL,
%   [Bitrate] INTEGER NULL,
%   [SampleRate] INTEGER NULL,
%   [Rating] INTEGER NULL
% ) WITHOUT ROWID