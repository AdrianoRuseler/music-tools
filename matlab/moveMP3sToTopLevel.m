function moveMP3sToTopLevel(sourceDir)
    % moveMP3sToTopLevel Moves all .mp3 files from subdirectories to the top level of sourceDir
    % Usage: moveMP3sToTopLevel('C:\Your\Music\Folder')

    if ~isfolder(sourceDir)
        error('Source directory does not exist: %s', sourceDir);
    end

    % Get all .mp3 files recursively
    files = dir(fullfile(sourceDir, '**', '*.mp3'));

    fprintf('Found %d MP3 files in subdirectories.\n', numel(files));

    for k = 1:numel(files)
        srcFile = fullfile(files(k).folder, files(k).name);
        destFile = fullfile(sourceDir, files(k).name);

        % Skip if file is already in top-level sourceDir
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

    fprintf('All MP3 files moved to top-level directory.\n');
end
