magick ^
  ^( -size 300x100 xc:black ^
     -gravity north -pointsize 28 -fill white -font Arial ^
     -annotate +0+10 "RIGHT" ^) ^
  ^( -size 240x30 gradient:green-yellow ^
     -size 240x30 gradient:yellow-orange ^
     -append -crop 240x30+0+30 +repage ^) ^
  -geometry +30+50 -composite ^
  gradient_bar_fixed.png
