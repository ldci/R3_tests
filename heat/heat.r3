#!/usr/local/bin/r3
REBOL [
]

b2d: import 'blend2d 	;--use blend2d (draw module)
cv:  import 'opencv		;--for visualisation

linSpace: function [
    "Generates N linearly spaced numbers from a to b (inclusive)."
    a [number!]  "Start"
    b [number!]  "End"
    n [integer!] "Number of samples"
    /no-end      "Don't include end value in the result"
    /local vec div
][
    either n < 2 [
        vec: make vector! [f64! 1]
        vec/1: a
    ][
        vec: make vector! [f64! :n]
        div: either no-end [n][n - 1]
        step: (b - a) / div
        repeat k n [
            vec/:k: a + (step * (k - 1))
        ]
    ]
    vec
]

;--Physical Parameters
k: 0.5		;--Diffusion coefficient
l: 1.0     	;--Domain size
iTime: 0.1  ;--Integration time

;--Numerical Parameters
nX: 100    ;--Number of grid points
nT: 1000   ;--Number of time steps

dx: l / (nX - 1)  	;--Grid step (x space)
dt: iTime / nT   	;--Grid step (y time)

vect: make vector! [f64! :nX]

;--Initialisation
init: does [
	x: linSpace 0.0 1.0 nX
	T: (x * 2.0 * pi)
	n: length? T
	repeat i n [T/:i: sin T/:i] ;--in radians
	plot: compose [
		font %/System/Library/Fonts/Geneva.ttf
		fill blue
		text 0x10  10 "+1.0"
		text 0x390 10 "-1.0"
		text 0x204 10 "0"
		pen black
		line 5x200 410x200 
	]
]

;--Heat diffusion equation
diffusion: does [
	posy: 0
	n: 0
	while [n <= nT] [
		j: 2
		while [j < nX] [
			vect/:j: dt * k * (T/(j - 1) - (2.0 * T/:j) + T/(j + 1)) / (dx ** 2)
			++ j
		]
		repeat j nX [T/:j: T/:j + vect/:j]
		;Plot every 100 time steps
		if n % 100 = 0 [ 
			acolor: random white
			posy: posy + 15
			either n = 0 [tt: "0.00"] [tt: round/to n % (n * dt) 0.001]
			tt: ajoin ["time = " tt]  pos: as-pair 340 posy
			append plot reduce ['fill (acolor) 'text (pos) 10 (tt) 'pen (acolor) 'line]
			xx: 2
			foreach val T [
				append plot as-pair xx * 4 200 - (val * 195) 
				++ xx 
			]
		]
		++ n
	]
]
;************************ Main Program ************************
random/seed now/time
init 
diffusion
img: b2d/draw 410x400 :plot
img: cv/resize img 150% 6	
cv/imshow/name :img "Heat Diffusion"
print "Any key to close"
cv/waitKey 0



