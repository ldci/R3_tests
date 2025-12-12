#!/usr/local/bin/r3
REBOL [ 
] 

;--based on oldes's examples
audio: import 'miniaudio
;--list all available devices:
devices: transcode audio/get-devices
;? devices

if any [
	print as-blue "Audio device found"
	empty? devices/playback
	devices/playback/1 = "Null Audio Device"
][
	;--GitHub Actions on Windows and macOS does not have any audio device.
	print as-purple "No audio device found."
	quit
]


file: %../sound_files/windows.wav ;12StrStart.aiff; 
;--init a playback device (first available)...
;--keep the reference to the device handle, else it will be released by GC!
;--(for test purpose, not starting the playback automatically)
probe device: audio/init-playback/pause 1

;--load a sound for later use...
sound: audio/load file
print as-green sound/source
device/frames: 44100
;--delay the start of the sound in frames
sound/start: 44100
print ["Sound will start in" sound/start - device/frames "frames (1s)..."]
audio/start device ;--finally start the paused playback device
audio/start sound  ;--this sound will start after 44100 frames!
wait 1
print "Now there should be the sound!"
wait 1



;; work in Rebol as usually
wait 0:0:1
release device

