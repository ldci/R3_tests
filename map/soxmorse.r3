#!/usr/local/bin/r3
REBOL [ 
] 

;--we need sox: http://sox.sourceforge.net  
;--and http://sox.sourceforge.net/sox.html
;--eg: play -n synth 0.2 sine 700

do %mcodes.r3				;--load morse codes
dot: 	0.1 				;--for dot beep
dash: 	dot * 3				;--for dash beep

beep: func [
	b	[decimal!]
][
	call/wait/shell rejoin ["play -n -q synth " form b " sine 500"]
]

;--send morse code for each letter in the string
sendCode: func [
	str	[string!]
][
	foreach c uppercase str [
		mc: select mCode c	;--get letter morse code value
		either not none? mc [print [c mc]] [print ""]
		foreach v mc [
			either v = #"." [beep dot][beep dash]
			wait dot 		;--delay between codes inside a letter
		]
		wait dot * 6		;--delay between letters in word
	]
]

;********************* Test program ********************
print-horizontal-line
str: "SOS REBOL TEAM"
sendCode str
print-horizontal-line
print rejoin ["Message " str " sent"]
print-horizontal-line