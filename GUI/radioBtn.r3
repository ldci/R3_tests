#!/usr/local/bin/r3
REBOL [
]
b2d: import 'blend2d 	;--use blend2d (draw module)
cv:  import 'opencv		;--for visualisation
win: "Radio Button with Blend2D and OpenCV modules"
rb1: rb2: rb3: rb4: false
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
        				rb1: true rb2: rb3: rb4: false 
        				code/11: code/16: code/21: white
        				code/6: green
        				code/73: code/30] 					;--rb1 
        			all [pos/y > 40 pos/y < 60]  [
        				rb2: true rb1: rb3: rb4: false 
        				code/6: code/16: code/21: white 
        				code/11: green
        				code/73: code/34]					;--rb2 
        			all [pos/y > 70 pos/y < 90]  [
        				rb3: true rb1: rb2: rb4: false
        				code/6: code/11: code/21: white
        				code/16: green
        				code/73: code/38]					;--rb3 
        			all [pos/y > 100 pos/y < 120][
        				rb4: true rb1: rb2: rb3: false
        				code/6: code/11: code/16: white
        				code/21: green
        				code/73: code/42]					;--rb4
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
	pen black
	fill-pen white
	circle 20x20 10 
	fill-pen white
	circle 20x50 10
	fill-pen white
	circle 20x80 10
	fill-pen white
	circle 20x110 10
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
	text 250x75 14 "Enjoy!"
	text 227x147 14 "Quit" 
]
;repeat i (length? code) [print [i code/:i]] 
img: b2d/draw 440x160 :code
cv/imshow/name img win
cv/moveWindow win 350x0	
mcb: cv/setMouseCallback win ctx 'on-mouse-click
cv/waitkey 0
