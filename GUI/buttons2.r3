#!/usr/local/bin/r3
REBOL [
]
b2d: import 'blend2d 	;--use blend2d (draw module)
cv:  import 'opencv		;--for visualisation

fileName: none
win: "GUI Buttons Test 2"
isloaded?: false

process: does [
	img: b2d/draw 480x480 :code
	cv/imshow/name img win
	cv/moveWindow win 350x0
]


loadImage: does [
	isloaded?: false
	fileName: request-file/title/filter "Select an image" [%jpg %jpeg %png]
	unless none? fileName [
		im: b2d/image fileName	;--as RGB image
		process
		isloaded?: true
	]
]

convert: func [f [file!] /HSV /GS][
	img: cv/imread f									;--source image
	if HSV [							
		hsv: cv/cvtColor :img none cv/COLOR_RGB2HSV		;--HSV image
		cv/imwrite %temp.jpg hsv						;--use temporary file
	]
	if GS [
		gre: cv/cvtColor :img none cv/COLOR_RGB2GRAY	;--grayscale image
		cv/imwrite %temp.jpg gre						;--use temporary file
	]
	im: b2d/image %temp.jpg								;--update b2d image
	delete %temp.jpg									;--delete temporary file
	process												;--update view
]

;--OpenCV mouse callback in context
ctx: context [
    on-mouse-click: func [
        type  [integer!]
        x     [integer!]
        y     [integer!]
        flags [integer!]
    ][
    	pos: mcb/pos	;--a pair!
        if type == cv/EVENT_LBUTTONDOWN [
        	if pos/y < 20 [
        		if all [pos > 0x0 pos < 80x20] [loadImage]								;--button 1
        		if all [pos > 80x0 pos < 160x20][if isloaded? [convert/GS fileName]]	;--button 2
        		if all [pos > 160x0 pos < 240x20][if isloaded? [convert/HSV fileName]]	;--button 3
        		if all [pos > 240x0 pos < 320x20][quit]									;--button 4
        	]
        ]
    ]
]

;--Blend2D drawing code
code: [
	font %/System/Library/Fonts/Geneva.ttf
	fill-pen black
	pen white
	box 0x0 80x20 8
	box 80x0 80x20 8
	box 160x0 80x20 8
	box 240x0 80x20 8
	fill-pen white
	text 25x15   14 "Load"
	text 90x15   14 "Grayscale"
	text 185x15  14 "HSV"
	text 265x15  14 "Quit"
	image :im 40x40 400x400
]

;--Main
process												;--create interface
mcb: cv/setMouseCallback win ctx 'on-mouse-click 	;--mouse callback
cv/waitkey 0
