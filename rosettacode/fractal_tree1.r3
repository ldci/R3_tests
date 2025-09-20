#!/usr/local/bin/r3
REBOl [
	title: "Rosetta code: Fractal tree"
    file:  %Fractaltree.r3
]
;FractalTree
;https://rosettacode.org/wiki/Fractal_tree
;with Oldes's help

drawTree: function [
	pos		[pair!] 	;--Current position as pair! (x y)
	angle	[decimal!]	;--Current branch angle (radians)
	depth	[integer!]	;--Remaining recursion depth
][
	;--Calculate end point of current branch
	forkAngle: 0.1 * pi
	baseLen: 10.0
	len: depth * baseLen
	pos2: as-pair
        pos/x + (len * cos angle)
        pos/y + (len * sin angle)
    ;--Draw branch line with width proportional to depth
	append plot reduce [
		'line-width (depth) 'pen (red) 'line (pos) (pos2)
	]
	;--Recurse for right and left sub-branches
    -- depth
	if depth > 0 [
		drawTree pos2 angle - forkAngle depth 
    	drawTree pos2 angle + forkAngle depth 
	]
]

;********************* Main ************************
b2d: import 'blend2d 	;--use blend2d (draw module)
cv:  import 'opencv		;--for visualisation
imgSize: 600x600
plot: []
drawTree 300x550 1.5 * pi 9 
img: draw :imgSize :plot
cv/imshow/name :img "Fractal Tree"
cv/waitKey 0