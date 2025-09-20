#!/usr/local/bin/r3
REBOl [
	title: "Rosetta code: Barnsley Fern"
    file:  %barnsley.r3
]
;https://rosettacode.org/wiki/Barnsley_fern
;--ldci

barnsleyFern: function [size [pair!]
][
	img: make image! reduce [size black]
	p: 0x0 x: y: 0.0
	
	repeat i 100000 [
		xt: yt: 0.0
		r: random 100
		case [
			r <= 1 [xt: 0.0 yt: 0.16 * y]
			r <= 8 [xt: (0.20 * x) - (0.26 * y)  yt: (0.23 * x) + (0.22 * y) + 1.60]
			r <= 15[xt: (-0.15 * x) + (0.28 * y) yt: (0.26 * x) + (0.24 * y) + 0.44]
			r > 15 [xt: (0.85 * x) + (0.04 * y)  yt: (-0.04 * x) + (0.85 * y) + 1.60]
		]
		x: xt y: yt
    	p/x: to-integer round (img/size/x / 2 + (60 * x))					
    	p/y: to-integer img/size/y - round (60 * y)				
		change at img p green
	]
] 

img: barnsleyFern 640x640
cv: import 'opencv
cv/imshow/name img "Barnsley Fern"
cv/waitKey 0


 
