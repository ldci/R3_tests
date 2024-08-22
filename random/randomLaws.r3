#!/usr/local/bin/r3
REBOL [ 
]


img1: make image! reduce [256x256 black]
img2: make image! reduce [256x256 black]
 
; *************** some constant values *******************

RAND_MAX: 2147483647.0 ; max int
FLOAT_MAX: 1E100

umax: power (1 / (2 * pi)) 0.25
vmax: power (2 / (pi * exp 2)) 0.25
log2pi: log-e (2 * pi)


; *********** and useful functions and routines *********

randFloat: function [
"returns a decimal value beween 0 and 1. Base 16 bit" 
][
	x: random power 2 16
	x / power 2 16
]
 


;********************************************
;***			CONTINUOUS LAWS			  ***
;********************************************

;
randGaussian: function [
"generate a Gaussian random variable with mean  and standard deviation"
	mean 	[decimal!] 
	stdev 	[decimal!] 
	/x /y 
][
	rsq: 0.0
	while [any [(rsq >= 1.0) (rsq == 0.0)]][
		x: (2.0 * random RAND_MAX) / RAND_MAX - 1.0
		y: (2.0 * random RAND_MAX) / RAND_MAX - 1.0
		rsq: (x * x) + (y * y) 
	]
	f: sqrt ((-2.0 * log-e rsq) / rsq)
	;return:[decimal!]
	case [
		x [return mean + x * f * stdev]
		y [return mean + y * f * stdev]
	]
]


;uniform law on (e.g. 1.0)
randUnif: function [i [decimal!] j [decimal!]]
[
	randFloat * (j - i) + i
]

;exponential law
randExp: function [] [
	negate log-e randFloat
]

;exponential law with a l degree (e.g. 1.0)
randExpm: function [l [decimal!]] [
	negate log-e (randFloat / l)
]

;normal law (e.g. 1.0)
randNorm: function [A [decimal!]] [
	u: randFloat * umax
	v: ((2 * randFloat) - 1) * vmax
	while [( v * v + (A + 4 * log-e u) * (u * u)) >= 0]
		[u: randFloat * umax v: ((2 * randFloat) -1) * vmax]
	 v / u
]	


;lognormal law
randLognorm: function [a [decimal!] b [decimal!] z [decimal!]] [
	return exp (a + b * z)
]	

; gamma law (e.g 1 1.0)
randGamma: func [k [integer!] l [decimal!]] [
	r: 0.0
	i: 0
	while [i < k] [
		r: r + randExpm l
		i: i + 1
	]
	r
]	

;geometric law in a disc	
randDisc: function []
[
	t: copy []
	u: 2 * randFloat - 1
	v: 2 * randFloat - 1
	
	append t u
	append t v
	while [((u * u) + (v * v)) > 1.0][
		t/1: u t/2: v 
		u: 2 * randFloat - 1
		v: 2 * randFloat - 1
	]
	t
]


;geometric law in a rectangle 

randRect: function [a [decimal!] b [decimal!] c [decimal!] d [decimal!]]
[
	t: copy []
	append t a + (b - a) * randFloat / 2
	append t c + ( d - c) * randFloat / 2
	t
]

;chi square law (e.g 2)
randChi2: function [v [integer!]] [
	z: 0
	i: 0
	while [i < v] [
		z: z + power (randNorm log2pi) 2
		i: i + 1
	]
	z	
] 

; Erlang law (e.g 2)
randErlang: function [n [integer!]] [
	t: 1.0
	i: 0
	while [i < n] [
		t: t * 1.0 - randFloat
		i: i + 1
	]
	negate log-e t
]

;Student law (e.g 3 1.0)
randStudent: function [ n [integer!] z [decimal!]] [
	v: randChi2 n
	z / (square-root (absolute (v / n)))
]


;Fisher law (e.g 1 1)
randFischer: function [ n [integer!] m [integer!]] [
	x: randChi2 n
	y: randChi2 m
	(x /  (n * 1.0)) / (y / (m * 1.0))
]

;Laplace Law (e.g 1.0)
randLaplace: function [a [decimal!]][
	u1: randFloat
	u2: randFloat
	either u1 < a [return negate a * log-e u2] [return a * log-e u2]
]


;beta law (e.g 1 1)
randBeta: function [a [integer!] b [integer!]]
[
	x1: randGamma a 1.0
	x2: randGamma b 1.0
	x1 / (x1 + x2)
]

;Weibull law (e.g 1.0 1.0)
randWeibull: function [a [decimal!] l [decimal!]] [
	x: randFloat
	power (negate 1 / a * log-e (1 - x)) 1 / l
]


; Rayleigh law
randRayleigh: function []
[
	randWeibull 2.0 0.5
]


;********************************************
;***			DISCRETE LAWS			  ***
;********************************************

;Bernouilli law (eg 0.5)
randBernouilli: function [p [decimal!] ] [ 
	u: randFloat	
	either  u < p [return 1][ return 0]
]

;binomial law (e.g. 1 0.5)
randBinomial: function [n [integer!] p [decimal!]] [
	x: 0
	i: 0
	while [i < n][
		if randFloat < p [x: x + 1]
		i: i + 1
	]
	x
]

;binomial negative law (e.g. 1 0.5)
randBinomialneg: function [n [integer!] p [decimal!]] [
	x: 0
	i: 0
	while [i < n] [
		while [randFloat >= p] [x: x + 1]
	i: i + 1
	]
	x
]

;geometric law (e.g. 0.25)
randGeo: func [p [decimal!]] [
	x: 0
	while [randFloat >= p] [ x: x + 1]
	x
]

; Poisson law (e.g. 1.5)
randPoisson: function [l [decimal!]] [
	j: 0.0
	p: f: exp (negate l)
	u: randFloat
	while [u > f ] [
		p: l * p / (j + 1)
		f: f + p
		j: j + 1
	]
	j 
]

;****************** some samples ******************
opencv?: yes
if opencv? [cv: import 'opencv]
img1: make image! reduce [256x256 black]
img2: make image! reduce [256x256 black]
print "Any key to continue"
forall img1 [ 
	v1: to integer! (randFloat) * 255
	v2: to integer! (randFloat) * 255
	v3: to integer! (randFloat) * 255
	t: make tuple! reduce [v1 v2 v3] 
	img1/1: t
] 
img2/rgb: copy sort img1/rgb
if opencv? [
	cv/imshow/name img1 "randFloat"
	cv/waitKey 0
	cv/imshow/name img2 "randFloat Sort"
	cv/waitKey 0]
unless opencv? [
	print "Images saved"
	save %img1.png img1
	save %img2.png img2
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS 
	ask "Return Key"
]
img1: make image! reduce [256x256 black]
img2: make image! reduce [256x256 black]
forall img1 [ 
	v1: to integer! randUnif 0.5 1.0 * 255
	v2: to integer! randUnif 0.5 1.0 * 255
	v3: to integer! randUnif 0.5 1.0 * 255
	t: make tuple! reduce [v1 v2 v3] 
	img1/1: t
] 

img2/rgb: copy sort img1/rgb
if opencv? [
	cv/imshow/name img1 "Uniform"
	cv/waitKey 0
	cv/imshow/name img2 "Uniform Sort"
	cv/waitKey 0
]
unless opencv? [
	print "Images saved"
	save %img1.png img1
	save %img2.png img2
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS 
	ask "Return Key"
]

img1: make image! reduce [256x256 black]
img2: make image! reduce [256x256 black]
forall img1 [ 
	v1: (to integer! randExp * 255) and 255
	v2: (to integer! randExp * 255) and 255
	v3: (to integer! randExp * 255) and 255
	t: make tuple! reduce [v1 v2 v3] 
	img1/1: t
] 

img2/rgb: copy sort img1/rgb
if opencv? [
	cv/imshow/name img1 "Exp"
	cv/waitKey 0
	cv/imshow/name img2 "Exp Sort"
	cv/waitKey 0
]
unless opencv? [
	print "Images saved"
	save %img1.png img1
	save %img2.png img2
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS 
	ask "Return Key"
]

img1: make image! reduce [256x256 black]
img2: make image! reduce [256x256 black]
forall img1 [v1: to integer! (randBinomial 1 0.5) * 255
	t: make tuple! reduce [v1 v1 v1] 
	img1/1: t
] 

img2/rgb: copy sort img1/rgb
if opencv? [
	cv/imshow/name img1 "Binomial"
	cv/waitKey 0
	cv/imshow/name img2 "Binomial Sort"
	cv/waitKey 0
]
unless opencv? [
	print "Images saved"
	save %img1.png img1
	save %img2.png img2
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS 
	ask "Return Key"
]
	
print "Bye"