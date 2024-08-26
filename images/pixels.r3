#!/usr/local/bin/r3
REBOL [ 
] 

;--test R2 compatibility (https://www.rebol.com/docs/image.html)

im1: load %../pictures/lena.png

xy?: func [image [image!]
][
	;--zero-based and not one-based
	x: to-integer (index? image) - 1 // image/size/x  	;--for R3 decimal values in pair
	y: to-integer (index? image) - 1 / image/size/x		;--for R3 decimal values in pair
	as-pair x y
]

;--getting pixel values
print-horizontal-line
print first im1
print second im1
print last im1
print first skip im1 10
print first skip im1 10x10

print-horizontal-line
i1: make image! 100x100
probe xy? i1 			;--result is 0x0
probe xy? next i1 		;--result is 1x0 
probe xy? skip i1 5x5 	;--result is 5x5 
probe xy? tail i1 		;--result is 0x100 
probe xy? back tail i1 	;--result is 99x99

print-horizontal-line
i1: make image! 5x5
random/seed now/time/precise
repeat i length? i1 [i1/:i: random white]	;--randomized image
forall i1 [print [xy? i1 first i1]]			;--coordinates and values		

print-horizontal-line
i1: make image! 100x100
print ["Length before:" length? i1]
remove/part i1 100							;--remove first line
remove/part at i1 0x10 100 					;--remove 100 pixels from line 10
print ["Length after :" length? i1]

print-horizontal-line
;--find
i2: make image! 2x1
change i2 red
change next i2 yellow 
print [pos: first find i2 red]
print [pos: first find i2 yellow]
;pos: find i1 i2 mot supported in R3

print-horizontal-line
;--binary
i1: make image! 100x100
bin: to-binary i1 							;--binary series of bytes in the BGRA order
i2:  to-image bin
print ["Image Size:" i2/size]				;--temporary size assigned to the resulting image
i2/size: i1/size
print ["Image Size:" i2/size]				;--specify the width and height of the image

print-horizontal-line
;--mold is OK
mold i1		; like probe
mold/all i1 ; no MAKE code