#!/usr/local/bin/r3
Rebol [
	title: "Basic Blend2D extension test"
]
b2d: 	import 'blend2d
cv: 	import 'opencv
win: "TextBox with Blend2D and OpenCV modules"

showImage: does [
	img: b2d/draw 440x200 :code
	cv/imshow/name img win
]
ctx: context [
	on-mouse-move: func [
        type  [integer!]
        x     [integer!]
        y     [integer!]
        flags [integer!]
    ][
    	pos: mcb/pos
    	if flags = 1 [
    		case [
    			all [pos/x > 10 pos/y > 10 pos/y < 25]  [code/41: "Item 1 selectionned"]
    			all [pos/x > 10 pos/y > 25 pos/y < 50]  [code/41: "Item 2 selectionned"]
    			all [pos/x > 10 pos/y > 50 pos/y < 75]  [code/41: "Item 3 selectionned"]
    			all [pos/x > 10 pos/y > 75 pos/y < 100] [code/41: "Item 4 selectionned"]
    			all [pos/x > 10 pos/y > 100 pos/y < 125][code/41: "Item 5 selectionned"]
    			all [pos/x > 10 pos/y > 125 pos/y < 150][code/41: "Item 6 selectionned"]
    		]
    	showImage
    	]
    ]
    		
]


code: [
	font %/System/Library/Fonts/Geneva.ttf
	line-width 2
	line-cap round
	pen mint
	box 10x10 100x150
	fill-pen mint
	text 15x25  14 "Item 1"
	text 15x50  14 "Item 2"
	text 15x75  14 "Item 3"
	text 15x100 14 "Item 4"
	text 15x125 14 "Item 5"
	text 15x150 14 "Item 6"
	text 120x80 16 "Select an Item"
]
;repeat i (length? code) [print [i code/:i]]

showImage
cv/moveWindow win 350x0	
mcb: cv/setMouseCallback win ctx 'on-mouse-move
cv/waitkey 0