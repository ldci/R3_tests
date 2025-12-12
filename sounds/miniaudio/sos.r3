#!/usr/local/bin/r3
REBOL [ 
] 

;--from Oldes 

ldot: 	0.1 					;--for dot beep
ldash: 	ldot * 3				;--for dash beep

audio: import 'miniaudio
with audio [
    ;; initialize an audio device...
    device: init-playback 1

    ;; create a waveform
    wave: make-waveform-node type_sine 0.5 440.0

    ;; start the sound to be reused for the beep (paused)
    stop snd: play :wave

    ;; beep function accepting time how long 
    beep: function[time [decimal! time!]][
        start :snd
        wait time
        stop :snd
        wait 0.1
    ]
    dot:  does[beep ldot]
    dash: does[beep ldash]
]
print "S" dot dot dot wait ldot * 6
print "O" dash dash dash wait ldot * 6
print "S" dot dot dot wait ldot * 6