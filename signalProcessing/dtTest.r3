#!/usr/local/bin/r3
REBOL [
]

;--dt tests
precision: 0.001	;--for rounding
n: 9

repeat i n [
	tt: dt [
		random/seed now/time/precise
		vector: make vector! reduce ['decimal! 32 1024]
		forall vector [vector/1: random 128.0]
		;wait 0.01
	]
	print rejoin [" vector " i ": " round/to third tt * 1000 precision " ms"]
]





