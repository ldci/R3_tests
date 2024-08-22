#!/usr/local/bin/r3
Rebol [
]
;--This is just a test. 
;--For more about image see https://github.com/Oldes/Rebol-OpenCV

createImage: function [
	bitSize				[integer!]	;--8, 16, 32 or 64-bit
	isize				[pair!]		;--image size as pair!
	channels			[integer!]	;--1 to 4 channels
	return: 			[vector!]	;--image data
][
	width: to integer! isize/x
	height: to integer! isize/y
	size: width * height * channels
	;--bitSize determines the type of image
	switch bitSize [
		8  	[data: make vector! reduce ['char! (size)]]
		16 	[data: make vector! reduce ['integer! (size)]]
		32	[data: make vector! reduce ['integer! (size)]]
		64 	[data: make vector! reduce ['float! (size)]]
	]
	data
]
;********************************* tests ************************************
opencv?: yes	;--is opencv extension used?
iSize: 512x512												;--image size
random/seed now/precise										;--for random values
;--we use Delta-time (dt)
t: dt [
	img1: createImage 64 iSize 1							;--createImage a float image with 1 channel
	n: length? img1											;--image size
	repeat i n [img1/:i: round/to random 1.0 0.01]			;--random values [0..1]
	repeat i n [img1/:i: img1/:i / 1.0 * 255]				;--change to integer range [0..255]
	bin1: copy #{}											;--binary string
	repeat i n [append/dup bin1 to integer! img1/:i 3]		;--integer values for 3 channels
	dest1: make image! reduce [iSize bin1]					;--a grayscale Red image with 3 channels

	img2: createImage 64 iSize 3							;--createImage a float image with 3 channels
	n: length? img2											;--image size
	repeat i n [img2/:i: round/to random 1.0 0.01]			;--random values [0..1]
	repeat i n [img2/:i: img2/:i / 1.0 * 255]				;--change to integer range [0..255]		
	bin2: copy #{}											;--binary string
	foreach [r g b] img2 [
		append append append bin2 to-integer r to-integer g to-integer b
	]
	dest2: make image! reduce [iSize bin2]					;--a rgb Red image with 3 channels
]
print ["Images created in:" third t "sec"]

if opencv? [
	;--OpenCV extension for Rebol3
	cv: import 'opencv
	cv/imshow/name dest1 "Greyscale Image"
	print "Any key to continue"
	cv/waitkey 0
	cv/imshow/name dest2 "Color Image"
	print "Any key to close"
	cv/waitkey 0
]
unless opencv? [
	print "Images saved"
	save %gray.png dest1
	save %color.png dest2
	call/shell "open gray.png"	;--macOS 
	call/shell "open color.png"	;--macOS 
]
