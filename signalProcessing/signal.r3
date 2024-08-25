#!/usr/local/bin/r3
REBOL [ 
]
random/seed now/time/precise
opencv?: yes
x: 1000 ;-- 1 sec
y: 200
size: as-pair x y

vectRandom: func [v [vector!] value [number!]
][
	repeat i v/length [v/:i: 280 - random value]
	v
]


mean: function [v [vector!] return: [decimal!]][ (sum v) / (v/length)]

stddev: function [v [vector!] return: [decimal!]][
	average: mean v
	sigma: 0.0
	foreach value v [sigma: sigma + (power (value - average) 2)]
	sqrt sigma / ((v/length) - 1)
]

detrendSignal: func [v [vector!]
][
	average: mean v
	repeat i v/length [v/:i: v/:i - average]
	v
]

normalizeSignal: func [v [vector!]
][
	average: mean v
	std: stddev v
	repeat i v/length [v/:i: v/:i - average / std]
	v
]


generateImage: func [v [vector!] img [image!] scale [decimal!]
][
	repeat i v/length [
		y: (v/:i * scale)
		p: as-pair i y change/dup at img p red 4x4
	]
	img
]

generateNormalizedImage: func [v [vector!] img [image!]
][
	repeat i v/length [
		y: 100 - (v/:i * 10.0)
		p: as-pair i y change/dup at img p blue 4x4]
	img
]


vec: make vector! compose [decimal! 64 (x)]
vec: vectRandom vec 120
bm1: make image! reduce [size snow 200]
bm2: make image! reduce [size snow 200]

vec2: detrendSignal vec
vec3: normalizeSignal vec2
generateImage vec bm1 100.0
generateNormalizedImage vec3 bm2 

if opencv? [
	;--OpenCV extension for Rebol3
	cv: import opencv
	cv/imshow/name :bm1 "Random Signal"
	cv/imshow/name :bm2 "Normalized Signal"
	cv/moveWindow "Normalized Signal" 0x200
	print "Any key to close"
	cv/waitkey 0
]
unless opencv? [
	print "Images saved"
	save %img1.png bm1
	save %img2.png bm2
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS 
]



