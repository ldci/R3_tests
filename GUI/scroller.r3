#!/usr/local/bin/r3
Rebol [
	title: "Basic Blend2D extension test"
]
b2d: 	import 'blend2d
cv: 	import 'opencv
win: "Scroller with Blend2D and OpenCV modules"
code: [
	font %/System/Library/Fonts/Geneva.ttf
	line-width 4
	pen black
	line 5x20 390x20
	line-width 1
	fill-pen gray
	circle 10x20 10 
	fill-pen black
	text 400x25 14 "0.0"
	fill-pen blue
	box 185x133 80x20 8
	fill-pen white
	text 210x147 14 "Quit" 
]
;repeat i (length? code) [print [i code/:i]]
ctx: context [
	on-mouse-move: func [
        type  [integer!]
        x     [integer!]
        y     [integer!]
        flags [integer!]
    ][
    	pos: mcb/pos
    	if flags = 1 [
    		if all [pos/x > 0 pos/x < 390 pos/y > 13 pos/y < 24] [
    			value:  round/to (pos/x / 390) 0.01
    			code/15: as-pair pos/x 20 
    			code/22: form value
    			img: b2d/draw 440x160 :code
				cv/imshow/name img win
    		]
    		if pos/y > 30 [if all [pos > 185x133 pos < 265x153] [Quit]]];--quit button
    	]
]

img: b2d/draw 440x160 :code
cv/imshow/name img win
cv/moveWindow win 350x0	
mcb: cv/setMouseCallback win ctx 'on-mouse-move
cv/waitkey 0
