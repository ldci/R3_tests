#!/usr/local/bin/r3
Rebol [
]

isMulOverflow?: func [
	a 		[integer!]
	b 		[integer!]
	return: [logic!]
] [
	;if ((a = 0) or (b = 0)) [return false]
	any [a = 0 b = 0] [return false]
	attempt [result:  a * b] 
	either a = (result / b) [return false] [return true] 
]
;--tests
print ["1000 * 5000 Overflow?   :" isMulOverflow? 1000 5000]
print ["-1000 * 1000 Overflow?  :" isMulOverflow? -1000 1000]
print ["740000 * 70000 Overflow?:" isMulOverflow? 740000 70000]
