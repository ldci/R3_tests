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
opencv?: yes	;--use opencv extension?
if opencv? [cv: import opencv]

generateSignal: function [
	"Generate a signal with or whithout noise"
	deltaT	[decimal!]	;--x step
	sSize	[integer!]	;--vector size
	noise?	[logic!]
][
	t1: 2.5 t2: 6.5
	t: make vector! [f64! :sSize]
	repeat i sSize [t/:i: (i - 1) * deltaT]
	signal: make vector! [f64! :sSize]
	repeat i sSize [
		ca: cos (t1 * pi / t1 * t/:i)
		sa: sin (t1 * pi / t2 * t/:i)
		either noise? [signal/:i: t1 * sa + ca][signal/:i: t1 * sa]
	]
	signal
]

rcvTSdifferentiate: function [
	"Calculate the first derivative of the signal. From redCV"
	signal	[vector!]	;--float vector
	deltaT	[decimal!]	;--x step
	factor	[decimal!]	;--for rounding (0.5 by default)		
][
	n: signal/length
	filter: make vector! [f64! :n]
	i: 2
	while [i < n] [
		y-: signal/(i - 1) y: signal/:i y+: signal/(i + 1)
		x-: i * deltaT - deltaT x: i * deltaT  x+: i * deltaT + deltaT
		_average: factor * (((y+ - y) / (x+ - x)) + ((y - y-) / (x - x-)))
		filter/:i: _average
		++ i
	]
	filter/1: filter/2		;--first point
	filter/:n: _average		;--last point
	filter
]

getExtrema: function [
	"Get extrema values in signal as a block"
	signal		[vector!]	;--original signal
	derivate	[vector!]	;--first derivate 	
	step		[decimal!]	;--for x scale
][	
	extrema: copy []	;--a block for storing pairs
	i: 1
	forall derivate [
		;--find derivate inflexion (0.0)
		if zero? round derivate/1 [
			y: signal/:i
			y: pick [125 5] (sign? y) = 1 ;-- 1 or -1
			append extrema as-pair i + (1 / step) y
		]
		++ i
	]
	extrema
]


showExtrema: function [
	b		[block!]
	img 	[image!]
	color 	[tuple!]
][
	;--blend2d commands
	code: copy [pen color line-width 1 line]
	repeat i length? b [append code b/:i + 3x0]
	draw img :code
	img
]

generateImage: function [
	v 		[vector!] 
	img 	[image!] 
	scale 	[decimal!] 
	color 	[tuple!]
][
	;--blend2d commands
	code: copy [pen color line-width 1 line 0x64 1024x64 line]	
	repeat i v/length [append code as-pair i 64 - (v/:i * scale)]
	draw img :code
	img
]

;********************** Main Program ************************

x1: generateSignal xStep sSize yes		;--signal with noise
x2: rcvTSdifferentiate x1 xStep	xRound	;--differentiate signal
x3: getExtrema x1 x2 xStep				;--get extrema as a block

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

