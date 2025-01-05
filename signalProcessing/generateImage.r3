#!/usr/local/bin/r3
REBOL [ 
	needs: 3.18.1
]


generateImage: func [
"Creating image"
	v 		[vector!] 
	img 	[image!] 
	scale 	[decimal!]
	cyValue	[integer!]
	color 	[tuple!]
][
	i: 0
	;--blend2d commands
	plot: copy [pen white line-width 1 line 0x64 1024x64 pen color line]
	forall v [append plot as-pair i cyValue + (v/1 * scale) ++ i]
	draw img :plot 
]


;--test program
random/seed now/time/precise
b2d: import 'blend2d
cv:  import 'opencv
x: 1024
y: 128
size: as-pair x y

vec1: make vector! compose [decimal! 64 (x)]
repeat i vec1/length [vec1/:i: random y]
vec2: make vector! compose [decimal! 64 (x)]
repeat i vec2/length [vec2/:i: random y / 2]
vec3: make vector! compose [decimal! 64 (x)]
repeat i vec3/length [vec3/:i: random y / 4]
vec4: make vector! compose [decimal! 64 (x)]
repeat i vec4/length [vec4/:i: random y / 8]

bm1: make image! reduce [size black]
bm2: make image! reduce [size black]
bm3: make image! reduce [size black]
bm4: make image! reduce [size black]

tt: dt [
	generateImage vec1 bm1 1.0 0  green
	generateImage vec2 bm2 1.0 32 red
	generateImage vec3 bm3 1.0 48 yellow
	generateImage vec4 bm4 1.0 56 purple
]
print rejoin ["Images rendered in: " third tt * 1000 " ms"]
cv/imshow/name :bm1 "Random Signal 1"
cv/imshow/name :bm2 "Random Signal 2"
cv/imshow/name :bm3 "Random Signal 3"
cv/imshow/name :bm4 "Random Signal 4"
cv/moveWindow "Random Signal 2" 0x110
cv/moveWindow "Random Signal 3" 0x270
cv/moveWindow "Random Signal 4" 0x430
cv/waitkey 0