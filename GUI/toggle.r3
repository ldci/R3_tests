#!/usr/local/bin/r3
REBOL [
]
b2d: import 'blend2d 	;--use blend2d (draw module)
cv:  import 'opencv		;--for visualisation
toggle: false

win: "Toggle with Blend2D and OpenCV modules"
code: [
	font %/System/Library/Fonts/Geneva.ttf
	fill-pen black
	pen black
	box 10x10 80x20 8
	fill-pen black
	box 20x12 6x15 4
	fill-pen black
	pen white
	box 90x10 80x20 8
	fill-pen white
	text 30x25 14 "Toggle"
	text 115x25   14 "Quit"
]

;repeat i (length? code) [print [i code/:i]]
ctx: context [
    on-mouse-click: func [
        type  [integer!]
        x     [integer!]
        y     [integer!]
        flags [integer!]
    ][
    	pos: mcb/pos
        if type == cv/EVENT_LBUTTONDOWN [
        	if pos/y < 30 [
        		if all [pos > 10x10 pos < 90x20] 
        		[either toggle [code/12: green toggle: false] [code/12: black toggle: true]]	;--toogle
        		if all [pos > 90x10 pos < 170x20][ quit]										;--button Quit
        	]
        ]
        img: b2d/draw 480x120 :code
		cv/imshow/name img win
    ]
]

;--Main
img: b2d/draw 480x120 :code
cv/imshow/name img win
cv/moveWindow win 350x0	
mcb: cv/setMouseCallback win ctx 'on-mouse-click
cv/waitkey 0