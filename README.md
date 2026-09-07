# music-tools

## Download the music files

- [DJ Pool Records](https://djpoolrecords.com/)

## Unzip Files

```bash
7z x *.zip
```

```cmd
for %f in (*.zip) do tar --strip-components=1 -xf "%f"
```

## Moves all .mp3 and .m4a files from subdirectories to the top level of sourceDir

```matlab
moveAudioToTopLevelAndClean('TopFolder')
```

## Mixed in Key

- [Mixed In Key](https://mixedinkey.com/)

Backup MIKStore.db file and delete
Open folder `%AppData%\Local\Mixed In Key\Mixed In Key\11.0`

## Read DB and sort files

```matlab

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
```

## Color Wheel Hex Codes

| Key Letter | Approximate Background Color Hex Code |
| :--------: | :-----------------------------------: |
|   **1A**   |      `#25D5E0` (Light Cyan/Teal)      |
|   **1B**   |         `#15C6D1` (Cyan/Teal)         |
|   **2A**   |       `#4ED94E` (Bright Green)        |
|   **2B**   |           `#38CB3A` (Green)           |
|   **3A**   |        `#6DCF38` (Lime Green)         |
|   **3B**   |       `#55C31D` (Strong Green)        |
|   **4A**   |       `#E0DD39` (Yellow-Green)        |
|   **4B**   |    `#D8D321` (Vivid Yellow-Green)     |
|   **5A**   |    `#E2A941` (Deep Yellow/Orange)     |
|   **5B**   |       `#DB9C2A` (Burnt Orange)        |
|   **6A**   |    `#E17565` (Light Coral/Salmon)     |
|   **6B**   |       `#DE6055` (Coral/Salmon)        |
|   **7A**   |     `#DD5590` (Fuschia/Deep Pink)     |
|   **7B**   |        `#D63F7F` (Vivid Pink)         |
|   **8A**   |   `#C857BE` (Lavender/Light Violet)   |
|   **8B**   |   `#BD44B2` (Deep Lavender/Violet)    |
|   **9A**   |    `#9E67D1` (Light Indigo/Purple)    |
|   **9B**   |       `#8E52C6` (Indigo/Purple)       |
|  **10A**   |        `#6692E1` (Light Blue)         |
|  **10B**   |        `#5081D9` (Medium Blue)        |
|  **11A**   |         `#4DBAE3` (Sky Blue)          |
|  **11B**   |         `#34ACC7` (Cyan Blue)         |
|  **12A**   |        `#38D4E5` (Bright Cyan)        |
|  **12B**   |        `#20C9D1` (Strong Cyan)        |
