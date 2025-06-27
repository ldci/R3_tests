#!/usr/local/bin/r3
REBOL [ 
	author: [@ldci @oldes]
]

RAND_MAX: 2147483647 ;--max integer value 
NMAX: 500000

;--Generates 2 independent series of random values [-1.0 1.0]
;--to create a gaussian 
generate: function [n [integer!] 
][
	m: n * 2
	values: make vector! compose [f64! (m)]
	;values: make vector! [f64! :m]
	for i 1 m 2 [
        rsq: 0.0
		while [any [(rsq >= 1.0) (rsq == 0.0)]][
			x: (2.0 * random RAND_MAX) / RAND_MAX - 1.0
			y: (2.0 * random RAND_MAX) / RAND_MAX - 1.0
			rsq: (x * x) + (y * y) 
		]
		f: sqrt ((-2.0 * log-e rsq) / rsq)
		values/(i): x * f
		values/(i + 1): y * f
	]
	values
]

t: dt [values: generate NMAX]
;--Oldes
foreach [property value] query values object! [
	printf [23] reduce [
		uppercase/part mold to-set-word property 1
		value
	]
]

print ["Values processed in:"  round/to third t 0.01 "sec"]