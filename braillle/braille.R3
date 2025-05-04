#!/usr/local/bin/r3
Rebol [
]
;--Electronic Braille's cell is a 2x4 matrix with 8 dots
comment [dots order 
	1 4 
	2 5 
	3 6 
	7 8
]

;--generate ANSI and Braille codes
generateCodes: does [
	i: 0								;--we use all chars
	codesA: #[]							;--a map object ANSI->Braille
	codesB: #[]							;--a map object Braille->ANSI
	while [i <= 255] [
		idx: i + 10240					;--for Braille code value
		key: form to-char i				;--map key is ANSI value
		value: form to-char idx			;--map value is Braille code
		append codesA reduce [key value];--update map as string values
		append codesB reduce [value key];--idem but reverse order 
		++ i
	]
]

processANSI: func [
"Processes ANSI string and returns Braille string"
	string [string!]

][	
	str: copy ""
	;--select/case Characters are case-sensitive
	foreach c string [append str select/case codesA form c]
	str
]

processBraille: func [
"Processes Braille string and returns ANSI string"
	string [string!]
][	
	str: copy ""
	foreach c string [append str select codesB form c]
	str
]


generateCodes
a: "Hello Fantastic Red and Rebol Worlds!"  
print a
print-horizontal-line
print b: processANSI a
print-horizontal-line
print c: processBraille b
