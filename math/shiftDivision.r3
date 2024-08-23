#!/usr/local/bin/r3
REBOL [ 
] 

bitDivision: function [ 
	n [integer!] 
	m [integer!]
][ 
	result: 0
	isNegative: false
	if any [n < 0] [m < 0] [isNegative: true]
	n: abs n
	m: abs m
	repeat i 32 [
		if ((m << i) <= n) [
			n: n - (m << i)
			result: result + 1
		]
	]
	either isNegative [result * -1] [result]
]

print [bitDivision 100 10]
x: 100 n: 10
print (x + ((x >> 31) & ((1 << n) + (x - 1)))) >> n