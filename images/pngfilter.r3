#!/usr/local/bin/r3
REBOL [ 
] 
;see https://www.w3.org/TR/PNG-Filters.html
;the filter algorithms that can be applied before png compression
;--Filter Type: [sub up average paeth] or [1 2 3 4]
opencv?: yes								;--is opencv extension used?
im1: load %../pictures/lena.png				;--use your png image
bin: im1/rgb								;--image as binary
scanline: im1/size/x * 3					;--3 pixels by line
t: dt [f: filter bin scanline 'average]		;--R3 native filter
print ["Filtering:  " third t * 1000  "ms"]	;--msec
im2: make image! reduce [im1/size f]		;--make filtered image
bin: im2/rgb								;--image as binary
t: dt [f: unfilter/as bin scanline 'average];--R3 native unfilter
print ["Reversing:  " third t * 1000 "ms"]	;--msec
im3: make image! reduce [im2/size f]		;--make reversed image		

if opencv? [
	cv: import opencv						;--for visualisation
	cv/imshow/name im1 "Source"				;--show source image
	cv/moveWindow "Source" 0x0
	cv/imshow/name im2 "PNG Filter"			;--show filtered image
	cv/moveWindow "PNG Filter" 260x0
	cv/imshow/name im3 "Reversed Filter"	;--show reversed image
	cv/moveWindow "Reversed Filter" 520x0
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

print im1 == im3							;--source and reversed images identical?
