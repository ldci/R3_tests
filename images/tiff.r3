#!/usr/local/bin/r3
REBOL [
]
? system/codecs/tiff
src: load %../pictures/test1.tiff; 001.tif
print system/codecs/tiff/identify src/rgb
cv: import opencv
cv/imshow/name src "Tiff"
cv/waitkey 0