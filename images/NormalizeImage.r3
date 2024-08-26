#!/usr/local/bin/r3
REBOL [ 
] 

im1: load %../pictures/lena.png
b: copy []
foreach [v1 v2 v3] im1/rgb [append b reduce [v1 v2 v3]]
print ["Min :" mini: first find-min b]
print ["Max :" maxi: first find-max b]

;--min max normalization
c: array/initial length? b 0.0
repeat i length? b [c/:i: (b/:i - mini) / (maxi - mini)] 	;--[0..1]
print ["Min :" mini: first find-min c]
print ["Max :" maxi: first find-max c]
repeat i length? c [c/:i: to-integer c/:i * 255.0]			;--[0..255]
print ["Min :" mini: first find-min c]
print ["Max :" maxi: first find-max c]

;--z_score normalization
average: (sum b) / (length? b)
sigma: 0.0
foreach value b [sigma: sigma + (power (value - average) 2)]
std: sqrt sigma / ((length? b) - 1)
print ["Mean:" round/to average 0.01]
print ["STD :" round/to std 0.01]
z: array/initial length? b 0.0
repeat i length? b [z/:i: (b/:i - average) / std] ;[-n + n]
print ["Min :" mini: round/to first find-min z 0.01]
print ["Max :" maxi: round/to first find-max z 0.01]

;--use min max normalization on z-score values
d: array/initial length? b 0
repeat i length? z [d/:i: (z/:i - mini) / (maxi - mini)]

repeat i length? d [d/:i: to-integer d/:i * 255.0]
print ["Min :" mini: first find-min d]
print ["Max :" maxi: first find-max d]

im2: make image! reduce [im1/size to-binary c]
im3: make image! reduce [im1/size to-binary d]

print ["im1 = im2" im1 == im2]	;--should be true
print ["im1 = im3" im1 == im3]	;--should be false
print ["im2 = im3" im2 == im3]	;--should be false

opencv?: yes
if opencv? [ 
	cv: import opencv
	cv/imshow/name im1 "Source"	
	cv/imshow/name im2 "Normalized"	
	cv/imshow/name im3 "Z-score"	
	cv/moveWindow "Source" 0x0
	cv/moveWindow "Normalized" 260x0
	cv/moveWindow "Z-score" 520x0
	cv/waitkey 0
]

unless opencv? [
	print "Images saved"
	save %im1.png im1
	save %im2.png im2
	save %im3.png im3
	call/shell "open im1.png"	;--macOS 
	call/shell "open im2.png"	;--macOS
	call/shell "open im3.png"	;--macOS 
]



