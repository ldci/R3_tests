#!/usr/local/bin/r3
REBOL [ 
] 

bitDivision: function [ 
	n [integer!] 
	m [integer!]
][ 
	res: 0 ;--the quotient is intialized
	neg: 0
	if any [negative? n negative? m] [neg: -1]
	a: absolute n b: absolute m		;--both number postive
	i: 32 
	while [i >= 0][
		;--checking if b multiplied by 2**i is <= a
		if (b << i) <= a [
			a: a - (b << i)		;--subtracting b << i from a
			res: res + (1 << i)	;--adding 2 power i to the result
		]
		i: i - 1
	]
	either neg = 0 [return res] [return negate res]
]




print [bitDivision 100 10]
print [bitDivision 100 -1]
print [bitDivision 100 -10]
print [bitDivision 29 13]
