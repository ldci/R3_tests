#!/usr/local/bin/r3
Rebol [
	title: "Peak signal detection in timeseries data"
	needs: 3.18.1
	note: https://stackoverflow.com/questions/22583391/peak-signal-detection-in-realtime-timeseries-data
]

do %Tools/fzscore.r3			;--z-score functions
b2d: import 'blend2d			;--use blend2d (draw module)
opencv?: yes
if opencv? [cv: import 'opencv]	;--opencv module

generateImage: func [
	v 		[block!] 
	img 	[image!] 
	color 	[tuple!]
	scale	[decimal!]
][
	;--blend2d commands
	code: copy [pen color line-width 1 line]
	repeat i length? v [
		p: as-pair (i * 10) (90 - (v/:i * scale)) 
		append code p
	]
	draw img :code
	img
]


;--************************* Main program ******************************* 
lag: 25
threshold: 5.0
influence: 0.0

inputData: [1.0 1.1 1.0 1.0 0.9 1.0 1.0 1.1 1.0 1.0 1.0 1.0 1.1 0.9 1.0 1.1 1.0 1.0 0.9
     1.0 1.1 1.0 1.0 1.1 1.0 0.8 0.9 1.0 1.2 0.9 1.0 1.0 1.1 1.2 1.0 1.5 1.0 3.0 2.0 5.0 3.0 2.0 1.0 1.0 1.0 0.9 1.0 1.0 
     3.0 2.6 4.0 3.0 3.2 2.0 1.0 1.0 0.8 4.0 4.0 2.0 2.5 1.0 1.0 1.0 1.0 1.0 1.1 1.0 0.9 1.0 1.0 1.1 1.0 0.9 
     1.0 1.1 1.0 1.0 0.9 1.0 1.0 1.1 1.0 1.0 1.1 1 0.9 1.0 1.0 1.1 1.0 1.0 1.1 1.0 0.9 1.0 1.0 1.1 1.0 0.9]
     

;--allocated buffer used to collect the peaks..   
sampleLenght: length? inputData
outputData: array/initial sampleLenght 0.0

;--resolve filtered input and peaks...
zThresholding :inputData :outputData :lag :threshold :influence
;--make images
bm1: make image! reduce [1000x100 black]
bm2: make image! reduce [1000x100 black]
generateImage inputData  bm1 green 16.0
generateImage outputData bm2 red 64.0

if opencv? [
	cv/imshow/name :bm1 "Input Signal"
	cv/imshow/name :bm2 "Z-score Filtering"
	cv/moveWindow "Z-score Filtering" 0x80
	cv/waitkey 0
]

unless opencv? [
	print "Images saved"
	save %img1.png bm1
	save %img2.png bm2
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS 
]

