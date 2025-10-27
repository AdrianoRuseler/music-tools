magick -size 300x60 xc:white ^
  -gravity west -pointsize 36 -fill black -font Arial ^
  -annotate +10+0 "6" ^
  -draw "fill gray rectangle 60,20 280,40" ^
  -draw "fill blue rectangle 60,20 120,40" ^
  volume_indicator.png
