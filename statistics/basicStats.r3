#!/usr/local/bin/r3
REBOL [ 
	author: @ldci
]

;--2 useful functions in R3: sum and average (for blocks). Only sum for Red
mean: func [
	"Calculates the mean value of a series"
	values [block! vector!] 
][
	sigma: 0.0
	foreach v values [sigma: sigma + v]
	(sigma) / (length? values)
]

;--median adapted from @hiiamboris
median: func [
	"Returns the sample median"
	values [block! vector!]
][
    ;sample: sort copy sample			;--Red sort is not supported by R3
    sample: sort to block! copy values
    n: length? sample
    case [
    	odd? n 	[pick sample n + 1 / 2]
    	even? n [(pick sample n / 2) + (pick sample n / 2 + 1) / 2]
    	n = 0  	[none]
    ]
]

variance: func [
	"Calculates the variance of a series"
	values [block! vector!] 
][
	;mu: mean values			;--Red
	mu: average values			;--mean native R3 func 
	sigma: 0.0
	foreach v values [sigma: sigma + (v - mu ** 2)]
	sigma / (length? values)
]

deviation: func [
	"Calculates the standard deviation of a series"
	values [block! vector!] 
	/population-sd
	/sample-sd 	
][
	;mu: mean values			;--Red
	mu: average values			;--mean native R3 func 
	sigma: 0.0
	foreach v values [sigma: sigma + (v - mu ** 2)]
	if population-sd [return sqrt sigma / (length? values)]
	if sample-sd [return sqrt sigma / ((length? values) - 1)]
]


mode: func [
	"Calculates modal value of a series. Must be improved for bi or multi modal"
	values [block! vector!]
][
	sample: sort to block! copy values
	n: length? sample
	counter: []
	i: count: 1
	key2: sample/(i + 1)	
	while [not none? key2] [
		key1: sample/(i) key2: sample/(i + 1)					;--test keys
		either key1 == key2 
			[count: count + 1]											;--increment count
			[append/only counter reduce [count key1] count: 1] 	;--new entry with count = 1
		i: i + 1 ;-- ++ i
	]
	second last sort counter
]

zscore: func [
	"Calculates zscore values"
	values [block! vector!]
][
	;mu: mean values
	mu: average values
	std: deviation/sample-sd values
	b: []
	foreach v values [append b round/to (v - mu) / std 0.001]
	b
]
;--size in meters
v: make vector! [decimal! 64 [1.62 1.72 1.64 1.7 1.78 1.64 1.65 1.64 1.66 1.74]]
probe v
print-horizontal-line
print ["Length:   " length? v]
print ["Minimum:  " mini: first find-min v]
print ["Maximum:  " maxi: first find-max v]
print ["Range:    " maxi - mini]
print ["Sum:      " sum v]
print ["Mean:     " mean v]
print ["Median:   " median v]
print ["Mode:     " mode v]
print ["Variance: " round/to variance v 0.001]
print ["Deviation:" round/to deviation/population-sd v 0.001]
print ["Deviation:" round/to deviation/sample-sd v 0.001]

print-horizontal-line
v: make vector! [decimal! 32 [0 1 2 3 4 5 6 7 8 9 10]]
print v
print ["Mean:   " average v]
print-horizontal-line
print "Z-score test"
print ["Z-score: " zscore v]
print ["Mean:    " round mean zscore v]
print ["STD:     " round deviation/sample-sd zscore v]
print-horizontal-line