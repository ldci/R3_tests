#!/usr/local/bin/r3
REBOL [ 
] 

;--extract integer from binary string
;--NOTE: The code is created under macOS (little-endian). 
;--Probably you need to change the order for big-endian CPU.


binaryData: #{
303064627C5E03006000EF03A105B8007E012001000000006D118613D1110000
0000010084037D051E00B80B803E00030000000000000000E100E2669364CF08
B80B803EEE00881A9C1A6C00E80300808C06000000006400B3041D095623E020
}

;--Red/R3 code

makeInt8: function [
	bin 		[binary!] 
][
	i: 0
	foreach [v] bin [
		int8: v and 255			;--8-bit integer value
		print [i int8]
		i: i + 1
	]
]

makeInt16: function [
	bin 		[binary!] 
][
	i: 0
	foreach [lo hi] bin [
		int16: lo or (hi << 8)		;--16-bit integer value
		print [i "[" lo hi "]" int16]
		i: i + 2
	]
]


makeInt32: function [
	bin 		[binary!] 
][
	i: 0
	foreach [b1 b2 b3 b4] bin [
		int32: (b1 << 24) or (b2 << 16) or (b3 << 8) or b4
		print [i "[" b1 b2 b3 b4 "]" int32]
		i: i + 4
	]
]

makeInt64: function [
	bin 		[binary!] 
][
	i: 0
	foreach [b1 b2 b3 b4 b5 b6 b7 b8] bin [
		int64: (b1 << 0) or (b2 << 8) or (b3 << 16) or (b4 << 24) or 
		(b5 << 32) or (b6 << 40) or (b7 << 48) or (b8 << 56)
		print [i "[" b1 b2 b3 b4 b5 b6 b7 b8 "]" int64]
		i: i + 8
	]
]

print-horizontal-line
print "8-Bit Integer"
makeInt8 binaryData 
print-horizontal-line
print "16-Bit Integer"
makeInt16 binaryData
print-horizontal-line
print "32-Bit Integer"
makeInt32 binaryData
print-horizontal-line
print "64-Bit Integer"
makeInt64 binaryData
