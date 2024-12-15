#!/usr/local/bin/r3
REBOL [ 
	needs: 3.18.1
]
do %Tools/fvectors.r3					;--function for vectors
b2d: import 'blend2d					;--use blend2d (draw module)
opencv?: yes							;--use OpenCV module?
if opencv? [cv: import 'opencv]			;--OpenCV extension for Rebol3
random/seed now/time/precise			;--for random values
x: 1000 								;--1 sec (1 kHz)
y: 100									;--for image size/y
size: as-pair x y 						;--images size


generateImage: func [
"Creating image"
	v 		[vector!] 
	img 	[image!] 
	scale 	[decimal!]
	color 	[tuple!]
][
	;--blend2d commands
	code: copy [pen color line-width 1 line]
	repeat i v/length [append code as-pair i 50 - (v/:i * scale)]
	draw img :code
	img
]


;********************** Main program *************************

bm1: make image! reduce [size snow]				;--image 1
bm2: make image! reduce [size snow]				;--image 2
bm3: make image! reduce [size snow]				;--image 3
bm4: make image! reduce [size snow]				;--image 4
bm5: make image! reduce [size snow]				;--image 5

vec0: make vector! compose [decimal! 64 (x)]	;--1000 values
vec1: vectRandom vec0 100						;--0..100 
vec2: detrendSignal vec1						;--detrend random signal
vec3: normalizeSignal vec2
vec4: minMaxNormalization vec2					;--normalize detrended signal
vec5: medianFilter vec2							;--median filter
generateImage vec1 bm1 0.3 navy					;--original signal
generateImage vec2 bm2 0.3 red					;--detrended signal
generateImage vec3 bm3 10.0 green				;--normalized signal
generateImage vec4 bm4 25.0 purple				;--min-max signal
generateImage vec5 bm5 30.0 black				;--median filter

if opencv? [
	cv/imshow/name :bm1 "Random Signal"
	cv/imshow/name :bm2 "Detrended Signal"
	cv/imshow/name :bm3 "Z-score Normalized Signal"
	cv/imshow/name :bm4 "Min-Max Normalized Signal"
	cv/imshow/name :bm5 "Median filter"
	cv/moveWindow "Detrended Signal" 0x80
	cv/moveWindow "Z-score Normalized Signal" 0x210
	cv/moveWindow "Min-Max Normalized Signal" 0x340
	cv/moveWindow "Median filter" 0x470
	print "Any key to close"
	cv/waitkey 0
]
unless opencv? [
	print "Images saved"
	save %img1.png bm1
	save %img2.png bm2
	save %img3.png bm3
	save %img4.png bm4
	save %img5.png bm5
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS 
	call/shell "open img3.png"	;--macOS
	call/shell "open img4.png"	;--macOS
	call/shell "open img5.png"	;--macOS
]






