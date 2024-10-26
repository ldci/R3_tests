#!/usr/local/bin/r3
REBOL [ 
] 

do %mcodes.r3				;--load morse codes map (mCode)
							;--find is not supported for map! so we use 2 blocks
cblock: copy []				;--chars
mblock: copy []				;--strings

foreach [key value] mCode [
	append cblock key 		;--chars
	append mblock value		;--strings (morse code)
]

decodeMorseString: function [code [string!]
][
	char: cblock/(index? find mblock code)
]

foreach v mblock [print [v "=" decodeMorseString v]]


