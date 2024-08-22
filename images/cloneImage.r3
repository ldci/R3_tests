#!/usr/local/bin/r3
REBOL [
]

cloneImage: function [
"Returns a copy of source image"
	src 	[image!] 
	return: [image!]
][
	dst: make image! src/size
	copy src dst
	dst
]
print-horizontal-line
i1: make image! 100x100
i2: cloneImage i1
prin as-red "image 1 = image 2 = " print as-green (i1 = i2)
print-horizontal-line
