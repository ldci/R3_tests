#!/usr/local/bin/r3
Rebol [
	title: "Peak signal detection in timeseries data"
	needs: 3.18.1
	note: https://stackoverflow.com/questions/22583391/peak-signal-detection-in-realtime-timeseries-data
]

do %Tools/fzscore.r3					;--z-score functions
opencv?: yes
if opencv? [cv: import 'opencv]	;--opencv module


generateImage: func [v [block!] img [image!] color [tuple!]
][
	repeat i length? v [
		p: as-pair i (50 - (v/:i * 10)) 
		change at img p color
	]
	img
]

;--************************* Main program ******************************* 
lag: 25
threshold: 5.0
influence: 0.0

data-inp: [1.0 1.1 1.0 1.0 0.9 1.0 1.0 1.1 1.0 1.0 1.0 1.0 1.1 0.9 1.0 1.1 1.0 1.0 0.9
     1.0 1.1 1.0 1.0 1.1 1.0 0.8 0.9 1.0 1.2 0.9 1.0 1.0 1.1 1.2 1.0 1.5 1.0 3.0 2.0 5.0 3.0 2.0 1.0 1.0 1.0 0.9 1.0 1.0 
     3.0 2.6 4.0 3.0 3.2 2.0 1.0 1.0 0.8 4.0 4.0 2.0 2.5 1.0 1.0 1.0 1.0 1.0 1.1 1.0 0.9 1.0 1.0 1.1 1.0 0.9 
     1.0 1.1 1.0 1.0 0.9 1.0 1.0 1.1 1.0 1.0 1.1 1 0.9 1.0 1.0 1.1 1.0 1.0 1.1 1.0 0.9 1.0 1.0 1.1 1.0 0.9]


sampleLenght: length? data-inp
;--allocated buffer used to collect the peaks..
data-out: array/initial sampleLenght 0.0

;--resolve filtered input and peaks...
filtered: zThresholding :data-inp :data-out :lag :threshold :influence

;--for test
;print ["Input: " data-inp]
;print ["Output:" data-out]

bm1: make image! reduce [100x100 black]
bm2: make image! reduce [100x100 black]

generateImage data-inp bm1 green
generateImage data-out bm2 red

if opencv? [
	bm: cv/resize bm1 600x200
	cv/imshow/name :bm "Noisy Signal"
	bm: cv/resize bm2 600x200
	cv/imshow/name :bm "Z-score Filter"
	cv/moveWindow "Z-score Filter" 0x200
	cv/waitkey 0
]

unless opencv? [
	print "Images saved"
	save %img1.png bm1
	save %img2.png bm2
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS 
]


