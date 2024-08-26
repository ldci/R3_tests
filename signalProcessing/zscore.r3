#!/usr/local/bin/r3
Rebol [
	title: "Peak signal detection in realtime timeseries data"
	note: https://stackoverflow.com/questions/22583391/peak-signal-detection-in-realtime-timeseries-data
]

;--Thanks to Oldes for corrections in zThresholding function

mean: function [
	data [block!]
	len  [integer!]			;--for mobile window (lag)
][
	;--don't use R3 sum function since we use mobile windows
	_sum: 0.0
	repeat i len [_sum: _sum + data/:i]
	_sum / len
]

stddev: function [
	data [block!]
	len  [integer!]			;--for mobile window (lag)
][
	average: mean data len
	sd: 0.0
	repeat i len [sd: sd + power (data/:i - average) 2]
	sqrt (sd / len)
]

zThresholding: function [
	data      [block!]
	output    [block!]
	lag       [integer!]
	threshold [decimal!]
	influence [decimal!]
][
	sLenght: length? data
	
	;; NOTE: these filteredY, avgFilter and stdFilter should be reused in real life usage!
	
	filteredY: copy data
	avgFilter: array/initial sLenght 0.0
	stdFilter: array/initial sLenght 0.0
	
	avgFilter/:lag: mean data lag
	stdFilter/:lag: stddev data lag
	i: lag
	while [i < sLenght][
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
		stdFilter/:n: stddev (at filteredY i - lag) lag
		;print [i "avg:" avgFilter/:n "signal:" output/:n]
		++ i
	]
	filteredY
]

generateImage: func [v [block!] img [image!] 
][
	repeat i length? v [p: as-pair i 50 - (v/:i * 10) change at img p green]
	img
]

lag: 25
threshold: 5.0
influence: 0.0
opencv?: yes

data-inp: [1 1.1 1 1 0.9 1 1 1.1 1 1 1 1 1.1 0.9 1 1.1 1 1 0.9
     1 1.1 1 1 1.1 1 0.8 0.9 1 1.2 0.9 1 1 1.1 1.2 1 1.5 1 3 2 5 3 2 1 1 1 0.9 1 1 
     3 2.6 4 3 3.2 2 1 1 0.8 4 4 2 2.5 1 1 1 1 1 1.1 1 0.9 1 1 1.1 1 0.9 
     1 1.1 1 1 0.9 1 1 1.1 1 1 1.1 1 0.9 1 1 1.1 1 1 1.1 1 0.9 1 1 1.1 1 0.9]

sampleLenght: length? data-inp
;--allocated buffer used to collect the peaks..
data-out: array/initial sampleLenght 0

;--resolve filtered input and peaks...
filtered: zThresholding :data-inp :data-out :lag :threshold :influence

print ["Input: " data-inp]
print ["Output:" data-out]

bm1: make image! reduce [100x100 black]
bm2: make image! reduce [100x100 black]

generateImage data-inp bm1
generateImage data-out bm2 

if opencv? [
	cv: import opencv
	bm: cv/resize  :bm1 600x200
	cv/imshow/name :bm "Noisy Signal"
	bm: cv/resize  :bm2 600x200
	cv/imshow/name :bm "Z-score Filter"
	cv/moveWindow "Z-score Filter" 0x180
	cv/waitkey 0
]

unless opencv? [
	print "Images saved"
	save %img1.png bm1
	save %img2.png bm2
	call/shell "open img1.png"	;--macOS 
	call/shell "open img2.png"	;--macOS 
]


