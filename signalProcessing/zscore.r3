#!/usr/local/bin/r3
REBOL [ 
]

;--use standard R3 average function
;--sum and average are supported by Red

vectRandom: function [v [vector! block!] value [number!]
][repeat i length? v [v/:i: random value] v]

stdDev: function [v [vector! block!] return: [decimal!]][
	;--we use Bessel's correction n − 1 instead of n 
	_average: average v
	sigma: 0.0
	foreach value v [sigma: sigma + (power (value - _average) 2)]
	sqrt sigma / ((length? v) - 1)
]

stdDev2: function [v [vector! block!] return: [decimal!]][
	;--we use Bessel's correction n − 1 instead of n 
	_average: average v
	sigma: 0.0
	foreach value v [sigma: sigma + (power (value - _average) 2)]
	n: 1 / ((length? v) - 1)
	sqrt (sigma * n)
]

zScoreNormalize: function [v [vector! block!]
][
	_average: average v
	std: stdDev v
	repeat i length? v [v/:i: v/:i - _average / std]
	v
]
minMaxNormalise: function [v [vector! block!]
][
	mini: first find-min v
	maxi: first find-max v
	mm: make vector! compose [decimal! 32 (length? v)]
	repeat i length? mm [mm/:i: (v/:i - mini) / (maxi - mini)]
	mm
]

;************************ Program *************************
random/seed now/time/precise
v: make vector! compose [decimal! 32 30]
print-horizontal-line
r: vectRandom v 20							;--Gaussian random values
print ["R: " r]
print ["R mean:" round/to average r 0.01]	:--around 10
print ["R std :" round/to stdDev r 0.01] 
print-horizontal-line
z: zScoreNormalize r						;--z-score [-n + n]
print ["Z: " z]
print ["Z mean:" round/to average z 0.01]	;--0.0
print ["Z std :" round/to stdDev z 0.01]	;--1.0
print-horizontal-line
n: minMaxNormalise z						;--min max normalization [0..1]
print ["N: " n]
print ["N mean:" round/to average n 0.01]	;--around 0.5
print ["N std :" round/to stdDev n 0.01]	
print-horizontal-line
;print sort to-block n		;--sort does not work on vector
;print-horizontal-line








 




