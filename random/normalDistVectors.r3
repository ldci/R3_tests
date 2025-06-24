#!/usr/local/bin/r3
REBOL [ 
	author: @ldci
] 
{
 * Based on RosettaCode example: Statistics/Normal distribution
 * Adapted from C. Rebol and Red are one-based.
}

RAND_MAX: 2147483647 ;--max integer value 
NMAX: 500000

stddev: function [values [vector!] 
][
	mu: average values		;--mean native R3 function 
	sigma: 0.0
	foreach v values [sigma: sigma + ((v - mu) * (v - mu))]
	sqrt sigma / ((length? values) - 1)
]

;--Normal random numbers generator - Marsaglia algorithm.
gaussian: function [] [
	rsq: 0.0
	while [any [(rsq >= 1.0) (rsq == 0.0)]][
		x: (2.0 * random RAND_MAX) / RAND_MAX - 1.0
		y: (2.0 * random RAND_MAX) / RAND_MAX - 1.0
		rsq: (x * x) + (y * y) 
	]
	f: sqrt ((-2.0 * log-e rsq) / rsq)
	reduce [x * f y * f]
]

;--Generate 2 independent series of random values (0.0 1.0)
generate: function [n [integer!] 
] [
	m: n + n
	values: make vector! compose [f64! (m)]
	i: 1
	while [i <= m] [
        values/(i): first gaussian 
        values/(i + 1): second gaussian
		i: i + 2
	]
	values
]
;--Show histogram
printHistogram: function [values [vector!]] [
	width: 50.0
	low: -3.0
	high: 3.0
	delta: 0.1
	maxi: 0
	n: length? values							;--length of block
	nbins: to integer! ((high - low) / delta)	;--number of classes in histogram (60)
	bins: make vector! compose [u32! (nbins)]	;--bins vector								
	repeat i n [
		j: to integer! ((values/:i - low) / delta)
		if all [(j >= 1) (j <= nbins)] [bins/:j: bins/:j + 1] 	;--inc bins counter
	]
	maxi: bins/maximum											;--get maximal value
	repeat j nbins [
		lbin: round/to (low + j * delta - high + 0.25) 0.01		;--low limit for the classe
		hbin: round/to (low + j + 1 * delta - high + 0.25) 0.01	;--high limit for the classe
		s: ajoin ["[" lbin " " hbin "] "]
		pad s -15												;--pad left for string alignment
		k: width * bins/:j / maxi								;--number of chars
		while [k > 0] [append s to-char 9609 -- k]
		append s ajoin [" " round/to (bins/:j * 100 / n) 0.01 "%"]
		print s
	]
]

;********************** Main ***********************
print  "Be patient! Generating Data and Gaussian Histogram..."
print-horizontal-line
t: dt [
	values: generate NMAX
	printHistogram values
]
print-horizontal-line
print [ NMAX * 2 "Values processed in:"  round/to third t 0.01 "sec"]
print  ["Mean: " round abs average values]
print  ["STD : " round stddev values]
print-horizontal-line

