#!/usr/local/bin/r3
REBOL [
]

;--ldci
linSpace: function [
"Generates a vector of spaced numbers over a defined interval"
	a 		[number!] "Start" 
	b 		[number!] "End"
	n	 	[number!] "Number"
][
	step: (absolute a) + (absolute b) / n
    blk: collect [
    	i: a - step 
    	until [keep i: i + step i >= b]
    ]
    make vector! compose/only [f64! (length? blk) (blk)] ;--float 64 for precision
]

;******************** tests **************************
print-horizontal-line
print ["Range -1.0 0.0"]
x: linSpace -1.0 0.0 100
foreach v x [print round/to v 0.01] 

print-horizontal-line
print ["Range 0.0 1.0"]
x: linSpace 0.0 1.0 100
foreach v x [print round/to v 0.01] 

print-horizontal-line
print "Range -1.0 1.0"
x: linSpace -1.0 1.0 200
foreach v x [print round/to v 0.01] 

;--Oldes
linSpace: function [
    "Generates N linearly spaced numbers from a to b (inclusive)."
    a [number!]  "Start"
    b [number!]  "End"
    n [integer!] "Number of samples"
][
    blk: either n < 2 [reduce [a]][
        step: (b - a) / (n - 1)
        collect [
            repeat k n [keep (a + (step * (k - 1)))]
        ]
    ]
    make vector! [f64! :blk]
]

probe linSpace -1.0 0.0 5
;== #(float64! [-1.0 -0.75 -0.5 -0.25 0.0])





