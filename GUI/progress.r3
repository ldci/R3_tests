#!/usr/local/bin/r3
REBOL [
]
b2d: import 'blend2d 	;--use blend2d (draw module)
cv:  import 'opencv		;--for visualisation
size: 440x100
win: "Progress bar with Blend2D and OpenCV modules"

code: [
	font %/System/Library/Fonts/Geneva.ttf
	fill-pen black
	pen black
	box 10x10 420x20 8
	box 10x40 80x20 8
	box 95x40 80x20 8
	box 180x40 80x20 8
	box 265x40 80x20 8
	box 350x40 80x20 8
	fill-pen white
	text 13x55 14  "Set to 0.0"
	text 98x55 14  "Set to 0.5"
	text 183x55 14 "Set to 1.0"
	text 275x55 14 "Progress"
	text 375x55 14 "Quit"
	fill-pen mint
	box 10x10 10x20 8
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
        	if all [pos/y > 40 pos/y < 70] [
        		case [
        			all [pos > 10x20 pos < 90x20] [code/57: 10x20]					;--set to 0.0
        			all [pos > 95x20 pos < 175x20] [code/57: 210x20]				;--set to 0.5
        			all [pos > 180x20 pos < 260x20] [code/57: 420x20]				;--set to 1.0
        			all [pos > 265x20 pos < 325x20][
        				for i 10 420 10 [
        					code/57: as-pair i 20 cv/waitKey 100					;--automatic progress
        					showImage
        				]												
        			]
        			all [pos > 355x20 pos < 430x20][Quit]							;--button Quit
        		]
        	]
        ]
        showImage
    ]
]

showImage: does [
	img: b2d/draw size :code
	cv/imshow/name img win
]

;--Main
showImage
cv/moveWindow win 350x0	
mcb: cv/setMouseCallback win ctx 'on-mouse-click
cv/waitkey 0