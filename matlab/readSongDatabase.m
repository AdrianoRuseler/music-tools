function songData = readSongDatabase(dbPath, varargin)
% READSONGDATABASE Read song data from SQLite database
%
% Syntax:
%   songData = readSongDatabase(dbPath)
%   songData = readSongDatabase(dbPath, Name, Value)
%
% Inputs:
%   dbPath - Path to the SQLite database file
%
% Optional Name-Value Pairs:
%   'WhereClause' - SQL WHERE clause (without 'WHERE' keyword)
%                   Example: 'Tempo > 120 AND Year = 2020'
%   'Columns'     - Cell array of column names to retrieve
%                   Default: all columns
%   'OrderBy'     - SQL ORDER BY clause (without 'ORDER BY' keyword)
%                   Example: 'ArtistName ASC, SongName ASC'
%   'Limit'       - Maximum number of rows to return
%
% Output:
%   songData - Table containing the requested song data
%
% Examples:
%   % Read all songs
%   songs = readSongDatabase('music.db');
%
%   % Read songs with tempo > 120 BPM
%   fastSongs = readSongDatabase('music.db', 'WhereClause', 'Tempo > 120');
%
%   % Read specific columns, ordered by artist
%   songs = readSongDatabase('music.db', ...
%       'Columns', {'ArtistName', 'SongName', 'Tempo'}, ...
%       'OrderBy', 'ArtistName ASC');

    % Parse input arguments
    p = inputParser;
    addRequired(p, 'dbPath', @(x) ischar(x) || isstring(x));
    addParameter(p, 'WhereClause', '', @(x) ischar(x) || isstring(x));
    addParameter(p, 'Columns', {}, @iscell);
    addParameter(p, 'OrderBy', '', @(x) ischar(x) || isstring(x));
    addParameter(p, 'Limit', [], @(x) isnumeric(x) && isscalar(x) && x > 0);
    parse(p, dbPath, varargin{:});
    
    % Validate database file exists
    if ~isfile(p.Results.dbPath)
        error('Database file not found: %s', p.Results.dbPath);
    end
    
    % Define all columns with their types
    columns = getColumnDefinitions();
    
    % Determine which columns to retrieve
    if isempty(p.Results.Columns)
        selectedColumns = columns.keys();
    else
        selectedColumns = p.Results.Columns;
    end
    
    % Build SQL query with proper NULL handling using IFNULL
    sqlQuery = buildQueryWithNullHandling(selectedColumns, columns, ...
        p.Results.WhereClause, p.Results.OrderBy, p.Results.Limit);
    
    % Connect to database and execute query
    try
        conn = sqlite(p.Results.dbPath, 'readonly');
        cleanupObj = onCleanup(@() close(conn));
        
        % Get count of rows first
        countQuery = 'SELECT COUNT(*) FROM Song';
        if ~isempty(p.Results.WhereClause)
            countQuery = sprintf('%s WHERE %s', countQuery, p.Results.WhereClause);
        end
        rowCountResult = fetch(conn, countQuery);
        if iscell(rowCountResult)
            rowCount = rowCountResult{1};
        elseif istable(rowCountResult)
            rowCount = rowCountResult{1,1};
        else
            rowCount = rowCountResult(1);
        end
        
        % Apply limit if specified
        if ~isempty(p.Results.Limit)
            rowCount = min(rowCount, p.Results.Limit);
        end
        
        if rowCount == 0
            % Return empty table with correct column names
            songData = array2table(zeros(0, length(selectedColumns)), ...
                'VariableNames', selectedColumns);
            return;
        end
        
        % Initialize table
        songData = table();
        
        % Fetch each column separately to avoid NULL issues
        for i = 1:length(selectedColumns)
            colName = selectedColumns{i};
            colType = columns(colName);
            
            % Build query for this column
            colQuery = buildSingleColumnQuery(colName, colType, ...
                p.Results.WhereClause, p.Results.OrderBy, p.Results.Limit);
            
            % Fetch column data
            colData = fetch(conn, colQuery);
            
            % Handle if result is a table (extract the column)
            if istable(colData)
                % Extract first column as array
                colData = colData{:,1};
            end
            
            % Ensure colData is a column vector
            if isvector(colData) && size(colData, 2) > 1
                colData = colData';
            end
            
            % Process based on type
            switch colType
                case 'TEXT'
                    % Text columns - ensure cell array of strings
                    if isstring(colData)
                        colData = cellstr(colData);
                    elseif ischar(colData)
                        colData = {colData};
                    elseif ~iscell(colData)
                        colData = arrayfun(@char, colData, 'UniformOutput', false);
                    end
                    songData.(colName) = colData;
                    
                case 'REAL'
                    % Numeric columns
                    if iscell(colData)
                        colData = cell2mat(colData);
                    end
                    if ~isnumeric(colData)
                        colData = double(colData);
                    end
                    colData(colData == -999999.999) = NaN;
                    songData.(colName) = colData;
                    
                case {'INTEGER', 'BIGINT'}
                    % Integer columns
                    if iscell(colData)
                        colData = cell2mat(colData);
                    end
                    if ~isnumeric(colData)
                        colData = double(colData);
                    end
                    colData(colData == -999999) = 0;
                    songData.(colName) = colData;
                    
                case 'BLOB'
                    % BLOB columns - keep as cell array
                    if isstring(colData)
                        colData = cellstr(colData);
                    elseif ischar(colData)
                        colData = {colData};
                    elseif ~iscell(colData)
                        colData = num2cell(colData);
                    end
                    songData.(colName) = colData;
            end
        end
        
        % Post-process data types (datetime conversion, booleans, etc.)
        songData = postProcessData(songData, columns);
        
    catch ME
        error('Error reading database: %s', ME.message);
    end
end

function columns = getColumnDefinitions()
% Define column names and their data types
    columns = containers.Map();
    
    % Text columns
    textCols = {'Id', 'File', 'FilePathHash', 'ArtistName', 'SongName', ...
                'Comment', 'KeyResultSummary', 'DateAdded', 'Genre', ...
                'Album', 'Grouping', 'MainKey', 'SecondKey', ...
                'PNTagVolumeUnits', 'LastModifiedUtc', 'LastAnalyzedUtc', ...
                'DiskLabel', 'DiskSerialNumber', 'Label', 'Remixer', ...
                'Composer', 'FileType'};
    for i = 1:length(textCols)
        columns(textCols{i}) = 'TEXT';
    end
    
    % Real (floating point) columns
    realCols = {'Tempo', 'OverallVolume', 'StandardPitch', ...
                'MainKeyConfidence', 'SecondKeyConfidence', ...
                'PNTagOutputVolume', 'OverallVolumeRMS1', ...
                'OverallVolumeRMS2', 'OverallVolumeLUFS'};
    for i = 1:length(realCols)
        columns(realCols{i}) = 'REAL';
    end
    
    % Integer columns
    intCols = {'OverallEnergy', 'EnergySegmentsCount', 'ClippedPeaksCount', ...
               'Year', 'IsAnalyzed', 'HasPNTag', 'PNTagIsProcessed', ...
               'PNTagAppliedClipRepair', 'PNTagVolumeAnalysisVersion', ...
               'DiskIsRemovable', 'Bitrate', 'SampleRate', 'Rating'};
    for i = 1:length(intCols)
        columns(intCols{i}) = 'INTEGER';
    end
    
    % BigInt column
    columns('FileSize') = 'BIGINT';
    
    % Blob column
    columns('Artwork') = 'BLOB';
end

function sqlQuery = buildQueryWithNullHandling(selectedColumns, columns, ...
                                                whereClause, orderBy, limitVal)
% Build SQL query using IFNULL to replace NULLs with magic values
    
    selectParts = cell(1, length(selectedColumns));
    
    for i = 1:length(selectedColumns)
        colName = selectedColumns{i};
        colType = columns(colName);
        
        % Use IFNULL to replace NULL with a magic value we can detect
        switch colType
            case 'TEXT'
                % Empty string for text
                selectParts{i} = sprintf('IFNULL(%s, '''') AS %s', ...
                    colName, colName);
            case 'REAL'
                % Use -999999.999 as magic value for NULL floats
                selectParts{i} = sprintf('IFNULL(%s, -999999.999) AS %s', ...
                    colName, colName);
            case {'INTEGER', 'BIGINT'}
                % Use -999999 as magic value for NULL integers
                selectParts{i} = sprintf('IFNULL(%s, -999999) AS %s', ...
                    colName, colName);
            case 'BLOB'
                % For BLOBs, convert to hex string if not null, else empty string
                selectParts{i} = sprintf('IFNULL(hex(%s), '''') AS %s', ...
                    colName, colName);
        end
    end
    
    sqlQuery = sprintf('SELECT %s FROM Song', strjoin(selectParts, ', '));
    
    if ~isempty(whereClause)
        sqlQuery = sprintf('%s WHERE %s', sqlQuery, whereClause);
    end
    
    if ~isempty(orderBy)
        sqlQuery = sprintf('%s ORDER BY %s', sqlQuery, orderBy);
    end
    
    if ~isempty(limitVal)
        sqlQuery = sprintf('%s LIMIT %d', sqlQuery, limitVal);
    end
end

function sqlQuery = buildSingleColumnQuery(colName, colType, whereClause, orderBy, limitVal)
% Build SQL query for a single column
    
    switch colType
        case 'TEXT'
            selectPart = sprintf('IFNULL(%s, '''')', colName);
        case 'REAL'
            selectPart = sprintf('IFNULL(%s, -999999.999)', colName);
        case {'INTEGER', 'BIGINT'}
            selectPart = sprintf('IFNULL(%s, -999999)', colName);
        case 'BLOB'
            selectPart = sprintf('IFNULL(hex(%s), '''')', colName);
    end
    
    sqlQuery = sprintf('SELECT %s FROM Song', selectPart);
    
    if ~isempty(whereClause)
        sqlQuery = sprintf('%s WHERE %s', sqlQuery, whereClause);
    end
    
    if ~isempty(orderBy)
        sqlQuery = sprintf('%s ORDER BY %s', sqlQuery, orderBy);
    end
    
    if ~isempty(limitVal)
        sqlQuery = sprintf('%s LIMIT %d', sqlQuery, limitVal);
    end
end

function data = postProcessData(data, columns)
% Post-process the retrieved data to convert to appropriate MATLAB types
    
    if isempty(data)
        return;
    end
    
    varNames = data.Properties.VariableNames;
    
    for i = 1:length(varNames)
        colName = varNames{i};
        
        if ~isKey(columns, colName)
            continue;
        end
        
        colType = columns(colName);
        
        try
            switch colType
                case 'INTEGER'
                    % Convert boolean columns to logical
                    if ismember(colName, {'IsAnalyzed', 'HasPNTag', ...
                            'PNTagIsProcessed', 'PNTagAppliedClipRepair', ...
                            'DiskIsRemovable'})
                        % Ensure it's numeric first
                        if ~isnumeric(data.(colName))
                            if iscell(data.(colName))
                                data.(colName) = cell2mat(data.(colName));
                            end
                        end
                        % Replace magic value with 0, then convert to logical
                        data.(colName)(data.(colName) == -999999) = 0;
                        data.(colName) = logical(data.(colName));
                    end
                    
                case 'TEXT'
                    % Convert datetime columns
                    if ismember(colName, {'DateAdded', 'LastAnalyzedUtc', ...
                            'LastModifiedUtc'})
                        if iscell(data.(colName))
                            dates = NaT(size(data.(colName)));
                            for j = 1:length(data.(colName))
                                if ~isempty(data.(colName){j}) && ischar(data.(colName){j})
                                    try
                                        dates(j) = datetime(data.(colName){j}, ...
                                            'InputFormat', 'yyyy-MM-dd HH:mm:ss', ...
                                            'TimeZone', 'UTC');
                                    catch
                                        % Leave as NaT if conversion fails
                                    end
                                end
                            end
                            data.(colName) = dates;
                        end
                    end
                    
                case 'BLOB'
                    % Convert hex strings back to binary
                    if iscell(data.(colName))
                        blobs = cell(size(data.(colName)));
                        for j = 1:length(data.(colName))
                            if ~isempty(data.(colName){j}) && ischar(data.(colName){j})
                                try
                                    hexStr = data.(colName){j};
                                    blobs{j} = uint8(hex2dec(reshape(hexStr, 2, [])'));
                                catch
                                    blobs{j} = [];
                                end
                            else
                                blobs{j} = [];
                            end
                        end
                        data.(colName) = blobs;
                    end
            end
        catch ME
            warning('Error processing column %s: %s', colName, ME.message);
        end
    end
end

function val = convertToDouble(x)
    % Magic value is -999999.999
    if isempty(x)
        val = NaN;
    elseif isnumeric(x)
        if x == -999999.999
            val = NaN;
        else
            val = double(x);
        end
    else
        val = NaN;
    end
end

function val = convertToInt(x)
    % Magic value is -999999
    if isempty(x)
        val = int32(0);
    elseif isnumeric(x)
        if x == -999999
            val = int32(0);
        else
            val = int32(x);
        end
    else
        val = int32(0);
    end
end

function val = convertToInt64(x)
    % Magic value is -999999
    if isempty(x)
        val = int64(0);
    elseif isnumeric(x)
        if x == -999999
            val = int64(0);
        else
            val = int64(x);
        end
    else
        val = int64(0);
    end
end

function val = convertToString(x)
    if isempty(x)
        val = '';
    else
        val = char(x);
    end
end
