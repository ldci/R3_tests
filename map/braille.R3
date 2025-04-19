#!/usr/local/bin/r3
Rebol [
]
;--Electronic Braille's cell is a 2x4 matrix with 8 points
;--generate ANSI and Braille codes
generateCodes: does [
	i: 32							;--we skip control chars
	blk: []							;--temporary block
	while [i <= 255] [
		idx: i + 10240				;--for Braille code value
		key: rejoin [to-char i]		;--map key is ANSI value
		value: rejoin [to-char idx]	;--map value is Braille code
		append append blk key value ;--update block as string values
		++ i
	]
	codes: make map! blk			;--OK a map from block
]

processString: func [astring [string!]
"Process ANSI string and returns Braille string"
][	
	str: copy ""
	foreach c astring [append str select codes form c]
	str
]

generateCodes
tstr: "Hello Fantastic Red and Rebol Worlds!" 
print tstr
print processString tstr