#!/usr/local/bin/r3
REBOL [ 
] 

;--we need sox: http://sox.sourceforge.net  
;--and http://sox.sourceforge.net/sox.html
;--eg: play -n synth 0.2 sine 700

mCode: make map! [
#"A"	".-"
#"B"	"-..."
#"C"	"-.-."
#"D"	"-.."
#"E"	"."
#"F"	"..-."
#"G"	"--."
#"H"	"...."
#"I"	".."
#"J"	".---"
#"K"	"-.-"
#"L"	".-.."
#"M"	"--"
#"N"	"-."
#"O"	"---"
#"P"	".--."
#"Q"	"--.-"
#"R"	".-."
#"S"	"..."
#"T"	"-"
#"U"	"..-"
#"V"	"...-"
#"W"	".--"
#"X"	"-..-"
#"Y"	"-.--"
#"Z"	"--.."
#"0"	"-----"
#"1"	"·----"
#"2" 	"··---"
#"3"	"···--"
#"4"	"····-"
#"5"	"·····"
#"6"	"-····"
#"7"	"--···"
#"8"	"---··"
#"9"	"----·"
#"."	".-.-.-"
#"," 	"--..--"
#":" 	"---..."
#"'"	".----."
#"("	"-.--."
#")" 	"-.--.-"
#"?"	"..--.."
#"@"	".--.-."
#"^""	"-.--.-"
#"=" 	"-.--.-"
#"+" 	".-.-."
#"-"	"-....-"
#"/"	"-..-."
#"x"	"-..-"
]

;--for abreviations strings
mShortCuts: make map! [
"BOT"	"-.-.-"				;--begin transmission
"EOT"	"...-.-"			;--end transmission 
"I2T"	"-.-"				;--invitation to transmit
"WFT"	".-..."				;--waiting for response
"VVV"	"···—···—···—"		;--transmission test
"ERR" 	"........"			;--transmission error
"OK"	"...-.-"			;--understood
]

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
str: "SOS REBOL TEAM"
sendCode str
print ""
print rejoin ["Message " str " sent"]