#!/usr/local/bin/r3
REBOL [ 
] 

msecToHZ: func [
	period [integer!] 	;--in msec
][
	1 / (period / 1000)	;--returns Hz
]

freqToSec: func [
	frequency [integer!] ;--in Hz
][
	round/to (1 / frequency) 0.00001	;--returns sec
]

freqToMSec: func [
	frequency [integer!] 	;--in Hz
][
	round/to (1 / frequency) * 1000	 0.01;--returns msec
]



print ["For a 50 ms signal, frequency = " msecToHZ 50 "Hz"]
print ["For a 440 Hz signal, duration = " freqToSec 440 "sec"]
print ["For a 440 Hz signal, duration = " freqToMSec 440 "msec"]
print ["For a 20 Hz signal, duration  = " freqToSec 20 "sec"]
