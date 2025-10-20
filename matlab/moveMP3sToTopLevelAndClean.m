function moveMP3sToTopLevelAndClean(sourceDir)
    % moveMP3sToTopLevelAndClean
    % Moves all .mp3 files from subdirectories to the top level of sourceDir
    % and removes any empty folders afterward.
    %
    % Usage: moveMP3sToTopLevelAndClean('C:\Your\Music\Folder')

    if ~isfolder(sourceDir)
        error('Source directory does not exist: %s', sourceDir);
    end

    % Get all .mp3 files recursively
    files = dir(fullfile(sourceDir, '**', '*.mp3'));
    fprintf('Found %d MP3 files in subdirectories.\n', numel(files));

    for k = 1:numel(files)
        srcFile = fullfile(files(k).folder, files(k).name);
        destFile = fullfile(sourceDir, files(k).name);

        % Skip if already in top-level
        if strcmp(files(k).folder, sourceDir)
            continue;
        end

        % Avoid overwriting existing files
        if exist(destFile, 'file')
            [~, name, ext] = fileparts(files(k).name);
            timestamp = datestr(now, 'yyyymmdd_HHMMSSFFF');
            destFile = fullfile(sourceDir, sprintf('%s_%s%s', name, timestamp, ext));
        end

        movefile(srcFile, destFile);
        fprintf('Moved: %s -> %s\n', srcFile, destFile);
    end

    % Remove empty folders
    removeEmptyFolders(sourceDir);

    fprintf('All MP3 files moved and empty folders removed.\n');
end

function removeEmptyFolders(folder)
    % Recursively remove empty folders
    items = dir(folder);
    for i = 1:length(items)
        item = items(i);
        if item.isdir && ~strcmp(item.name, '.') && ~strcmp(item.name, '..')
            subfolder = fullfile(folder, item.name);
            removeEmptyFolders(subfolder);  % Recurse into subfolder

            % Check if now empty
            if isempty(dir(fullfile(subfolder, '*')))
                rmdir(subfolder);
                fprintf('Removed empty folder: %s\n', subfolder);
            end
        end
    end
end
