#!/usr/local/bin/r3
REBOL [ 
	needs: 3.18.1
]

do %Tools/fwavelet.r3

signal: make vector! [float! [7.0 1.0 6.0 -6.0 1.0 -5.0 4.0 2.0 -3.0 8.0]]
n: to-integer log-2 length? signal ;--we need a 2^N integer value

print as-blue rejoin ["Data	  :" signal] 
;--Haar transform
haar signal n
print as-red rejoin ["Haar	  :" signal]
;--Inverse transform: we must get back the original signal
haarInverse signal n
print as-green rejoin ["Inverse	  :" signal]
;--with normalization
print as-blue rejoin ["Data	  :" signal]
haarNormalized signal n
print as-red rejoin["Normalized:" signal]
;--Inverse transform: we must get back the original signal
haarNormalizedInverse signal n
print as-green rejoin ["Inverse   :" signal]
print as-yellow "OK"

