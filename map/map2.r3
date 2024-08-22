#!/usr/local/bin/r3
REBOL [ 
] 
;-- we can also use blocks in map
m1: #[
	1 [print "Red" ]
	2 [print "Rebol"] 
	3 [print "C"] 
	4 [print "Python"] 
	5 [print "Java"]
]

repeat i 5 [do select m1 i]
print lf

;--with words and code
m1: #[
	red 	[print uppercase "Red" ]
	rebol 	[print lowercase "Rebol"] 
	c 		[print "C"] 
	python 	[print random "Python"] 
	java 	[print next "Java"]
]

do select m1 'red
do select m1 'rebol
do select m1 'c
do select m1 'python
do select m1 'java


