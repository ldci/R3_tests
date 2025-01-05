#!/usr/local/bin/r3
REBOL [ 
	needs: 3.18.1
]
do %Tools/fvectors.r3					;--function for vectors
b2d: import 'blend2d					;--use blend2d (draw module)
opencv?: yes							;--use OpenCV module?
if opencv? [cv: import opencv]			;--OpenCV extension for Rebol3
random/seed now/time/precise			;--for random values
x: 1024 								;-- 1 sec (1 kHz)
y: 128								;--for image size/y
size: as-pair x y 						;--images size


generateImage: func [
"Creating image"
	v 		[vector!] 
	img 	[image!] 
	scale 	[decimal!]
	cyValue	[integer!]
	color 	[tuple!]
][
	i: 0
	;--blend2d commands
	plot: copy [pen white line-width 1 line 0x64 1024x64 pen color line]
	forall v [append plot as-pair i cyValue + (v/1 * scale) ++ i]
	draw img :plot 
]


;********************** Main program *************************

bm1: make image! reduce [size black]			;--image 1
bm2: make image! reduce [size black]			;--image 2
bm3: make image! reduce [size black]			;--image 3

vec0: make vector! compose [decimal! 64 (x)]	;--1000 values
vec1: vectRandom vec0 128						;--0..100 
vec2: detrendSignal vec1						;--detrend random signal
vec3: medianFilter vec2							;--median filter
generateImage vec1 bm1 1.0 0 navy				;--original signal
generateImage vec2 bm2 1.0 0 red				;--detrended signal
generateImage vec3 bm3 100.0 64 red				;--median filter

either opencv? [
	cv/imshow/name :bm1 "Random Signal"
	cv/imshow/name :bm3 "Median filter"
	cv/moveWindow "Median filter" 0x120
	print "Any key to close"
	cv/waitkey 0
]
[
	print "Images saved"
	save %img1.png bm1
	save %img2.png bm2
	save %img3.png bm3
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS 
	call/shell "open img3.png"	;--macOS
]






