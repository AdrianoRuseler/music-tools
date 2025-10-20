function moveAudioToTopLevelAndClean(sourceDir)
    % moveAudioToTopLevelAndClean
    % Moves all .mp3 and .m4a files from subdirectories to the top level of sourceDir
    % and removes any empty folders afterward.
    %
    % Usage: moveAudioToTopLevelAndClean('C:\Your\Music\Folder')

    if ~isfolder(sourceDir)
        error('Source directory does not exist: %s', sourceDir);
    end

    % Get all .mp3 and .m4a files recursively
    mp3Files = dir(fullfile(sourceDir, '**', '*.mp3'));
    m4aFiles = dir(fullfile(sourceDir, '**', '*.m4a'));
    files = [mp3Files; m4aFiles];

    fprintf('Found %d audio files in subdirectories.\n', numel(files));

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
    removeEmptyFoldersRecursive(sourceDir);

    fprintf('All audio files moved and empty folders removed.\n');
end

function removeEmptyFoldersRecursive(folder)
    % Recursively remove empty folders, starting from the deepest level
    subfolders = dir(folder);
    for i = 1:length(subfolders)
        item = subfolders(i);
        if item.isdir && ~strcmp(item.name, '.') && ~strcmp(item.name, '..')
            subfolderPath = fullfile(folder, item.name);
            removeEmptyFoldersRecursive(subfolderPath);  % Recurse first

            % Check if folder is now empty
            contents = dir(subfolderPath);
            if all([contents.isdir]) && numel(contents) <= 2
                try
                    rmdir(subfolderPath);
                    fprintf('Removed empty folder: %s\n', subfolderPath);
                catch ME
                    fprintf('Could not remove folder: %s (%s)\n', subfolderPath, ME.message);
                end
            end
        end
    end
end
