function moveAllMP3s(sourceDir, destDir)
    % moveAllMP3s Recursively moves all .mp3 files from sourceDir to destDir
    % Usage: moveAllMP3s('C:\source', 'C:\destination')

    if ~isfolder(sourceDir)
        error('Source directory does not exist: %s', sourceDir);
    end

    if ~isfolder(destDir)
        mkdir(destDir);
    end

    % Get list of all files and folders in sourceDir
    files = dir(fullfile(sourceDir, '**', '*.mp3'));

    fprintf('Found %d MP3 files.\n', numel(files));

    for k = 1:numel(files)
        srcFile = fullfile(files(k).folder, files(k).name);
        destFile = fullfile(destDir, files(k).name);

        % Avoid overwriting existing files
        if exist(destFile, 'file')
            [~, name, ext] = fileparts(files(k).name);
            timestamp = datestr(now, 'yyyymmdd_HHMMSSFFF');
            destFile = fullfile(destDir, sprintf('%s_%s%s', name, timestamp, ext));
        end

        movefile(srcFile, destFile);
        fprintf('Moved: %s -> %s\n', srcFile, destFile);
    end

    fprintf('All MP3 files moved successfully.\n');
end
