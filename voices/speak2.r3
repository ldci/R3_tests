#!/usr/local/bin/r3
Rebol [
]
speak: import speak					;--import module
with speak [
	list-voices						;--list all voices
	say/as "Hello Red world!" 15	;--english voice
	say/as "Bonjour Red!" 166		;--french voice
]


