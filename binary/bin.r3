#!/usr/local/bin/r3
Rebol [
]
; >>> operator not supported by r3
bin: to integer! #{45444571}
print bin
sign: bin >> 31
expo: bin << 1 >> 24
mant: bin << 9 >> 9
print (pick [1 -1] 1 + sign) * (2 ** (expo - 127)) * (mant / (2 ** 23) + 1)

;--better
print binary/read #{45444571} 'F32BE