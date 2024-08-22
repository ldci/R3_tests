#!/usr/local/bin/r3
REBOL [ 
] 

;--pad modifies the original string!
;--Total size (in characters) of the new string (pad on left side if negative).
;--Red uses pad/left 

str: "REBOL3"
n: length? str				;--6
;r: pad str n + 3			;--add 3 spaces to the right
r: pad str 9				;--add 3 spaces to the right
str: "REBOL3"
;l: pad str negate (n + 3)	;--add 3 spaces to the left
l: pad str -9				;--add 3 spaces to the left
print-horizontal-line
print "probe test"
probe r
probe l
print-horizontal-line
print "print test"
print r
print l
print-horizontal-line
print "char test"
str: "REBOL3"
r: pad/with str 9 to-char 9608		;--with character
str: "REBOL3"
l: pad/with str -9 to-char 9608		;--with character
print r
print l


