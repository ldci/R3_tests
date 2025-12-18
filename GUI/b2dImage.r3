#!/usr/local/bin/r3
Rebol [
	title: "Basic Blend2D extension test"
]
b2d: 	import 'blend2d
cv: 	import 'opencv


loadImage: does [
	fileName: request-file/title/filter "Select an image" [%jpg %jpeg %png]
	unless none? fileName [im: b2d/image fileName]
]

code: [
	image :im 40x40 400x400
]
loadImage
win: "GUI Buttons Test"
img: draw 480x480 :code
cv/imshow/name img fileName
cv/movewindow fileName 250x10
print "Any key to close"
cv/waitkey 0