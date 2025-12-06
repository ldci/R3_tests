#!/usr/local/bin/r3
Rebol [
]
;--Using Oldes's extension (codec-braille)
import 'codec-braille

;************************* Test program ***********************
str: "Hello Fantastic Rebol and Red Worlds!"
print-horizontal-line
print str
print-horizontal-line
print braille: encode 'braille str
print-horizontal-line
print txt: decode 'braille braille
print-horizontal-line