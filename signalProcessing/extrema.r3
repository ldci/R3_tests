#!/usr/local/bin/r3
REBOL [ 
]

imgSize: 1024x128
sSize: to-integer imgSize/x
img1: make image! reduce [imgSize black]
img2: make image! reduce [imgSize black]
img3: make image! reduce [imgSize black]
xStep: 0.1
xRound: 0.5
noise?: yes		;--add noise?
opencv?: yes	;--use opencv extension

generateSignal: function [
	deltaT	[decimal!]	;--x step
	sSize	[integer!]	;--vector size
][
	t1: 2.5 t2: 6.5
	t: make vector! compose [decimal! 64 (sSize)]
	i: 1 
	while [i <= sSize] [
		t/:i: (i - 1) * deltaT
		i: i + 1
	]
	signal: make vector! compose [decimal! 64 (sSize)]
	i: 1 
	while [i <= sSize] [
		ca: cos (2.5 * pi / t1 * t/:i)
		sa: sin (2.5 * pi / t2 * t/:i)
		either noise? 	[signal/:i: 2.5 * sa + ca] 
						[signal/:i: 2.5 * sa]
		i: i + 1
	]
	signal
]

rcvTSdifferentiate: function [
	"Calculate the first derivative of the signal"
	signal	[vector!]	;--float vector
	deltaT	[decimal!]	;--x step
	factor	[decimal!]	;--for rounding (0.5 by default)		
][
	n: length? signal
	filter: make vector! compose [decimal! 64 (n)]
	i: 2
	while [i < n] [
		y-: signal/(i - 1) y: signal/:i y+: signal/(i + 1)
		x-: i * deltaT - deltaT x: i * deltaT  x+: i * deltaT + deltaT
		average: factor * (((y+ - y) / (x+ - x)) + ((y - y-) / (x - x-)))
		filter/:i: average
		i: i + 1
	]
	filter/1: filter/2		;--first point
	filter/:n: average		;--last point
	filter
]

getExtrema: function [
	signal		[vector!]	;--original signal
	derivate	[vector!]	;--first derivate 	
][
	plot: copy []
	i: 1
	forall derivate [
		;--find derivate inflexion
		if (round derivate/1) = 0.0 [
			y: signal/:i
			unless none? y [
				y: pick [110 10] (sign? y) = 1
				append plot as-pair i + 11 y 
			] 
		]
		i: i + 1
	]
	plot
]

generateImage: func [v [vector!] img [image!] scale [decimal!] color [tuple!]
][
	repeat i v/length [
		y: 64 - (v/:i * scale)
		p: as-pair i y change/dup at img p color 3x3
	]
	img
]

showExtrema: function [
	b		[block!]
	img 	[image!]
	color 	[tuple!]
][
	repeat i length? b [
		p: b/:i
		change/dup at img p color 6x6
	]
]

x1: generateSignal xStep sSize
x2: rcvTSdifferentiate x1 xStep	xRound
x3: getExtrema x1 x2

generateImage x1 img1 10.0 red
generateImage x2 img2 10.0 blue
showExtrema x3 img3 green

if opencv? [
	cv: import opencv
	mat1: cv/Matrix :img2
	mat2: cv/Matrix :img3
	img4: cv/bitwise-or :mat1 :mat2 none
	cv/imshow/name :img1 "Signal"
	cv/imshow/name :img2 "Derivative"
	cv/moveWindow "Derivative" 0x120
	cv/imshow/name :img4 "Extrema"
	cv/moveWindow "Extrema" 0x300
	cv/waitkey 0
]

unless opencv? [
	print "Images saved"
	save %img1.png img1
	save %img2.png img2
	save %img3.png img3
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS
	call/shell "open img3.png"	;--macOS 
]

