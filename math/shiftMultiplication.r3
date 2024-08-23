#!/usr/local/bin/r3
REBOL [ 
] 
_multiply: function [ 
	n [integer!] 
	m [integer!]
][ 
    result: count: 0 
    if all [n < 0 m < 0] [n: negate n m: negate m] ;--for both negative values
    while [m <> 0]
    [ 
        ;--check for set bit and left  and shift n with count 
        if (m % 2 == 1) [result: result +  (n << count)] 
        count: count + 1 		;--increment of place value (count)
        m: to-integer m / 2
    ] 
    result 
] 

__multiply: function [ 
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

russianPeasant: function [
	n [integer!]
	m [integer!]
][
 	result: 0 ;--initialize result
 	if all [n < 0 m < 0] [n: negate n m: negate m]
   	;--While second number doesn't become 1
    while [m > 0][
       	;--If second number becomes odd, add the first number to result
       	if (m & 1 = 1) [result: result + n]
       	;--Double the first number and halve the second number
        n: n << 1	;--multiply n by 2
        m: m >> 1	;--divide m by 2
    ]
    result
]

print-horizontal-line
print "First function"
print ["Expected:" 18 * 2]
print ["Expected:" 18 * 2]
print ["Expected:" 20 * 13]
print ["Result  :" _multiply 20 13]
print ["Expected:" -20 * 13]
print ["Result	:" _multiply -20 13]
print ["Expected:" -20 * -13]
print ["Result  :" _multiply -20 -13]

print-horizontal-line
print "Second function"
print ["Expected:" 18 * 2]
print ["Expected:" 18 * 2]
print ["Expected:" 20 * 13]
print ["Result  :" __multiply 20 13]
print ["Expected:" -20 * 13]
print ["Result  :" __multiply -20 13]
print ["Expected:" -20 * -13]
print ["Result  :" __multiply -20 -13]


print-horizontal-line
print "Russian Peasant"
print ["Expected:" 18 * 2]
print ["Result  :" russianPeasant 18 2]
print ["Expected:" 20 * 13]
print ["Result  :" russianPeasant 20 13]
print ["Expected:" -20 * 13]
print ["Result  :" russianPeasant -20 13]
print ["Expected:" -20 * -13]
print ["Result  :" russianPeasant -20 -13]
print-horizontal-line


