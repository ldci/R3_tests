#!/usr/local/bin/r3
REBOL [ 
]

b2d: import 'blend2d					;--use blend2d (draw module)
opencv?: yes							;--use OpenCV module?
if opencv? [cv: import opencv]			;--OpenCV extension for Rebol3
random/seed now/time/precise

x: 1000 								;-- 1 sec (1kHz)
y: 200
size: as-pair x y 						;--images size

vectRandom: func [v [vector!] value [number!]
][
	_v: copy v
	repeat i _v/length [_v/:i: random value]
	_v
]


;mean: function [v [vector!] return: [decimal!]][ (sum v) / (v/length)]
;--use standard R3 average function
;--sum and average are supported by Red
stddev: function [v [vector!] return: [decimal!]][
	sigma: 0.0
	foreach value v [sigma: sigma + (power (value - average v) 2)]
	sqrt sigma / ((v/length) - 1)
]

detrendSignal: func [v [vector!]
][
	_v: copy v
	repeat i _v/length [_v/:i: _v/:i - average _v]
	_v
]

normalizeSignal: func [v [vector!]
][
	_v: copy v
	_average: average _v
	_std: stddev _v
	repeat i _v/length [_v/:i: _v/:i - _average / _std]
	_v
]


generateImage: func [
	v 		[vector!] 
	img 	[image!] 
	scale 	[decimal!]
	color 	[tuple!]
][
	;--blend2d commands
	code: copy [pen color line-width 1 line]
	repeat i v/length [append code as-pair i 100 - (v/:i * scale)]
	draw img :code
	img
]


;********************** Main program *************************

bm1: make image! reduce [size snow]			;--image 1
bm2: make image! reduce [size snow]			;--image 2

;vec0: make vector! compose [f64! (x)]
vec0: make vector! compose [decimal! 64 (x)]	;--1000 values

vec1: vectRandom vec0 100.0						;--0..100 
vec2: detrendSignal vec1						;--detrend random signal
vec3: normalizeSignal vec2						;--normalize detrended signal
generateImage vec1 bm1 0.75 navy				;--original signal
generateImage vec3 bm2 10.0 red					;--filtered signal
print [vec1/1 vec2/1 vec3/1 ] 
print vec1 == vec2
print vec2 == vec3
if opencv? [
	cv/imshow/name :bm1 "Random Signal"
	cv/imshow/name :bm2 "Normalized Signal"
	cv/moveWindow "Normalized Signal" 0x190
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



