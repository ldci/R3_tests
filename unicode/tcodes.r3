#!/usr/local/bin/r3
REBOL [
]

;--Char is limited to 65535 integer value (unicode 16-bit)
f: read/string %codesV14.txt

codesValues: copy[]		;--code values	hexa form
codesChar: copy []		;--unicode chars
codesLabel: copy []		;--labels

parse f [any [thru "title='" copy text to "'" 
			(
				count: 0
				trim/with text ":" 
				c: split text " "
				n: length? c
				foreach v c [if (find v  "U+") [count: count + 1 append codesValues v]]
				;count: count + 1
				;probe to-char c/:count
				append codesChar c/:count
				c: skip c count
				n: length? c
				s: copy ""
				foreach v c [append s rejoin [" " v]]
				append codesLabel s
			)
			]
	]

repeat i  (length? codesChar) [print [i codesValues/:i codesChar/:i codesLabel/:i]]