#!/usr/local/bin/r3
REBOL [
]
b2d: import 'blend2d 	;--use blend2d (draw module)
cv:  import 'opencv		;--for visualisation
fileName: none
win: "GUI Buttons Test 1"

loadImage: does [
	cv/destroyWindow "HSV"
	fileName: request-file/title/filter "Select an image" [%jpg %jpeg %png %tif %tiff]
	unless none? fileName [
		img: cv/imread fileName	
		cv/imshow/name img "Source"
		cv/moveWindow "Source" 0x10 
	]
]

toHSV: does [
	cv/destroyWindow "Source"
	img: cv/imread fileName							;--source image
	gre: cv/cvtColor :img none cv/COLOR_BGR2GRAY	;--grayscale image
	hsv: cv/cvtColor :img none cv/COLOR_RGB2HSV		;--HSV image
	cv/imshow/name hsv "HSV"
	cv/movewindow "HSV" 0x10
]
;--mouse callback in context
ctx: context [
    on-mouse-click: func [
        type  [integer!]
        x     [integer!]
        y     [integer!]
        flags [integer!]
    ][
    	pos: mcb/pos
        if type == cv/EVENT_LBUTTONDOWN[
        	if pos/y < 20 [
        		if all [pos > 0x0 pos < 80x20] [loadImage]						;--button 1
        		if all [pos > 80x0 pos < 160x20][toHSV]							;--button 2
        		if all [pos > 160x0 pos < 240x20][cv/destroyAllWindows quit]	;--button 3
        	]
        ]
    ]
]

;--Blend2D code
code: [
	font %/System/Library/Fonts/Geneva.ttf
	fill-pen black
	pen white
	box 0x0 80x20 8
	box 80x0 80x20 8
	box 160x0 80x20 8
	fill-pen white
	text 20x15   14 "Load"
	text 95x15   14 "to HSV"
	text 180x15  14 "Quit"
]

;--Main
img: b2d/draw 480x480 :code
cv/imshow/name img win
mcb: cv/setMouseCallback win ctx 'on-mouse-click
cv/waitkey 0
