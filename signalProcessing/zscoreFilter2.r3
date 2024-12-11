#!/usr/local/bin/r3
Rebol [
	title: "Peak signal detection in timeseries data"
	note: https://stackoverflow.com/questions/22583391/peak-signal-detection-in-realtime-timeseries-data
]

b2d: import 'blend2d		;--use blend2d (draw module)
opencv?: yes
if opencv? [cv: import 'opencv]

mean: func [
	data [block!]
	len  [integer!]			;--for mobile window (lag)
][
	;--don't use R3 sum function since we use mobile windows
	_sum: 0.0
	repeat i len [_sum: _sum + data/:i]
	_sum / len
]

stdDev: func [
	data [block!]
	len  [integer!]			;--for mobile window (lag)
][
	average: mean data len
	sd: 0.0
	repeat i len [sd: sd + power (data/:i - average) 2]
	sqrt (sd / (len - 1))
]

zThresholding: func [
	data      [block! vector!]
	output    [block! vector!]
	lag       [integer!]
	threshold [decimal!]
	influence [decimal!]
][
	sLength: length? data	
	filteredY: copy data
	avgFilter: make vector! reduce ['decimal! 64 sLength]
	stdFilter: make vector! reduce ['decimal! 64 sLength]
	
	avgFilter/:lag: mean data lag
	stdFilter/:lag: stdDev data lag
	i: lag
	while [i < sLength][
		n:   i + 1          ;; index of the next value
		y:   data/:n
		avg: avgFilter/:i
		std: stdFilter/:i

		v1: abs(y - avg)
		v2: threshold * std

		either v1 > v2 [
			output/:n: pick [1 -1] y > avg
			filteredY/:n: (influence * y) + ((1 - influence) * filteredY/:i)
		][
			output/:n: 0
		]
		avgFilter/:n: mean   (at filteredY i - lag) lag
		stdFilter/:n: stdDev (at filteredY i - lag) lag
		++ i
	]
	filteredY
]


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

inputData: [1 1.1 1 1 0.9 1 1 1.1 1 1 1 1 1.1 0.9 1 1.1 1 1 0.9
     1 1.1 1 1 1.1 1 0.8 0.9 1 1.2 0.9 1 1 1.1 1.2 1 1.5 1 3 2 5 3 2 1 1 1 0.9 1 1 
     3 2.6 4 3 3.2 2 1 1 0.8 4 4 2 2.5 1 1 1 1 1 1.1 1 0.9 1 1 1.1 1 0.9 
     1 1.1 1 1 0.9 1 1 1.1 1 1 1.1 1 0.9 1 1 1.1 1 1 1.1 1 0.9 1 1 1.1 1 0.9]
     
sampleLenght: length? inputData
;--allocated buffer used to collect the peaks..
outputData: array/initial sampleLenght 0

;--resolve filtered input and peaks...
zThresholding :inputData :outputData :lag :threshold :influence


bm1: make image! reduce [1000x100 black]
bm2: make image! reduce [1000x100 black]
generateImage inputData  bm1 green 16.0
generateImage outputData bm2 red 64.0

if opencv? [
	cv/imshow/name :bm1 "Input Signal"
	cv/imshow/name :bm2 "Z-score Filtering"
	cv/moveWindow "Z-score Filtering" 0x90
	cv/waitkey 0
]

unless opencv? [
	print "Images saved"
	save %img1.png bm1
	save %img2.png bm2
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS 
]

