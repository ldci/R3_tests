#!/usr/local/bin/r3
REBOL [
]


_++: func [
	x [number! money! pair!]
	/value
	c [number! money! pair!]
]
[ 
	either value [x: x + c] [x: x + 1]
]

_--: func [
	x [number! money! pair!]
	/value
	c [number! money! pair!]
]
[ 
	either value [x: x - c] [x: x - 1]
]

+=: func [
	x [number! money! pair!]
	y [number! money! pair!]
]
[ 
	x + y
]

-=: func [
	x [number! money! pair!]
	y [number! money! pair!]
]
[ 
	x - y
]

*=: func [
	x [number! money! pair!]
	y [number! money! pair!]
]
[ 
	x * y
]

d=: func [
	x [number! money! pair!]
	y [number! money! pair!]
]
[ 
	x / y
]


print-horizontal-line
print "++ test"
x: 10.0
print _++ x				;--11	
print _++/value x 4		;--14
print _++/value x -4		;--6

print-horizontal-line
print "-- test"
x: 10.0
print _-- x				;--9
print _--/value x 4		;--6
print _--/value x -4		;--14

print-horizontal-line
print "Money tests"
x: $1000.0
print _++ x
print _++/value x 20
print _-- x
print _--/value x 100

print-horizontal-line
print "Pair tests"
x: 10x10
print _++ x
print _++/value x 20
print _-- x
print _--/value x 6
print _--/value x 6x5

print-horizontal-line
print "Operators"
print += 10 5
print -= 10 5
print *= 10 5
print d= 10 5
print-horizontal-line




