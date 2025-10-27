@echo off
setlocal

:: Define colors and dimensions
set BG_COLOR=#FFFFFF
set TABLE_WIDTH=400
set TABLE_HEIGHT=120
set TEXT_COLOR=#000000
set HEADER_HEIGHT=40
set ROW_HEIGHT=80
set KEY_WIDTH=100
set TEMPO_WIDTH=150
set ENERGY_WIDTH=150
set HIGHLIGHT_COLOR=#48D1CC
set HIGHLIGHT_TEXT_COLOR=#000000

:: Step 1: Create the base canvas (white)
magick ^
  -size %TABLE_WIDTH%x%TABLE_HEIGHT% ^
  canvas:%BG_COLOR% ^
  table_base.png

:: Step 2: Draw the horizontal and vertical dividing lines
magick table_base.png ^
  -stroke "#AAAAAA" ^
  -strokewidth 1 ^
  -draw "line 0,%HEADER_HEIGHT% %TABLE_WIDTH%,%HEADER_HEIGHT%" ^
  -draw "line %KEY_WIDTH%,0 %KEY_WIDTH%,%TABLE_HEIGHT%" ^
  -draw "line %KEY_WIDTH%,%HEADER_HEIGHT% %KEY_WIDTH%,%TABLE_HEIGHT%" ^
  -draw "line %TEMPO_WIDTH%,0 %TEMPO_WIDTH%,%TABLE_HEIGHT%" ^
  -draw "line %TEMPO_WIDTH%,%HEADER_HEIGHT% %TEMPO_WIDTH%,%TABLE_HEIGHT%" ^
  -draw "line %KEY_WIDTH%,0 %KEY_WIDTH%,%TABLE_HEIGHT%" ^
  -draw "line %KEY_WIDTH%,0 %KEY_WIDTH%,%TABLE_HEIGHT%" ^
  -draw "line %KEY_WIDTH%,%HEADER_HEIGHT% %KEY_WIDTH%,%TABLE_HEIGHT%" ^
  -draw "line %KEY_WIDTH%,%HEADER_HEIGHT% %KEY_WIDTH%,%TABLE_HEIGHT%" ^
  -draw "line %KEY_WIDTH%,%HEADER_HEIGHT% %KEY_WIDTH%,%TABLE_HEIGHT%" ^
  table_grid.png

:: Step 3: Draw the Blue Highlight Box (Key 12A)
:: The box is positioned in the first data cell.
magick table_grid.png ^
  -fill %HIGHLIGHT_COLOR% ^
  -draw "roundrectangle 5, %HEADER_HEIGHT%+5, %KEY_WIDTH%-5, %TABLE_HEIGHT%-5, 5, 5" ^
  table_highlight.png

:: Step 4: Add the Header Text (Key, Tempo, Energy)
magick table_highlight.png ^
  -gravity NorthWest ^
  -pointsize 14 ^
  -fill %TEXT_COLOR% ^
  -annotate +20+12 "Key" ^
  -annotate +%KEY_WIDTH%+20+12 "Tempo" ^
  -annotate +%KEY_WIDTH%+%TEMPO_WIDTH%+20+12 "Energy" ^
  table_headers.png

:: Step 5: Add the Data Text (12A, 87, 6)
:: Use specific coordinates to center them in their cells.
magick table_headers.png ^
  -gravity NorthWest ^
  -pointsize 16 ^
  -fill %HIGHLIGHT_TEXT_COLOR% ^
  -annotate +20+60 "12A" ^
  -fill %TEXT_COLOR% ^
  -annotate +%KEY_WIDTH%+45 "87" ^
  -annotate +%KEY_WIDTH%+%TEMPO_WIDTH%+45 "6" ^
  table_data_text.png

:: Step 6: Add the Energy Bar (Simple polygon for a rough approximation)
:: This is drawn in the Energy cell, slightly offset.
set ENERGY_BAR_START_X=%KEY_WIDTH%+%TEMPO_WIDTH%+60
set ENERGY_BAR_START_Y=%HEADER_HEIGHT%+25
magick table_data_text.png ^
  -fill "#4169E1" ^
  -draw "polygon %ENERGY_BAR_START_X%,%ENERGY_BAR_START_Y% %ENERGY_BAR_START_X%+20,%ENERGY_BAR_START_Y%-10 %ENERGY_BAR_START_X%+20,%ENERGY_BAR_START_Y%+10" ^
  -fill "#A9A9A9" ^
  -draw "polygon %ENERGY_BAR_START_X%,%ENERGY_BAR_START_Y% %ENERGY_BAR_START_X%+20,%ENERGY_BAR_START_Y%-10 %ENERGY_BAR_START_X%+20,%ENERGY_BAR_START_Y%+10" ^
  -fill "#4169E1" ^
  -draw "polygon %ENERGY_BAR_START_X%,%ENERGY_BAR_START_Y% %ENERGY_BAR_START_X%+12,%ENERGY_BAR_START_Y%-6 %ENERGY_BAR_START_X%+12,%ENERGY_BAR_START_Y%+6" ^
  table_final.png

:: Step 7: Clean up intermediate files
:: del table_base.png table_grid.png table_highlight.png table_headers.png table_data_text.png

echo Final image generated: table_final.png
endlocal
