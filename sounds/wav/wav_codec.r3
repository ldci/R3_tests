#!/usr/local/bin/r3
Rebol [
]
wav: import 'wav
file: request-file/title/filter "Select a sound" [%wav]
unless none? file [sound: load file]
print ? sound
print ["Chunks   :" sound/chunks]
unless type? sound/data = binary![
	print ["Min Value:" mini: sound/data/min]
	print ["Max Value:" maxi: sound/data/max]
	print ["Range    :" maxi - mini]
	print ["Mean     :" sound/data/mean]
]
probe sound/chunks
ch1: copy [] ch2: copy []
either type? sound/data = binary! [n: length? sound/data][n: sound/data/length]
repeat i n [
	switch sound/channels [
		1 [append ch1 sound/data/:i]
		2 [either odd? i [append ch1 sound/data/:i] [append ch2 sound/data/:i]]
	]
]
;probe ch1
probe ch2

