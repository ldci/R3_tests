#!/usr/local/bin/r3
REBOL [ 
] 
{
 * Based on RosettaCode example: Statistics/Normal distribution
 * This version allows to use mean and standard deviation 
 * for generating different Gaussian distributions
}

RAND_MAX: 2147483647 ; max int
NMAX: 500000;10000000

mean: function [values [block! vector!] return: [decimal!]][
	abs (sum values) / (length? values) ;--R3 specific for sum
]

stddev: function [values [block! vector!] return: [decimal!]][
	average: mean values
	sigma: 0.0
	foreach v values [sigma: sigma + ((v - average) * (v - average))]
	sqrt sigma / ((length? values) - 1)
]

gaussian: function [mean [decimal!] stdev [decimal!] /x /y return:[decimal!]
][
	rsq: 0.0
	while [any [(rsq >= 1.0) (rsq == 0.0)]][
		x: (2.0 * random RAND_MAX) / RAND_MAX - 1.0
		y: (2.0 * random RAND_MAX) / RAND_MAX - 1.0
		rsq: (x * x) + (y * y) 
	]
	f: sqrt ((-2.0 * log-e rsq) / rsq)
	case [
		x [return mean + x * f * stdev]
		y [return mean + y * f * stdev]
	]
]


;Normal random numbers generator - Marsaglia polar algorithm.
generate: function [n [integer!] return: [block!]] [
	m: n + (n % 2)
	values: copy []
	i: 1
	while [i < m] [
		append values gaussian/x 0.0 1.0
        append values gaussian/y 0.0 1.0
		i: i + 2
	]
	values
]

printHistogram: function [values [block! vector!]] [
	width: 50.0
	low: -3.0
	high: 3.0
	delta: 0.1
	maxi: 0
	n: length? values							;--length of block
	nbins: to-integer ((high - low) / delta)	;--number of classes in histogram (60)
	bins: array/initial nbins 0					;--classes array with 0 
	
	i: 1
	while [i <= n][
		j: to-integer ((values/:i - low) / delta)
		if all [(1 <= j) (j < nbins)] [bins/:j: bins/:j + 1] 	;--inc bins counter
		++ i
	]
	j: 1
	while [j <= nbins] [if maxi < bins/:j [maxi: bins/:j] ++ j]	;--get maximal value
	
	j: 1
	while [j <= nbins] [
		lbin: round/to low + j * delta 0.001			;--low limit for the classe
		hbin: round/to low + (j + 1) * delta 0.001		;--high limit for the classe		
		s: rejoin ["[" lbin " " hbin "] "]
		pad s -17	;--pad left
		k: to-integer (width * to-decimal bins/:j / to-decimal maxi) ;--number of chars
		while [k >= 0] [append s to-char 9609 -- k]
		append s rejoin [" " round/to (bins/:j * 100.0 / n) 0.01 "%"]
		print s
		++ j
	]
]

;********************** Main ***********************
random/seed now/time
print ["Generating" NMAX "random values!"]
t: dt [
	values: generate NMAX
	print  ["Mean: " round mean values]
	print  ["STD : " round stddev values]
	print  "Generating Gaussian Histogram" 
	printHistogram values
]
print [as-yellow NMAX as-yellow "values in:" as-red third t as-red "sec"]
