#!/usr/local/bin/r3
REBOL [ 
	author: @oldes
]

vect: #(float64! [1.62 1.72 1.64 1.7 1.78 1.64 1.65 1.64 1.66 1.74])
;; doing just some pretty output...
foreach [property value] query vect object! [
	printf [23] reduce [
		uppercase/part mold to-set-word property 1
		value
	]
]
comment [print-horizontal-line
print query vect [median population-deviation]
print query vect [:min :max :range]
print vect/sample-deviation
print-horizontal-line]