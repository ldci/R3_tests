#!/usr/local/bin/r3
REBOL [
]
;--point2D! and point3D! are implemented in Red as datatypes, not in R3

point2D!: make object! [
	x:	[decimal!]
	y:	[decimal!]
]

point3D!: make object! [
	x:	[decimal!]
	y:	[decimal!]
	z:  [decimal!]
]

point: copy point2D!
point/x: 19.0 
point/y: 45.0
probe point

point: copy point3D!
point/x: 69.0 
point/y: 15.0
point/z: 2.0
probe point

;--we can also use vectors
v: #(f64!  [19.0 45.0])
point: copy point2D!
point/x: v/1 
point/y: v/2
probe point

v: #(f64!  [69.0 15.0 2.0])
point: copy point3D!
point/x: v/1 
point/y: v/2
point/z: v/3
probe point


