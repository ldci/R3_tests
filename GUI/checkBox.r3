#!/usr/local/bin/r3
REBOL [
]
b2d: import 'blend2d 	;--use blend2d (draw module)
cv:  import 'opencv		;--for visualisation
win: "Checkbox with Blend2D and OpenCV modules"
cb1: cb2: cb3: cb4: false
;--OpenCV mouse callback in context
ctx: context [
    on-mouse-click: func [
        type  [integer!]
        x     [integer!]
        y     [integer!]
        flags [integer!]
    ][
    	pos: mcb/pos	;--mouse position as a pair!
        if type == cv/EVENT_LBUTTONDOWN [
        	if pos/x < 30 [
        		case [
        			all [pos/y > 10 pos/y < 30]  [
        				either cb1 = false [cb1: true code/44: "X"]
        				[cb1: false code/44: " "]] ;--cb1 
        			all [pos/y > 40 pos/y < 60]  [
        				either cb2 = false [cb2: true code/48: "X"]
        				[cb2: false code/48: " "]];--cb2 
        			all [pos/y > 70 pos/y < 90]  [
        				either cb3 = false [cb3: true code/52: "X"]
        				[cb3: false code/52: " "]];--cb3 
        			all [pos/y > 100 pos/y < 120][
        				either cb4 = false [cb4: true code/56: "X"][
        				cb4: false code/56: " "]];--cb4
        		]
        		img: b2d/draw 440x160 :code
				cv/imshow/name img win								
        	]
        	if pos/y > 133 [
        		if all [pos > 200x133 pos < 280x153] [Quit]	;--quit button
        	]
        ]
    ]
]

;--Blend2D drawing code
code: [
	font %/System/Library/Fonts/Geneva.ttf
	fill-pen white
	pen black
	box 10x10 20x20 0
	box 10x40 20x20 0
	box 10x70 20x20 0
	box 10x100 20x20 0
	fill-pen blue
	text 35x25   14 "Rebol2"
	text 35x55   14 "Rebol3"
	text 35x85   14 "Red"
	text 35x115  14 "Red/System"
	text 13x28   20 " "
	text 13x58   20 " "
	text 13x88   20 " "
	text 13x118  20 " "
	fill-pen white
	box 125x10 300x120
	box 200x133 80x20 8
	fill-pen blue
	text 170x75 14 "Choose your favorite language"
	text 227x147 14 "Quit"
]
img: b2d/draw 440x160 :code
cv/imshow/name img win
cv/moveWindow win 350x0	
mcb: cv/setMouseCallback win ctx 'on-mouse-click
cv/waitkey 0
