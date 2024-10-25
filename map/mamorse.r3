#!/usr/local/bin/r3
REBOL [ 
] 
;--We use minidaudio extension (https://github.com/Oldes/Rebol-MiniAudio)
;--Thanks to Oldes for his help

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

audio: import miniaudio

dot: 	0.1											;--for dot beep
dash: 	dot * 3										;--for dash beep

with audio [
	device: init-playback 1							;--initialize first audio device
	wave: make-waveform-node type_square 0.5 500.0	;--make square waveform
	stop snd: play :wave							;--sound is paused
	;--beep function accepting time how long 
	beep: function [time [decimal! time!]
	][
        start :snd									;--start sound
        wait time									;--play during required time
        stop :snd									;--stop sound
        wait 0.1									;--rebol pause
    ]	
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
print "Begin transmission"
sendCode "BOT" 
print ""
str: "sos to Oldes"
sendCode str
print ""
print rejoin ["Message " str " sent"]
print ""
sendCode "OK"
print "Message received"
release device