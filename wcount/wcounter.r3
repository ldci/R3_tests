#!/usr/local/bin/r3
REBOL [ 
	author: @ldci
]

punct: ajoin [",.;:!?-_(){}'@#&" form #"^""]	;--excluded punctation symbols

removePunct1: function [
	aText [string!]
][
	trim/with aText punct						;--trim method
]

removePunct2: function [
	aText [string!]
][
	remove-each c aText [find punct c]			;--remove-each method
]

removePunct3: function [
	aText [string!]
][
	_punct: charset punct
	parse aText [any [remove _punct | skip]]	;--parse method
]

flag: 1
tmp: read/string %cinderella.txt
txt: lowercase tmp				;--lowercase for all text
trim/lines txt					;--suppress all line breaks and extra spaces in text
copycat: copy txt				;--a copy since methods modify text
switch flag [
	1	[removePunct1 copycat]	;--trim method
	2	[removePunct2 copycat]	;--remove-each method
	3	[removePunct3 copycat]	;--parse method
]

t: dt [
	wordBlock: split copycat space	;--get all words
	sort wordBlock				   	;--sort words a..z
	n: (length? wordBlock)
	count: i: 1
	wordCount: copy []
	key2: wordBlock/(i + 1)											;--for while loop
	while [not none? key2] [
		key1: wordBlock/(i) key2: wordBlock/(i + 1)					;--test keys
		either key1 == key2 
			[++ count]												;--increment count
			[append wordCount ajoin [key1 ": " count] count: 1] 	;--new entry with count = 1
	++ i
	]
	wordsList: copy ""
	foreach v wordCount [append wordsList rejoin [v newline]]
]

print uppercase wordsList
print ajoin [length? wordsList " words in " third t * 1000 " msec"]