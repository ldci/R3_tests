#!/usr/local/bin/r3
REBOL [ 
]

b2d: import 'blend2d ;--use blend2d (draw module)
imgSize: 1024x128
sSize: to-integer imgSize/x
img1: make image! reduce [imgSize black]
img2: make image! reduce [imgSize black]
img3: make image! reduce [imgSize black]
xStep: 0.1		;--for signal frequency
xRound: 0.5		;--for rounding
noise?: yes		;--add noise?
opencv?: yes	;--use opencv extension?
if opencv? [cv: import opencv]

generateSignal: func [
	"Generate a signal with or whithout noise"
	deltaT	[decimal!]	;--x step
	sSize	[integer!]	;--vector size
][
	t1: 2.5 t2: 6.5
	t: make vector! compose [decimal! 64 (sSize)]
	signal: make vector! compose [decimal! 64 (sSize)]
	repeat i sSize [t/:i: (i - 1) * deltaT]
	repeat i sSize [
		ca: cos (2.5 * pi / t1 * t/:i)
		sa: sin (2.5 * pi / t2 * t/:i)
		either noise? [signal/:i: 2.5 * sa + ca][signal/:i: 2.5 * sa]
	]
	signal
]

rcvTSdifferentiate: func [
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
		++ i
	]
	filter/1: filter/2		;--first point
	filter/:n: average		;--last point
	filter
]

getExtrema: func [
	"Get extrama values in signal"
	signal		[vector!]	;--original signal
	derivate	[vector!]	;--first derivate 	
	step		[decimal!]	;--for x scale
][
	extrema: copy []
	i: 1
	forall derivate [
		;--find derivate inflexion
		if (round derivate/1) = 0.0 [
			y: signal/:i
			y: pick [125 5] (sign? y) = 1
			append extrema as-pair i + (1 / step) y 
		]
		++ i
	]
	extrema
]

generateImage: func [
	v 		[vector!] 
	img 	[image!] 
	scale 	[decimal!] 
	color 	[tuple!]
][
	;--blend2d commands
	code: copy [pen color line-width 1 line]	
	repeat i v/length [append code as-pair i 64 - (v/:i * scale)]
	draw img :code
	img
]

showExtrema: func [
	b		[block!]
	img 	[image!]
	color 	[tuple!]
][
	;--blend2d commands
	code: copy [pen color line-width 2 line]
	repeat i length? b [append code b/:i + 3x0]
	draw img :code
	img
]

;********************** Main Program ************************

x1: generateSignal xStep sSize
x2: rcvTSdifferentiate x1 xStep	xRound
x3: getExtrema x1 x2 xStep

generateImage x1 img1 10.0 red
generateImage x2 img2 10.0 gold
showExtrema   x3 img3 green

if opencv? [
	mat1: cv/Matrix :img2
	mat2: cv/Matrix :img3
	mat3: cv/add :mat1 :mat2 none
	cv/imshow/name :img1 "Signal"
	cv/imshow/name :img2 "Derivative"
	cv/moveWindow "Derivative" 0x110
	cv/imshow/name :mat3 "Extrema"
	cv/moveWindow "Extrema" 0x270
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

