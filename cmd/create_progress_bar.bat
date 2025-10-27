@echo off
setlocal enabledelayedexpansion

REM Configuration
set "OUTPUT=progress_bar.png"
set WIDTH=600
set HEIGHT=50
set PROGRESS=75
set "BG_COLOR=#2c3e50"
set "BORDER_COLOR=#34495e"

REM Calculate dimensions
set /a PROGRESS_WIDTH=(WIDTH-10)*PROGRESS/100+5
set /a INNER_RIGHT=WIDTH-5
set /a INNER_BOTTOM=HEIGHT-5

echo Creating gradient progress bar with ImageMagick...
echo Progress: %PROGRESS%%%
echo Output: %OUTPUT%
echo Progress width: %PROGRESS_WIDTH%px

REM Create the progress bar
magick -size %WIDTH%x%HEIGHT% xc:"%BG_COLOR%" ^
    ( -size %PROGRESS_WIDTH%x40 gradient:"#667eea-#764ba2" ) ^
    -geometry +5+5 -composite ^
    -strokewidth 2 -stroke "%BORDER_COLOR%" -fill none ^
    -draw "rectangle 5,5 %INNER_RIGHT%,%INNER_BOTTOM%" ^
    "%OUTPUT%"

if %errorlevel% equ 0 (
    echo.
    echo Success! Progress bar created: %OUTPUT%
) else (
    echo.
    echo Error: ImageMagick failed to create the image
    echo Make sure ImageMagick is installed and in your PATH
)

pause
