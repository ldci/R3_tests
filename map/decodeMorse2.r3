#!/usr/local/bin/r3
REBOL [ 
] 
audio: import miniaudio								;--import miniaudio extension
speak: import speak									;--import speak module
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
	foreach v code [
		either v = #"." [beep dot][beep dash]
		wait dot 		;--delay between codes inside the string
	]
	wait dot * 6		;--delay before a new string
	char: cblock/(index? find mblock code)
]

;***************************Test program***************************
print "Receiving message..."
print-horizontal-line
msg: ""
print c: decodeMorseString "..." append msg c	;--S
print c: decodeMorseString "---" append msg c	;--O
print c: decodeMorseString "..." append msg c	;--S
print-horizontal-line
ret: rejoin ["Hello Captain, message received is " msg "! What can we do?"]
print ret 
speak/say/as ret 15
print-horizontal-line


