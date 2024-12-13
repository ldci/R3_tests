#!/usr/local/bin/r3
REBOL [ 
]


vectRandom: func [v [vector!] value [number!]
][
	_v: copy v
	repeat i _v/length [_v/:i: random value]
	_v
]

;mean: function [v [vector!] return: [decimal!]][ (sum v) / (v/length)]
;--use standard R3 average function
;--sum and average are supported by Red
stddev: func [v [vector!]
"Standard deviation"
][
	sigma: 0.0
	foreach value v [sigma: sigma + (power (value - average v) 2)]
	sqrt sigma / ((v/length) - 1)
]

median: func [
"Median value"
	signal 		[vector!]
][
	sorted: to-block copy signal
	sort sorted
	n: length? sorted
	if odd?  n [idx: (n + 1) / 2 val: sorted/:idx]
	if even? n [idx: n / 2 v1: sorted/:idx v2: sorted/(idx + 1) val: (v1 + v2) / 2]
	val
]
interquartileRange: func [
	"Return the sample interquartile Range"
	sample [vector!]
][
    data: sort to-block copy sample
    n: length? data
    Q1: 0.25 * n 		;--(1 / 4)
    Q3: 0.75 * n		;--(3 / 4)
    Q3 - Q1
]
;;--Hiiamboris solution for median
_median: function [
	"Return the sample median"
	sample [block! hash! vector!]
][
    sample: sort copy sample
    n: length? sample
    case [
    	odd? n [pick sample n + 1 / 2]
    	n = 0  [none]
    	'even  [(pick sample n / 2) + (pick sample n / 2 + 1) / 2]
    ]
]

detrendSignal: func [v [vector!]
"Remove continuous component in signal"
][
	_v: copy v
	repeat i _v/length [_v/:i: _v/:i - average _v]
	_v
]

normalizeSignal: func [v [vector!]
"Z-score algorithm"
][
	;--use z-Score algorithm (x - mean / standard deviation)
	_v: copy v
	_average: average _v
	_std: stddev _v
	repeat i _v/length [_v/:i: _v/:i - _average / _std]
	_v
]

minMaxNormalization: func [v [vector!]
"Min Max normalization"
][
	;-- use  min-max algorithm (x: x - min / xmax - xmin)
	_v: copy v
	xmin: _v/minimum xmax: _v/maximum
	repeat i _v/length [ _v/:i: (_v/:i - xmin) / (xmax - xmin)]
	_v
]

medianFilter: func [v [vector!]
"Median filter"
][
	_v: copy v
	med: median _v
	IQR: interquartileRange _v
	repeat i _v/length [_v/:i: (_v/:i - med) / IQR]
	_v
]
