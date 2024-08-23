#!/usr/local/bin/r3
REBOL [ 
] 
;--Multiplying 
print "Multiplying"
print ["200 *   2: " 200 << 1]
print ["200 *   4: " 200 << 2]
print ["200 *   8: " 200 << 3]
print ["200 *  16: " 200 << 4]
print ["200 *  32: " 200 << 5]
print ["200 *  64: " 200 << 6]
print ["200 * 128: " 200 << 7]
print ["200 * 256: " 200 << 8]


;--Dividing 
print "Dividing"
print["200 /   2: " 200 >> 1]
print["200 /   4: " 200 >> 2]
print["200 /   8: " 200 >> 3]
print["200 /  16: " 200 >> 4]
print["200 /  32: " 200 >> 5]
print["200 /  64: " 200 >> 6]
print["200 / 128: " 200 >> 7]
print["200 / 256: " 200 >> 8]


;--Modulo n with 2  n % 2 == n & 1

print "Parity"
parity: function [n [integer!]]
[
	either n and 1 == 0 [print [n " is an even number"]] 
	[print [n " is an odd number"]]
]

parity 20
parity 21

isPowerOfTwo: function [n [integer!]]
[
	print (n > 0) & ((n & (n - 1)) == 0)
]

isPowerOfTwo 4
isPowerOfTwo 5


;Getting xth bit of n: (n >> x) & 1
print"Binary"
print [10 ":" to-binary 10]
prin [10 ": "]
prin((10 >> 1) and 1)
prin((10 >> 2) and 1)
prin((10 >> 3) and 1)
print((10 >> 4) and 1)

print dt ["200 * 256: " 200 << 8]
print dt ["200 * 256: " 200 * 256]