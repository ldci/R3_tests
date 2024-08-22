#!/usr/local/bin/r3
REBOL [
]

;--functions for scalars
remScalar: func [
	v		[vector!]
	value 	[integer!]
][
	_v: make vector! length? v
	repeat i length? v [_v/:i: v/:i % value]
	_v
]

andScalar: func [
	v		[vector!]
	value 	[integer!]
][
	_v: make vector! length? v
	repeat i length? v [_v/:i: v/:i and value]
	_v
]

orScalar: func [
	v		[vector!]
	value 	[integer!]
][
	_v: make vector! length? v
	repeat i length? v [_v/:i: v/:i or value]
	_v
]

xorScalar: func [
	v		[vector!]
	value 	[integer!]
][
	_v: make vector! length? v
	repeat i length? v [_v/:i: v/:i xor value]
	_v
]

rsScalar: func [
	v		[vector!]
	value 	[integer!]
][
	_v: make vector! length? v
	repeat i length? v [_v/:i: v/:i >> value]
	_v
]

lsScalar: func [
	v		[vector!]
	value 	[integer!]
][
	_v: make vector! length? v
	repeat i length? v [_v/:i: v/:i << value]
	_v
]

;--more general function for R3 and Red (op 4 and 5)
lbsScalar: func [
	v		[vector!]
	value 	[integer!]
	op		[word!]
][
	_v: make vector! v/length	;--for Red use length? v
	case [
		op = 'rem 	[repeat i v/length [_v/:i: v/:i % value]]	;--remainder
		op = 'and 	[repeat i v/length [_v/:i: v/:i and value]]	;--logical
		op = 'or    [repeat i v/length [_v/:i: v/:i or value]]	;--logical
		op = 'xor  	[repeat i v/length [_v/:i: v/:i xor value]]	;--logical 
		op = '>> 	[repeat i v/length [_v/:i: v/:i >> value]]	;--bitshift
		op = '<<	[repeat i v/length [_v/:i: v/:i << value]]	;--bitshift
	]
	_v
]

print "Basic Scalar"
v: make vector! [integer! 32 [7 13 42 108]]
print ["v     :" v]
print ["v + 2 :" v  + 2]
print ["v - 2 :" v  - 2]
print ["v * 4 :" v * 4]
print ["v / 4 :" v / 4]
print lf

print "Scalar functions"
v: make vector! [integer! 32 4 [1 2 3 4]]
print ["v      :" v]
print ["Rem    :" remScalar v 2]
print ["And    :" andScalar v 1]
print ["Or     :" orScalar v 1]
print ["Xor    :" xorScalar v 1]
print lf

print "lbsScalar function tests"
v: make vector! [integer! 32 4 [1 2 3 4]]
print ["v      :" v]
print ["%      :" lbsScalar v 2 'rem]
print ["And    :" lbsScalar v 1 'and]
print ["Or     :" lbsScalar v 1 'or]
print ["Xor    :" lbsScalar v 1 'xor]
print [">>     :" lbsScalar v 2 '>>]
print ["<<     :" lbsScalar v 2 '<<]



