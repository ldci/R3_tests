#!/usr/local/bin/r3
REBOL [ 
	needs: 3.18.1
]

;--Thanks to Oldes for corrections in zThresholding function
mmean: func [
	data [block!]
	len  [integer!]			;--for mobile window (lag)
][
	;--don't use R3 sum func since we use mobile windows
	_sum: 0.0
	repeat i len [_sum: _sum + data/:i]
	_sum / len
]

mstdDev: func [
	data [block!]
	len  [integer!]			;--for mobile window (lag)
][
	_average: mmean data len
	sd: 0.0
	repeat i len [sd: sd + power (data/:i - _average) 2]
	sqrt (sd / (len - 1))
]

zThresholding: func [
	data      [block! vector!]
	output    [block! vector!]
	lag       [integer!]
	threshold [decimal!]
	influence [decimal!]
][
	sLength: length? data
	filteredY: copy data
	either type? filteredY = block! [
		avgFilter: array/initial sLength 0.0
		stdFilter: array/initial sLength 0.0
	]
	[
		avgFilter: make vector! reduce ['decimal! 64 sLength]
		stdFilter: make vector! reduce ['decimal! 64 sLength]
	]

	avgFilter/:lag: mmean data lag
	stdFilter/:lag: mstdDev data lag
	i: lag
	while [i < sLength][
		n:   i + 1          ;; index of the next value
		y:   data/:n
		avg: avgFilter/:i
		std: stdFilter/:i

		v1: abs(y - avg)
		v2: threshold * std

		either v1 > v2 [
			;output/:n: pick [1.0 0.0] y > avg
			output/:n: pick [1.0 -1.0] y > avg
			filteredY/:n: (influence * y) + ((1 - influence) * filteredY/:i)
		][
			output/:n: 0.0
		]
		avgFilter/:n: mmean   (at filteredY i - lag) lag
		stdFilter/:n: mstdDev (at filteredY i - lag) lag
		;print [i "avg:" avgFilter/:n "signal:" output/:n]
		++ i
	]
	filteredY
]
