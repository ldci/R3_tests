#!/usr/local/bin/r3
REBOl [
	title: "Rosetta code: Ackermann"
    file:  %ackermann.r3
    url:   https://rosettacode.org/wiki/Ackermann_function#Rebol
    needs: 3.16.0
]

ackermann: func [m n] [
    case [
        m = 0 [n + 1]
        n = 0 [ackermann m - 1 1]
        true [ackermann m - 1 ackermann m n - 1]
    ]
] 

for m 0 3 1 [
	for n 0 6 1 [
		prin [ackermann m n " "] 
	]
	print ""
]

;* Output is the first 4x7 Ackermann's numbers.
;*   1 2 3 4 5 6 7
;*   2 3 4 5 6 7 8
;*   3 5 7 9 11 13 15
;*   5 13 29 61 125 253 509

