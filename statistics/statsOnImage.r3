#!/usr/local/bin/r3
Rebol [
	author: @ldci
]
;--based on Oldes's work
cv: import 'opencv
with cv [
	filename: %../pictures/lena.png
	mat: imread/with filename IMREAD_GRAYSCALE	;--read as grayscale image with one channel
	imshow/name mat filename 	;--display the image in the window with file name's title
	moveWindow filename 200x10	;--move window
	vect: get-property mat MAT_VECTOR   
	foreach [property value] query vect object! [
		printf [23] reduce [
			uppercase/part mold to-set-word property 1
			value
		]
	]   
	print "A key to quit"
	waitKey 0
]
