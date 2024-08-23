#!/usr/local/bin/r3
REBOL [ 
] 
;--https://www.convertworld.com/fr/temps/millisecondes.html
;1000 (10 ** 3)				;ms
;1 000 000 (10 ** 6)		;µs			
;1 000 000 000 (10 ** 9)	;ns

print-horizontal-line
print "dt infix operators"
t: dt [
	print (1 + 2 * 3)
	print ((1 + 2) / 3)
]
print t
prin [third t * (10 ** 3)  "ms ("]
prin [third t * (10 ** 6) "µs)"]
print ["" third t * (10 ** 9) "(ns)"]

print-horizontal-line
print "dt functional operators"
t: dt [
	print (multiply add 1 2 3)
	print (divide add 1 2 3)
]
print t
prin [third t * 1000 "ms ("]
prin [third t * 1000000 "µs)"]
print ["" third t * 1000000000 "(ns)"]
print-horizontal-line