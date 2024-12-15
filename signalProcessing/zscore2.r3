#!/usr/local/bin/r3
REBOL [ 
	needs: 3.18.1
]

do %Tools/fvectors.r3						;--functions  for vectors
;************************ Program *************************
random/seed now/time/precise
v: make vector! compose [decimal! 32 30]
print-horizontal-line
r: vectRandom v 100							;--Gaussian random values
print ["R: " r]
print ["R mean:" round/to average r 0.01]	
print ["R std :" round/to stdev r 0.01] 
print-horizontal-line
z: normalizeSignal r						;--z-score [-n + n]
print ["Z: " z]
print ["Z mean:" round/to average z 0.01]	;--0.0
print ["Z std :" round/to stdev z 0.01]		;--1.0
print-horizontal-line
n: minMaxNormalization z					;--min max normalization [0..1]
print ["N: " n]
print ["N mean:" round/to average n 0.01]	;--around 0.5
print ["N std :" round/to stdev n 0.01]	
print-horizontal-line
;print sort to block! n		;--sort does not work on vector
;print-horizontal-line








 




