#!/usr/local/bin/r3
REBOL [ 
] 

volume: 	30			;--default volume
returnStr: 	""			;--selected voice
ret: 		-1			;--error value

;--install zenity (https://formulae.brew.sh/formula/zenity)

;--all macOS voices
getVoices: does [
	voicesList: "" 
	call/shell/output "say -v '?'" voicesList
	save %nvoices.txt voicesList
]


;--get MacOS voices 
getVoicesList: does [
	;--Zenity commandes
	commands: [
		" --title 'MacOS Voices'"
		" --list"
		" --text 'Pick a voice'"
		" --column 'Voices'"
		" --width '500'"
		" --height '500'"
	]
	prog: "cat nvoices.txt | zenity"		;--OS shell commands
	append prog commands
	ret: call/shell/output prog returnStr
	;print returnStr
	if ret = 0 [
		trim/with returnStr "{"
		trim/with returnStr "}"
		tmp: split returnStr "#"
		voice: first split tmp/1 space
		language: second split tmp/1 space
		sentence: trim/lines tmp/2		
	]
]
generate: does [
	call/wait/shell rejoin ["osascript -e 'set volume output volume " volume  "'"]
	command: rejoin ["say -v " voice  " --interactive=/red " sentence]
	call/shell/wait command
]

unless exists? %nvoices.txt [getVoices]
getVoicesList
if ret = 0 [generate]
