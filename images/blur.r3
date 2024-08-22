#!/usr/local/bin/r3
REBOL [
]
;--native Rebol 3 blur function
opencv?: yes					;--is opencv extension used?
radius: 2.5						;--should be > 0
filename: %../pictures/in.png	;--use your own image
src: load filename				;--load image
t: dt [blur src radius]			;--delta-time function for blurring	source image


if opencv? [
	;--use opencv module for image visualisation
	wtitle: join "Blurred in: " [form third t * 1000 " msec"]
	cv: import opencv				;--opencv module
	cv/imshow/name src wtitle		;--show blurred image
	cv/waitkey 0					;--wait for a key
	cv/destroyAllWindows			;--destroy all windows	
]

unless opencv? [
	print "Image saved"
	save %blur.png src
	call/shell "open blur.png"	;--macOS
]