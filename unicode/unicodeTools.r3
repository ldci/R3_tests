#! /usr/local/bin/r3
REBOL [
	Title: "uniCodeTools"
	Author: "ldci"
	Version: 1.0
	Notes: {This code allows to generate emojis or unicode characters}
]
;--Char is limited to 65535 (16-bit) integer value

makeUniCode: func [s [string!] c [char! string! integer! issue!] return: [string!]][
	out: ""	
	t: type? c
	if t = issue! [c: to-integer c out: rejoin [s form to-char c]]
	if any [t = char! t = integer!] [out: rejoin [s form to-char c]]	
	if t = string! [out: rejoin [s c]]
	out
]

makeUnicodeFromChar: func [s [string!] c [char!] return: [string!]][
	rejoin [s form c]
]

makeUnicodeFromString: func [s [string!] c [string!] return: [string!]][
	rejoin [s c]
]

makeUnicodeFromNumber: func [s [string!] c [integer! issue!] return: [string!]][
	if type? c = issue! [c: to-integer c]
	rejoin [s form to-char c]
]

;--only integer values in block
makeUnicodeFromBlock: func [
	s [string!] 
	b [block!] 
	return: [string!]
][
	n: length? b
	repeat  i n [append s form to-char b/:i]
]


print-horizontal-line
print "From Char"
print makeUnicodeFromChar "" #"^(2615)"
print makeUnicodeFromChar "Validate " #"^(2705)"
print-horizontal-line

print "From String"
print makeUnicodeFromString "" "^(2615)"
print makeUnicodeFromString "Validate " "^(2705)"
print-horizontal-line

print "From Integer Value"
print makeUnicodeFromNumber "" 9749
print makeUnicodeFromNumber "Validate " 9989
print-horizontal-line

print "From Hexadecimal Value"
print makeUnicodeFromNumber "" #0000000000002615
print makeUnicodeFromNumber "Validate " #0000000000002705
print-horizontal-line

print "From integer Block"                                 
print makeUnicodeFromBlock "" [9995 9994 9989]     
print-horizontal-line 

print makeUniCode "Validate " 9995
print makeUniCode "Validate " #"^(2615)"
print makeUniCode "Validate " "^(2705)"
print-horizontal-line


{i: 128512
until [
	c: form to-hex i
	print [i makeUnicodeFromString "" c]
	i: i + 1
	i = 128591
]}
;repeat i 128591 [print [i makeUnicodeFromNumber "" i]]
