#!/usr/local/bin/r3
REBOL [ 
] 

hsb2Rgb: function [
	hue		[number!]	;--hue [0..1]
	sat 	[number!]	;--saturation [0..1]
	bri		[number!] 	;--brightness [0..1]
	return: [tuple!]
][
	color: make tuple! reduce [255 255 255]
	u: to-integer bri * 255 + 0.5
	if sat = 0.0 [color/1: color/2: color/3: u]
	hf: (hue - round/floor hue) * 6 ;--6 quadrants
	h: to-integer hf
	f: hf - round/floor hf
	p: to-integer (bri * (1 - sat) * 255 + 0.5)
	q: to-integer (bri * (1 - (sat * f)) * 255 + 0.5)
	t: to-integer (bri * (1 - (sat * (1 - f))) * 255 + 0.5)
	switch h [
		0 [color/1: u color/2: t color/3: p]
		1 [color/1: q color/2: u color/3: p]
		2 [color/1: p color/2: u color/3: t]
		3 [color/1: p color/2: q color/3: u]
		4 [color/1: t color/2: p color/3: u]
		5 [color/1: u color/2: p color/3: q]
	]
	color
]


colorWheel: function [
	radius	[integer!]
	return: [image!]
][
	tau: pi * 2.0
	imsize: as-pair radius * 2 radius * 2
	imsize: imsize + 40
	im: make image! imsize
	cy: to-integer imsize/y / 2
	cx: to-integer imsize/x / 2
	y: 0 
	while [y < imsize/y] [
		x: 0
		dy: to-decimal (y - cy)
		while [x < imsize/x][
			dx: to-decimal (x - cx)
			distance: sqrt ((dx * dx) + (dy * dy))
			if distance <= radius [
				theta: atan2 dy dx
				hue: theta + pi / tau
				idx: to-integer (y * imsize/x) + x + 1 ;--Red and Rebol are one-based
				im/:idx: hsb2Rgb hue 1.0 1.0
			]
			x: x + 1
		]
		y: y + 1
	]
	im
]
opencv?: yes			;--is opencv extension used?
img: colorWheel 200

if opencv? [
	;--OpenCV extension for Rebol3
	cv: import opencv
	cv/imshow/name img "Color Wheel 1"
	print "Any key to close"
	cv/waitkey 0
]
unless opencv? [
	print "Image saved"
	save %colorWheel.png img
	call/shell "open colorWheel.png"	;--macOS
]



