#!/usr/local/bin/r3
REBOL [
]

;--In Red, for integer! and char! vectors, we can use all math and bitwise operators.
;--This not yet the case with R3
;--This R3 function can also be used with decimal!
;--Oldes's comment: when you construct a vector using the make method, you don't have to use the length integer.
;--a more generic and complete functions
opsOnVectors: function [
	v1		[vector!]
	v2		[vector!]
	type 	[word!] ; char integer decimal
	bitSize	[integer!]
	op		[word!]
][
	case  [
		type = 'char 	[v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'integer [v: make vector! compose [integer! (bitSize) (v1/length)]]
		type = 'decimal [v: make vector! compose [decimal! (bitSize) (v1/length)]]
	]
	case [
		op = 'add 	[repeat i v1/length [v/:i: v1/:i + v2/:i]]
		op = 'sub 	[repeat i v1/length [v/:i: v1/:i - v2/:i]]
		op = 'mul 	[repeat i v1/length [v/:i: v1/:i * v2/:i]]
		op = 'div 	[repeat i v1/length [v/:i: v1/:i / v2/:i]]
		op = 'rem 	[repeat i v1/length [v/:i: v1/:i % v2/:i]]
		op = 'and	[repeat i v1/length [v/:i: v1/:i and v2/:i]]	
		op = 'or	[repeat i v1/length [v/:i: v1/:i or v2/:i]]
		op = 'xor	[repeat i v1/length [v/:i: v1/:i xor v2/:i]]
		op = '>>	[repeat i v1/length [v/:i: v1/:i >> v2/:i]]
		op = '<<	[repeat i v1/length [v/:i: v1/:i << v2/:i]]
	]
	v
]

print-horizontal-line
print "opsOnVectors R3 function"
v1: make vector! [integer! 32 [1 2 3 4]]
v2: make vector! [integer! 32 [5 6 7 8]]
print ["v1 :" v1]
print ["v2 :" v2]

print ["Add:" opsOnVectors v1 v2 'integer 32 'add]
print ["Sub:" opsOnVectors v2 v1 'integer 32 'sub]
print ["Mul:" opsOnVectors v1 v2 'integer 32 'mul]
print ["Div:" opsOnVectors v1 v2 'integer 32 'div]
print ["Div:" opsOnVectors v1 v2 'decimal 32 'div]
print ["%  :" opsOnVectors v1 v2 'integer 32 'rem]
print ["And:" opsOnVectors v1 v2 'integer 32 'and]
print ["Or :" opsOnVectors v1 v2 'integer 32 'or]
print ["Xor:" opsOnVectors v1 v2 'integer 32 'xor]
print ["r>>:" opsOnVectors v1 v2 'integer 32 '>>]	;--not in Red
print ["l<<:" opsOnVectors v1 v2 'integer 32 '<<]	;--not in Red
print-horizontal-line

;-Gurzgri's test
v1: make vector! [integer! 64 [1 1 1 1]]
v2: make vector! [integer! 64 [1 2 3 4]]
probe opsOnVectors v1 v2 'integer 64 '<<    ;== make vector! [integer! 64 4 [2 4 8 16]]
probe opsOnVectors v1 v2 'integer 64 '>>	;== make vector! [integer! 64 4 [0 0 0 0]]        
probe reduce [1 >> 1 1 >> 2 1 >> 3 1 >> 4]  ;== [0 0 0 0] as expected  
print-horizontal-line  