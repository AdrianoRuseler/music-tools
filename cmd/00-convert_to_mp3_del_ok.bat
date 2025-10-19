@echo off
REM cd path\to\your\music\folder

for /R %%f in (*.wav *.flac *.aac *.ogg *.aif) do (
    echo Converting %%f to MP3...
    ffmpeg -i "%%f" -codec:a libmp3lame -qscale:a 2 "%%~dpnf.mp3"

    if exist "%%~dpnf.mp3" (
        echo Conversion successful. Deleting original file %%f...
        del "%%f"
    ) else (
        echo Conversion failed for %%f. Original file retained.
    )
)

echo All done!
pause