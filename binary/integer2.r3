#!/usr/local/bin/r3
REBOL [ 
] 

binaryData: #{
303064627C5E03006000EF03A105B8007E012001000000006D118613D1110000
0000010084037D051E00B80B803E00030000000000000000E100E2669364CF08
B80B803EEE00881A9C1A6C00E80300808C06000000006400B3041D095623E020
}

;--generic function
makeInt: function [
	bin		[binary!]
	isize	[integer!] ;--1, 2, 4 or 8 for 8, 16, 32 or 64-bit values
][
	n: (length? bin) / isize
	i: 1
	while [i <= n][
		int: to-integer reverse copy/part bin isize
		print [i "[" int "]"]
		bin: skip bin isize
		i: i + 1
	]
]

print "Test"
makeInt binaryData 1
print-horizontal-line
makeInt binaryData 2
print-horizontal-line
makeInt binaryData 4
print-horizontal-line
makeInt binaryData 8
print-horizontal-line