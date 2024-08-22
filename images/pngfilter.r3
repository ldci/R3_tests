#!/usr/local/bin/r3
REBOL [ 
] 
;see https://www.w3.org/TR/PNG-Filters.html
;the filter algorithms that can be applied before png compression
;--Filter Type: [sub up average paeth] or [1 2 3 4]
opencv?: yes								;--is opencv extension used?
im1: load %../pictures/lena.png				;--use your image
bin: im1/rgb								;--image as binary
scanline: im1/size/x * 3					;--3 pixels by line
t: dt [f: filter bin scanline 'average]		;--filter
print ["Filtering:  " third t  "sec"]		;--sec
im2: make image! reduce [im1/size f]		;--make filtered image
bin: im2/rgb								;--image as binary
t: dt [f: unfilter/as bin scanline 'average];--unfilter
print ["Unfiltering:" third t "sec"]		;--sec
im3: make image! reduce [im2/size f]		;--make unfiltered image		

if opencv? [
	cv: import opencv						;--for visualisation
	cv/imshow/name im1 "Source"				;--show source image
	cv/waitkey 0							;--any key to continue
	cv/imshow/name im2 "Filtered"			;--show filtered image
	cv/waitkey 0							;--any key to continue
	cv/imshow/name im3 "Unfiltered"			;--show unfiltered image
	cv/waitkey 0							;--any key to close
	cv/destroyAllWindows					;--destroy all windows
]

unless opencv? [
	print "Images saved"
	save %img2.png im2
	save %img3.png im3
	call/shell "open img2.png"				;--macOS
	call/shell "open img3.png"				;--macOS
]

print im1 == im3							;--source and unfiltered images identical?
print im1 =? im3							;--not the same data in memory
