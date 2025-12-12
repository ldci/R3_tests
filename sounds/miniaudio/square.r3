#!/usr/local/bin/r3
REBOL [ 
] 
audio: import miniaudio										;--miniaudio extension
;? audio

devices: transcode audio/get-devices						;--get all sound devices
repeat i length? devices [print devices/playback/:i]		;--print sound devices
device: audio/init-playback/pause 1							;--use first device and pause it 
wave: audio/make-waveform-node audio/type_square 0.1 500.0	;--generate a sound
audio/start :device											;--start device
repeat i 100 [
	audio/play :wave 0:0:5									;--play sound
	wait 0.01												;--necessary
	;audio/stop :wave
]
release device												;--release the playback device (and all resources)
