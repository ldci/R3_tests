#!/usr/local/bin/r3
Rebol [
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
		append codesB reduce [value key];--idem but reverse order key value
		++ i
	]
]

processString: func [
"Processes ANSI string or Braille string"
	string [string!]
	/ansi /braille
][	
	str: copy ""
	;--for ansi use select/case, characters are case-sensitive
	if ansi [foreach c string [append str select/case codesA form c]] 
	if braille [foreach c string [append str select codesB form c]]
	str
] 

generateCodes
print-horizontal-line
print a: "Hello Fantastic Red and Rebol Worlds!"  
print-horizontal-line
print b: processString/ansi a
print-horizontal-line
print c: processString/braille b
print-horizontal-line