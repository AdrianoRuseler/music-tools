@echo off
setlocal enabledelayedexpansion

REM LED-Style VU Meter Generator
REM Usage: vu_meter.bat [left_level] [right_level]
REM Levels: 0-40 (number of active segments)
REM Example: vu_meter.bat 25 30

echo LED-Style VU Meter Generator
echo =============================
echo.

REM Get levels from command line or use defaults
if "%1"=="" (
    set /p LEFT_LEVEL="Enter LEFT channel level (0-40): "
) else (
    set LEFT_LEVEL=%1
)

if "%2"=="" (
    set /p RIGHT_LEVEL="Enter RIGHT channel level (0-40): "
) else (
    set RIGHT_LEVEL=%2
)

REM Validate input
if !LEFT_LEVEL! GTR 40 set LEFT_LEVEL=40
if !LEFT_LEVEL! LSS 0 set LEFT_LEVEL=0
if !RIGHT_LEVEL! GTR 40 set RIGHT_LEVEL=40
if !RIGHT_LEVEL! LSS 0 set RIGHT_LEVEL=0

echo.
echo Generating VU Meter...
echo LEFT: !LEFT_LEVEL!/40 segments
echo RIGHT: !RIGHT_LEVEL!/40 segments
echo.

REM VU Meter parameters
set WIDTH=800
set HEIGHT=250
set SEGMENTS=40

REM Build draw commands for LEFT channel
set DRAW_LEFT=
for /L %%s in (0,1,39) do (
    set /a SEG=%%s
    set /a X_POS=50+!SEG!*18
    set /a X_END=!X_POS!+15
    
    REM Determine segment color based on position
    if !SEG! LSS 20 (
        set SEG_COLOR=lime
        set SEG_OFF=rgb(0,40,0)
    ) else if !SEG! LSS 32 (
        set SEG_COLOR=yellow
        set SEG_OFF=rgb(40,40,0)
    ) else (
        set SEG_COLOR=red
        set SEG_OFF=rgb(40,0,0)
    )
    
    REM Check if segment should be lit
    if !SEG! LSS !LEFT_LEVEL! (
        set DRAW_LEFT=!DRAW_LEFT! -fill !SEG_COLOR!
    ) else (
        set DRAW_LEFT=!DRAW_LEFT! -fill !SEG_OFF!
    )
    
    set DRAW_LEFT=!DRAW_LEFT! -draw "rectangle !X_POS!,50 !X_END!,90"
)

REM Build draw commands for RIGHT channel
set DRAW_RIGHT=
for /L %%s in (0,1,39) do (
    set /a SEG=%%s
    set /a X_POS=50+!SEG!*18
    set /a X_END=!X_POS!+15
    
    REM Determine segment color based on position
    if !SEG! LSS 20 (
        set SEG_COLOR=lime
        set SEG_OFF=rgb(0,40,0)
    ) else if !SEG! LSS 32 (
        set SEG_COLOR=yellow
        set SEG_OFF=rgb(40,40,0)
    ) else (
        set SEG_COLOR=red
        set SEG_OFF=rgb(40,0,0)
    )
    
    REM Check if segment should be lit
    if !SEG! LSS !RIGHT_LEVEL! (
        set DRAW_RIGHT=!DRAW_RIGHT! -fill !SEG_COLOR!
    ) else (
        set DRAW_RIGHT=!DRAW_RIGHT! -fill !SEG_OFF!
    )
    
    set DRAW_RIGHT=!DRAW_RIGHT! -draw "rectangle !X_POS!,150 !X_END!,190"
)

REM Create VU meter image
magick -size %WIDTH%x%HEIGHT% xc:black ^
    -fill white -pointsize 14 -gravity NorthWest ^
    -annotate +20+25 "LEFT" ^
    -annotate +20+125 "RIGHT" ^
    -fill gray30 -draw "rectangle 45,45 770,95" ^
    -fill gray30 -draw "rectangle 45,145 770,195" ^
    !DRAW_LEFT! ^
    !DRAW_RIGHT! ^
    -fill white -pointsize 10 ^
    -annotate +30+210 "0dB" ^
    -annotate +45+225 "-30dB" ^
    -annotate +310+225 "-15dB" ^
    -annotate +575+225 "-10dB" ^
    -annotate +715+225 "-5dB" ^
    -annotate +755+210 "0dB" ^
    -fill gray50 -draw "line 365,40 365,200" ^
    -fill gray50 -draw "line 620,40 620,200" ^
    -fill gray50 -draw "line 728,40 728,200" ^
    vu_meter.png

echo Done! File created: vu_meter.png
echo.
pause
