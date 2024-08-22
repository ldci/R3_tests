#!/usr/local/bin/r3
REBOL [ 
]

random/seed now/time/precise

randDecimal: function [
"returns a decimal value beween 0 and 1. Base 16 bit" 
][
	x: random power 2 16
	x / power 2 16
]
repeat i 100 [
	print ["Function:" randDecimal]
	print ["Rebol r3:" random 1.0]
]

