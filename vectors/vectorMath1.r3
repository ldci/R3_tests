#!/usr/local/bin/r3
REBOL [
]

;--In Red, for integer! and char! vectors, we can use all math and bitwise operators.
;--This not yet the case with R3
;--These R3 functions can also be used with decimal!

;--functions for vectors

addVectors: func [
	v1		[vector!]
	v2		[vector!]
	type 	[word!] ;-- char integer decimal
	bitSize	[integer!]
][
	case  [
		type = 'char 	[v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'integer [v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'decimal [v: make vector! compose [decimal! (bitSize) (v1/length)]]
	]
	repeat i v1/length [v/:i: v1/:i + v2/:i]
	v
]

subVectors: func [
	v1		[vector!]
	v2		[vector!]
	type 	[word!] ; char integer decimal
	bitSize	[integer!]
][
	case  [
		type = 'char 	[v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'integer [v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'decimal [v: make vector! compose [decimal! (bitSize) (v1/length)]]
	]
	repeat i v1/length [v/:i: v1/:i - v2/:i]
	v
]

mulVectors: func [
	v1		[vector!]
	v2		[vector!]
	type 	[word!] ; char integer decimal
	bitSize	[integer!]
][
	case  [
		type = 'char 	[v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'integer [v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'decimal [v: make vector! compose [decimal! (bitSize) (v1/length)]]
	]
	repeat i v/length [v/:i: v1/:i * v2/:i]
	v
]

divVectors: func [
	v1		[vector!]
	v2		[vector!]
	type 	[word!] ;  char integer decimal
	bitSize	[integer!]
][
	case  [
		type = 'char 	[v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'integer [v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'decimal [v: make vector! compose [decimal! (bitSize) (v1/length)]]
	]
	repeat i v1/length [v/:i: v1/:i / v2/:i]
	v
]

remVectors: func [
	v1		[vector!]
	v2		[vector!]
	type 	[word!] ; char integer decimal
	bitSize	[integer!]
][
	case  [
		type = 'char 	[v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'integer [v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'decimal [v: make vector! compose [decimal! (bitSize) (v1/length)]]
	]
	repeat i v1/length [v/:i: v1/:i % v2/:i]
	v
]

andVectors: func [
	v1		[vector!]
	v2		[vector!]
	type 	[word!] ; char integer decimal
	bitSize	[integer!]
][
	case  [
		type = 'char 	[v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'integer [v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'decimal [v: make vector! compose [decimal! (bitSize) (v1/length)]]
	]
	repeat i v1/length [v/:i: v1/:i and v2/:i]
	v
]

orVectors: func [
	v1		[vector!]
	v2		[vector!]
	type 	[word!] ; char integer decimal
	bitSize	[integer!]
][
	case  [
		type = 'char 	[v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'integer [v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'decimal [v: make vector! compose [decimal! (bitSize) (v1/length)]]
	]
	repeat i v1/length [v/:i: v1/:i or v2/:i]
	v
]

xorVectors: func [
	v1		[vector!]
	v2		[vector!]
	type 	[word!] ; char integer decimal
	bitSize	[integer!]
][
	case  [
		type = 'char 	[v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'integer [v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'decimal [v: make vector! compose [decimal! (bitSize) (v1/length)]]
	]
	repeat i v1/length [v/:i: v1/:i xor v2/:i]
	v
]

rightShiftVectors: func [
	v1		[vector!]
	v2		[vector!]
	type 	[word!] ; char integer decimal
	bitSize	[integer!]
][
	case  [
		type = 'char 	[v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'integer [v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'decimal [v: make vector! compose [decimal! (bitSize) (v1/length)]]
	]
	repeat i v1/length [v/:i: v1/:i >> v2/:i]
	v
]

leftShiftVectors: func [
	v1		[vector!]
	v2		[vector!]
	type 	[word!] ; char integer decimal
	bitSize	[integer!]
][
	case  [
		type = 'char 	[v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'integer [v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'decimal [v: make vector! compose [decimal! (bitSize) (v1/length)]]
	]
	repeat i v1/length [v/:i: v1/:i << v2/:i]
	v
]

;--Oldes's comment: when you construct a vector using the make method, you don't have to use the length integer.
print-horizontal-line
print "Vectors"
v1: make vector! [integer! 32 [1 2 3 4]]
v2: make vector! [integer! 32 [5 6 7 8]]

print ["v1 :" v1]
print ["v2 :" v2]
print-horizontal-line
print "with R3 functions"
;--add
print ["Add:" addVectors v1 v2 'integer 32]
;--subtract
print ["Sub:" subVectors v2 v1 'integer 32]
;--multiply
print ["Mul:" mulVectors v1 v2 'integer 32]
;--divide
print ["Div:" divVectors v2 v1 'integer 32]
;--remainder
print ["%  :" remVectors v2 v1 'integer 32]
;--And
print ["And:" andVectors v1 v2 'integer 32]
;--OR
print ["Or :" orVectors v1 v2 'integer 32]
;--Xor
print ["Xor:" xorVectors v1 v2 'integer 32]
print ["r>>:" rightShiftVectors v1 v2 'integer 32]	;--not in Red
print ["l>>:" leftShiftVectors v1 v2 'integer 32]	;--not in Red

print-horizontal-line





