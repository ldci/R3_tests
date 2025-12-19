#!/usr/local/bin/r3
REBOL [
]
b2d: import 'blend2d 	;--use blend2d (draw module)
cv:  import 'opencv		;--for visualisation

fileName: none
win: "GUI Buttons with Blend2D and OpenCV modules"
isLoaded?: false

showDraw: does [
	img: b2d/draw 480x480 :code	;--call b2d commands
	cv/imshow/name img win		;--use openCV for rendering
	cv/moveWindow win 350x0		;--move app face 
]

loadImage: does [
	isLoaded?: false
	fileName: request-file/title/filter "Select an image" [%jpg %jpeg %png]
	unless none? fileName [
		im: b2d/image fileName	;--as RGB image
		showDraw
		isLoaded?: true
	]
]

showSource: does [
	if isLoaded? [
		im: b2d/image fileName	;--as RGB image
		showDraw
	]
]

convertTo: func [f [file!] /HSV /GS]
[
	img: cv/imread f										;--source image as handle!
	;--cvColor requires handle! daratype
	case [
		HSV [ima: cv/cvtColor :img none cv/COLOR_RGB2HSV]	;--HSV image as handle!
		GS  [ima: cv/cvtColor :img none cv/COLOR_RGB2GRAY]	;--grayscale image as handle!
	]
	cv/imwrite %temp.jpg ima								;--use temporary file
	im: b2d/image %temp.jpg									;--update b2d image
	delete %temp.jpg										;--delete temporary file
	showDraw												;--update view
]

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
        	if pos/y < 20 [
        		case [
        			all [pos > 0x0 pos < 80x20]   [loadImage]							;--button 1
        		 	all [pos > 80x0 pos < 160x20] [if isLoaded? [convertTo/GS fileName]];--button 2
        		 	all [pos > 160x0 pos < 240x20][if isLoaded? [convertTo/HSV fileName]];--button 3
        		 	all [pos > 240x0 pos < 320x20][showSource]							;--button 4
        		 	all [pos > 320x0 pos < 400x20][quit]								;--button 5
        		]									
        	]
        ]
    ]
]

;--Blend2D drawing code
code: [
	font %/System/Library/Fonts/Geneva.ttf
	fill-pen black
	pen white
	box 0x1 80x20 8
	box 80x1 80x20 8
	box 160x1 80x20 8
	box 240x1 80x20 8
	box 320x1 80x20 8
	fill-pen white
	text 25x15   14 "Load"
	text 88x15   14 "Grayscale"
	text 185x15  14 "HSV"
	text 258x15  14 "Source"
	text 345x15  14 "Quit"
	image :im 10x30 460x440
]

;--Main
showDraw											;--create interface
mcb: cv/setMouseCallback win ctx 'on-mouse-click 	;--mouse callback
?? mcb
cv/waitkey 0
