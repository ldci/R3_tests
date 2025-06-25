#!/usr/local/bin/r3
REBOL [ 
	author: @ldci
]

;--2 useful functions in R3: sum and average (for blocks). Only sum for Red
mean: function [
	"Calculates the mean value of a series"
	values [block! vector!] 
][
	sigma: 0.0
	foreach v values [sigma: sigma + v]
	(sigma) / (length? values)
]

;--median adapted from @hiiamboris
median: function [
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

variance: function [
	"Calculates the variance or the standard deviation of a series"
	values [block! vector!] 
	/std
][
	mu: mean values			;--Red
	;mu: average values		;--mean native R3 function 
	sigma: 0.0
	foreach v values [sigma: sigma + ((v - mu) * (v - mu))]
	either std [sqrt sigma / ((length? values) - 1)] [sigma / (length? values)]
]


mode: function [
	"Calculates modal value of a serie. Must be improved"
	values [block! vector!]
][
	sample: sort to block! copy values
	n: length? sample
	counter: make map!
	i: count: 1
	key2: sample/(i + 1)	
	while [not none? key2] [
		key1: sample/(i) key2: sample/(i + 1)					;--test keys
		either key1 == key2 
			[++ count]										;--increment count
			[append/only counter reduce [count key1] count: 1] 	;--new entry with count = 1
		++ i
	]
	fourth to block! counter
]

zscore: function [
	"Calculates zscore values"
	values [block! vector!]
][
	mu: mean values
	std: variance/std values
	b: []
	foreach v values [append b (v - mu) /std]
	b
]
;--size in meters
v: make vector! [decimal! 64 [1.62 1.72 1.64 1.7 1.78 1.64 1.65 1.64 1.66 1.74]]
probe v
print ["Type:    " v/type]
print ["Size:   " v/size]		;--bit-size
print ["Signed: " v/signed]		;--for integer
print ["Length: " v/length]
print ["Minimum: " v/minimum]
print ["Maximum: " v/maximum]
print ["Range:   " v/maximum - v/minimum]
print ["Sum:     " sum v]
print ["Mean:    " mean v]
print ["Median:  " median v]
print ["Mode:    " mode v]
print ["Variance:" variance v]
print ["STD:     " variance/std v]


v: make vector! [decimal! 64 [0 1 2 3 4 5 6 7 8 9 10]]
print v
print ["Mean:    " mean v]
print ["Zscore: " zscore v]
