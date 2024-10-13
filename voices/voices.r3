#!/usr/local/bin/r3
Rebol [
]
;--for macOS 15
voices: 	[]
languages: 	[]
sentences:	[]
labels:		[]
filename:  	%voices.txt

;--all macOS voices
getVoices: does [call/shell/output "say -v '?'" filename]

loadVoices:  does [
	vfile: read/lines filename					;--load all voices
	foreach v vfile [
		str: split v "#" 						;--split str
		append sentences str/2 					;--sentence sample
		n: (length? str/1) - 10					;--length of the string (without code)		
		append labels copy/part str/1 n			;--voice and description
		append voices first split str/1 space 	;--just the voice
		append languages at tail str/1 -10		;--international code
	]
]

talk: func [index [integer!]
][
	unless none? languages/:index [
		print ["Index:" index "Language:" languages/:index labels/:index]
		prog: rejoin ["say -v " voices/:index " " sentences/:index]
		print as-yellow prog
		call/shell/wait prog
	]
]

;--------------------------Test Program------------------------------
random/seed now/time
unless exists? filename [getVoices]
loadVoices
repeat i 10 [talk random length? voices]