#!/usr/local/bin/r3
REBOL [
]
;--test native Rebol 3 functions
opencv?: yes	;--is opencv extension used?
srgb: load %../pictures/in.png					;--use your own image
dst1: make image! srgb/size						;--create image 1
dst2: make image! srgb/size						;--create image 2
n: length? srgb									;--image size in pixels
print srgb/size									;--image size as pair!
;--delta-time function
print dt [
	;--these functions are pixel-based
	repeat i n [dst1/:i: rgb-to-hsv srgb/:i]	;--to HSV from RGB
	repeat i n [dst2/:i: hsv-to-rgb dst1/:i]	;--to RGB from HSV
]
;--for image visualisation
if opencv?[
	cv: import opencv								;--we use opencv module
	cv/imshow/name dst1	"RGB --> HSV"				;--show hsv image
	cv/waitkey 0									;--wait for a key
	cv/imshow/name dst2	"HSV --> RGB"				;--show rgb image
	cv/waitkey 0									;--wait for a key
	cv/destroyAllWindows							;--destroy all created windows		
]
unless opencv? [
	print "Images saved"
	save %hsv.png dst1
	save %rgb.png dst2
	call/shell "open hsv.png"	;--macOS 
	call/shell "open rgb.png"	;--macOS 
]