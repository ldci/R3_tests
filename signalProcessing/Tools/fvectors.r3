#!/usr/local/bin/r3
REBOL [ 
	needs: 3.18.1
]


vectRandom: func [v [vector!] value [number!]
"Generate a random signal"
][
	_v: copy v
	repeat i _v/length [_v/:i: random value]
	_v
]

;mean: function [v [vector!] return: [decimal!]][ (sum v) / (v/length)]
;--use standard R3 average function
;--sum and average are supported by Red
stdev: func [v [vector!]
"Standard deviation"
][
	;--we use Bessel's correction (n − 1 instead of n)
	sigma: 0.0
	foreach value v [sigma: sigma + (power (value - average v) 2)]
	sqrt sigma / (v/length - 1)
]

;--another formula for std
stdev2: function [v [vector! block!] return: [decimal!]][
	;--we use Bessel's correction (n − 1 instead of n) 
	_average: average v
	sigma: 0.0
	foreach value v [sigma: sigma + (power (value - _average) 2)]
	n: 1 / (length? v - 1)
	sqrt (sigma * n)
]

median: func [
"Return the sample median"
	sample 		[vector!]
][
	data: sort to block! sample
	n: length? data
	case [
		odd?  n [pick data n + 1 / 2]
		even? n [(pick data n / 2) + (pick data n / 2 + 1) / 2]
	]
]

interquartileRange: func [
	"Return the sample Interquartile Range"
	sample [vector!]
][
    data: sort to-block copy sample
    n: length? data
    Q1: 0.25 * n 		;--(1 / 4)
    Q2: 0.50 * n		;--(2 / 4)
    Q3: 0.75 * n		;--(3 / 4)
    Q4: 1.00 * n		;--(4 / 4)
    Q3 - Q1				;--IQR
]


detrendSignal: func [v [vector!]
"Remove continuous component in signal"
][
	;--basic (x - mean)
	_v: copy v
	_average: average _v
	repeat i _v/length [_v/:i: _v/:i - _average]
	_v
]

normalizeSignal: func [v [vector!]
"Z-score algorithm"
][
	;--use z-Score algorithm (x - mean / standard deviation)
	_v: copy v
	_average: average _v
	_std: stdev _v
	repeat i _v/length [_v/:i: _v/:i - _average / _std]
	_v
]

minMaxNormalization: func [v [vector!]
"Min Max normalization"
][
	;-- use  min-max algorithm (x: x - min / xmax - xmin)
	_v: copy v
	xmin: _v/minimum xmax: _v/maximum
	repeat i _v/length [_v/:i: (_v/:i - xmin) / (xmax - xmin)]
	_v
]

medianFilter: func [v [vector!]
"Median filter"
][
	;--use median filter (x: x - med / IRQ)
	_v: copy v
	med: median _v
	IQR: interquartileRange _v
	repeat i _v/length [_v/:i: (_v/:i - med) / IQR]
	_v
]
