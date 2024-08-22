#!/usr/local/bin/r3
REBOL [ 
] 
opencv?: yes	;--is opencv extension used?
random/seed now/time/precise
mSize: 480
bm: make image! reduce [as-pair mSize mSize black]
color: random white
y: 0
while [y < mSize] [
	x: 0
	while [x < mSize][
		idx: y * mSize + x + 1		;--Rebol is one-based
		if x = y [bm/:idx: color]
		++ x
	]
	++ y
]

if opencv? [
	;--OpenCV extension for Rebol3
	cv: import opencv
	cv/imshow :bm
	print "Any key to close"
	cv/waitkey 0
]
unless opencv? [
	print "Image saved"
	save %bitmap.png bm
	call/shell "open bitmap.png"	;--macOS 
]