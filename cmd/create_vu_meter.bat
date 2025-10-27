@echo off
setlocal enabledelayedexpansion

REM Configuration
set "OUTPUT=vu_meter.png"
set WIDTH=600
set HEIGHT=50
set PROGRESS=75
set "BG_COLOR=#1a1a1a"
set "BORDER_COLOR=#333333"

REM Calculate dimensions
set /a PROGRESS_WIDTH=(WIDTH-10)*PROGRESS/100+5
set /a INNER_RIGHT=WIDTH-5
set /a INNER_BOTTOM=HEIGHT-5

REM Calculate color zones (Green: 0-70%, Yellow: 70-90%, Red: 90-100%)
set /a GREEN_END=(WIDTH-10)*70/100+5
set /a YELLOW_END=(WIDTH-10)*90/100+5

echo Creating VU meter style progress bar...
echo Level: %PROGRESS%%%
echo Output: %OUTPUT%
echo Progress width: %PROGRESS_WIDTH%px

REM Create base with gradient zones
magick -size %WIDTH%x%HEIGHT% xc:"%BG_COLOR%" ^
    ( -size %GREEN_END%x40 gradient:"#00ff00-#7fff00" ) -geometry +5+5 -composite ^
    ( -size %YELLOW_END%x40 gradient:"#7fff00-#ffff00-#ffa500" ) -geometry +5+5 -composite ^
    ( -size %WIDTH%x40 gradient:"#ffa500-#ff0000-#cc0000" ) -geometry +5+5 -composite ^
    ( +clone -fill black -colorize 100%% -fill white -draw "rectangle 5,5 %PROGRESS_WIDTH%,45" -alpha off ) ^
    -compose copyopacity -composite ^
    -strokewidth 2 -stroke "%BORDER_COLOR%" -fill none ^
    -draw "rectangle 5,5 %INNER_RIGHT%,%INNER_BOTTOM%" ^
    "%OUTPUT%"

if %errorlevel% equ 0 (
    echo.
    echo Success! VU meter created: %OUTPUT%
    echo Green zone: 0-70%%
    echo Yellow zone: 70-90%%
    echo Red zone: 90-100%%
) else (
    echo.
    echo Error: ImageMagick failed to create the image
    echo Make sure ImageMagick is installed and in your PATH
)

pause
