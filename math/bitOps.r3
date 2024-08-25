#!/usr/local/bin/r3
REBOL [ 
] 
bitSum: function [
	n [integer!]
	m [integer!]
][
	a: n b: m
	if all [negative? n negative? m] [a: negate n b: negate m]	
	ssum: a XOR b carry: a AND b
	until [
		carry: carry << 1	;--left shift the carry
		a: ssum				;--initialize a as sum
		b: carry			;--initialize b as carry
		ssum: a XOR b		;--sum is calculated
		carry: a AND b		;--and carry is calculated		
		carry = 0			;--until carry = 0
	]
	if all [negative? n negative? m] [ssum: negate ssum]
	ssum	
]

bitSub: function [
	n [integer!]
	m [integer!]
][
	while [m != 0][
		;should be as in C res: (not n) & m (as integer)
		res: (complement n) & m ;--common set bits of m and unset bits of n		
		n: n XOR m				;--get the difference using XOR and assign it to n
		m: res << 1				;--until m = 0
	]
	n
]


bitMul: function [ 
	n [integer!] 
	m [integer!]
][
	isNegative: false
	result: 0
	if all [n < 0 m < 0] [n: negate n m: negate m]
	if n < 0 [n: negate n isNegative: true]
	if m < 0 [m: negate m isNegative: true]
	while [m > 0]  [
		if (m & 1 = 1) [result: result + n]  
        n: n << 1		;--multiply n by 2
        m: m >> 1		;--divide m by 2         
	]
	either isNegative [negate result] [result]
]

bitDiv: function [
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
	either neg = 0 [return res] [return  negate res]
]


print-horizontal-line
print "bitSum"
print bitSum  +3 +3	;-- +6
print bitSum  +3 -3 ;-- 0
print bitSum  -3 +3 ;-- 0
print bitSum  -3 -3 ;-- -6

print-horizontal-line
print "bitSub"
print bitSub 29 13	;-- +16
print bitSub 13 29	;-- -16
print bitSub 13 13	;-- 0

print-horizontal-line
print "bitMul"
print bitMul 20 13	;-- +260
print bitMul -20 13	;-- -260

print-horizontal-line
print "bitDiv"
print bitDiv 96 7	;-- +13
print bitDiv 96 4	;-- +24
print bitDiv 96 -3	;-- -32
print bitDiv -3 -3	;-- -1

print-horizontal-line




