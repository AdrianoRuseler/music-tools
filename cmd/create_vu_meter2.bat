@echo off
setlocal enabledelayedexpansion

echo Creating VU Meter Animation with ImageMagick...
echo.

REM Create output directory
if not exist "vu_meter" mkdir vu_meter

REM VU Meter parameters
set WIDTH=600
set HEIGHT=300
set FRAMES=60

REM Generate frames
for /L %%i in (0,1,%FRAMES%) do (
    set /a FRAME=%%i
    set /a LEVEL=!FRAME!*100/%FRAMES%
    
    REM Calculate bar height (0-200 pixels)
    set /a BAR_HEIGHT=!LEVEL!*2
    set /a BAR_Y=250-!BAR_HEIGHT!
    
    REM Determine color based on level
    if !LEVEL! LSS 60 (
        set COLOR=green
    ) else if !LEVEL! LSS 85 (
        set COLOR=yellow
    ) else (
        set COLOR=red
    )
    
    echo Generating frame !FRAME! / %FRAMES% - Level: !LEVEL!%%
    
    REM Create frame with VU meter
    magick -size %WIDTH%x%HEIGHT% xc:black ^
        -fill gray20 -draw "rectangle 50,50 550,250" ^
        -fill !COLOR! -draw "rectangle 60,!BAR_Y! 540,240" ^
        -fill white -pointsize 20 -gravity North ^
        -annotate +0+10 "VU METER" ^
        -fill white -pointsize 30 -gravity Center ^
        -annotate +0+80 "!LEVEL!%%" ^
        -fill gray50 -draw "line 60,150 540,150" ^
        -fill white -pointsize 12 ^
        -annotate -220+20 "0" ^
        -annotate -220-30 "50" ^
        -annotate -220-80 "100" ^
        vu_meter\frame_!FRAME!.png
)

echo.
echo Creating animated GIF...
magick -delay 3 -loop 0 vu_meter\frame_*.png vu_meter_animation.gif

echo.
echo Creating MP4 video...
magick -delay 3 vu_meter\frame_*.png vu_meter_animation.mp4

echo.
echo Done! Files created:
echo - vu_meter_animation.gif
echo - vu_meter_animation.mp4
echo - Individual frames in vu_meter\ folder
echo.
pause
