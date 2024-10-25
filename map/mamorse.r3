#!/usr/local/bin/r3
REBOL [ 
] 
;--We use minidaudio extension (https://github.com/Oldes/Rebol-MiniAudio)
;--Thanks to Oldes for his help

do %mcodes.r3										;--load morse codes
audio: import miniaudio								;--import miniaudio extension
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
print-horizontal-line
print "Begin transmission"
sendCode "BOT" 
print-horizontal-line
str: "sos Oldes"
sendCode str
print-horizontal-line
print rejoin ["Message " str " sent"]
print-horizontal-line
sendCode "OK"
print "Message received"
release device
print-horizontal-line