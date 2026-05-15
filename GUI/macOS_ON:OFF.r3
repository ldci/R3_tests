#!/usr/local/bin/r3
Rebol [
	title: "Blend2D extension test"
]
b2d: import 'blend2d
cv2: import 'opencv

win: "On/Off"
bstate: true

showDraw: does [
	img: b2d/draw 200x80 :b2dcode
	cv2/imshow/name :img win
	cv2/moveWindow win 350x0	
]

b2dcode: [
	font %/System/Library/Fonts/Geneva.ttf
	fill-pen gray			
	box 10x10 40x20 12		
	fill-pen white
	circle 20x20 8 
	fill-pen black
	text 60x25 16 "Off"
]

cv2ctx: context [
	on-mouse-click: func [
        type  [integer!]
        x     [integer!]
        y     [integer!]
        flags [integer!]
    ][
    	if type == cv2/EVENT_LBUTTONDOWN [
    		if all [mcb/pos > 10x10 mcb/pos < 50x30] [
    			either bstate 
    				[b2dcode/4: mint b2dcode/12: 40x20 b2dcode/19: "On" bstate: false]
    				[b2dcode/4: gray b2dcode/12: 20x20 b2dcode/19: "Off" bstate: true]
    			showDraw
    		]
    	]
    ]
];--end of context

;repeat i (length? b2dcode) [print [i b2dcode/:i]]		;--for test
showDraw												;--create interface
mcb: cv2/setMouseCallback win cv2ctx 'on-mouse-click 	;--mouse callback
print "Any key to close"
cv2/waitkey 0
