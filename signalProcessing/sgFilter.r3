#!/usr/local/bin/r3
REBOL [ 
]

;--note: all vectors are float! 64
;--updated for new vector implementation in R3

do %tools/sgTables.r3	;--Loads SG coefficients tables	

SGFiltering: function [
	signal 		[vector!]
	filter 		[vector!]
	kernel		[block!]
][
	sLength: signal/length				;--signal size
	kLength: (length? kernel) - 1		;--kernel size (without the last value used for normalisation)
	nl: nr:  to integer! kLength / 2	;--split kernel into 2 parts (left and right)
	fsumCoef: last kernel 				;--normalisation value in kernel table 
	sglength: nl + nr + 1				;--filter size
	i: nl								;--skip nl values (extreme points are ignored)
	;--start filter
	while [i <= (slength - nr)] [	
		;--until signal upper limit
		sg: sigma: 0.0
    	n: 1
    	;--use kernel for filter
    	while [n < sglength][
    		val: signal/(i - nl + n)	;--get signal value
    		coef: kernel/:n				;--get coefficient value in the kernel
    		sigma: sigma + (val * coef)	;--calculate the sum
    		++ n
    	]
		sg: sigma / fsumCoef			;--Normalised SG filter value
		if i = nl [val2: sg] 			;--for replacing extreme points
		filter/:i: sg					;--store calculated value in filter vector
		++ i
	]
	;--update extreme values (not really required, just for a better visualization)
	i: 1
	while [i <= nl] [filter/:i: val2 ++ i]
	i: round slength - nr
	while [i <= slength] [filter/:i: val2 ++ i]
]

SGFilter: function [
"Calculates second order polynomial Savitzky-Golay filter"
	signal 		[vector!]
	filter 		[vector!]
	opSG		[integer!]
][
	;pre defined sg coefficients for fast calculation (cubic polynomials)./
	case [
		opSG = 1  [kernel: sgTable1/1] 	;5 points
    	opSG = 2  [kernel: sgTable1/2]	;7 points
    	opSG = 3  [kernel: sgTable1/3]  ;9 points
    	opSG = 4  [kernel: sgTable1/4] 	;11 points
    	opSG = 5  [kernel: sgTable1/5] 	;13 points
    	opSG = 6  [kernel: sgTable1/6]	;15 points
    	opSG = 7  [kernel: sgTable1/7]	;17 points
    	opSG = 8  [kernel: sgTable1/8]	;19 points
    	opSG = 9  [kernel: sgTable1/9]	;21 points
    	opSG = 10 [kernel: sgTable1/10]	;23 points
    	opSG = 11 [kernel: sgTable1/11] ;25 points
    ]
    
    ;quartic  and quintic polynomials
    case [
    	opSG = 12  [kernel: sgTable2/1]	;7 points
    	opSG = 13  [kernel: sgTable2/2]	;9 points
    	opSG = 14  [kernel: sgTable2/3] ;11 points
    	opSG = 15  [kernel: sgTable2/4] ;13 points
    	opSG = 16  [kernel: sgTable2/5]	;15 points
    	opSG = 17  [kernel: sgTable2/6]	;17 points
    	opSG = 18  [kernel: sgTable2/7]	;19 points
    	opSG = 19  [kernel: sgTable2/8]	;21 points
    	opSG = 20  [kernel: sgTable2/9] ;23 points
    	opSG = 21  [kernel: sgTable2/10];25 points
    ]
    SGFiltering signal filter kernel
]

SGCubicFilter: function [
"Calculates second order polynomial Savitzky-Golay filter"
	signal 		[vector!]
	filter 		[vector!]
	opSG		[integer!]
][
	
    kernel: sgTable1/:opSG
    unless none? kernel [SGFiltering signal filter kernel]
]

SGQuarticFilter: function [
"Calculates second order polynomial Savitzky-Golay filter"
	signal 		[vector!]
	filter 		[vector!]
	opSG		[integer!]
][
	
    kernel: sgTable2/:opSG
    unless none? kernel [SGFiltering signal filter kernel]
]

SGDerivative: function [
"Calculates first derivative polynomial Savitzky-Golay filter"
	signal 		[vector!]
	filter 		[vector!]
	opSG		[integer!]
][
	;pre defined sg coefficients for fast calculation (Derivative 1 quadratic)
	case [
		opSG = 1  [kernel: sgTable3/1] 	;5 points
		opSG = 2  [kernel: sgTable3/2]	;7 points
		opSG = 3  [kernel: sgTable3/3]	;9 points
		opSG = 4  [kernel: sgTable3/4]	;11 points
		opSG = 5  [kernel: sgTable3/5]	;13 points
		opSG = 6  [kernel: sgTable3/6]	;15 points
		opSG = 7  [kernel: sgTable3/7]  ;17 points
		opSG = 8  [kernel: sgTable3/8]  ;19 points
		opSG = 9  [kernel: sgTable3/9]  ;21 points
		opSG = 10 [kernel: sgTable3/10] ;23 points
		opSG = 11 [kernel: sgTable3/11] ;25 points
	]
	;Derivative 1 quartic)
	case [
		opSG = 12  [kernel: sgTable4/1] ;5 points
		opSG = 13  [kernel: sgTable4/2] ;7 points
		opSG = 14  [kernel: sgTable4/3]	;9 points
		opSG = 15  [kernel: sgTable4/4]	;11 points
		opSG = 16  [kernel: sgTable4/5]	;13 points
		opSG = 17  [kernel: sgTable4/6]	;15 points
		opSG = 18  [kernel: sgTable4/7]	;17	points
		opSG = 19  [kernel: sgTable4/8]	;19 points
		opSG = 20  [kernel: sgTable4/9] ;21 points
		opSG = 21  [kernel: sgTable4/10];23 points
		opSG = 22  [kernel: sgTable4/11];25 points
	]
	
	;Derivative 1 quintic sextic
	case [
		opSG = 23 [kernel: sgTable5/1] 	;5 points
		opSG = 24 [kernel: sgTable5/2] 	;7 points
		opSG = 25 [kernel: sgTable5/3]	;11 points
		opSG = 26 [kernel: sgTable5/4]	;13 points
		opSG = 27 [kernel: sgTable5/5]	;15 points
		opSG = 28 [kernel: sgTable5/6]	;17 points
		opSG = 29 [kernel: sgTable5/7]	;19 points
		opSG = 30 [kernel: sgTable5/8]	;21 points
		opSG = 31 [kernel: sgTable5/9]	;23 points
		opSG = 32 [kernel: sgTable5/10]	;25 points
	]
    SGFiltering signal filter kernel
]

generateImage: function [
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

;*********************** test program ************************
random/seed now/time/precise
b2d: import 'blend2d
cv:  import 'opencv
x: 1024
y: 128
size: as-pair x y
vec0: make vector! [f64! :x]
vec1: make vector! [f64! :x]
vec2: make vector! [f64! :x]
repeat i vec0/length [vec0/:i: random y / 2]
opSG: 5 ;--13 points for the kernel
tt: dt [
	bm0: make image! reduce [size black]
	bm1: make image! reduce [size black]
	bm2: make image! reduce [size black]
	SGFilter vec0 vec1 opSG
	SGDerivative vec0 vec2 opSG
	generateImage vec0 :bm0 1.0 32 blue
	generateImage vec1 :bm1 1.0 32 green
	generateImage vec2 :bm2 2.0 64 red
]

print ajoin ["Generated in:" round third tt * 1000 " ms"]

cv/imshow/name :bm0 "Random Signal"
cv/imshow/name :bm1 "Savitzky-Golay filter"
cv/imshow/name :bm2 "Savitzky-Golay Derivative"
cv/moveWindow "Savitzky-Golay filter" 0x110
cv/moveWindow "Savitzky-Golay Derivative" 0x270
cv/waitkey 0
cv/destroyAllWindows


