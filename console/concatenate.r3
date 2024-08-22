#!/usr/local/bin/r3
REBOL [ 
] 
;--always returned value = string!
print-horizontal-line
print join 0 [1 2 3]			;--value is inserted at the head 
print join 4 [1 2 3]			;--value is inserted at the head
print join "4" ["1" "2" "3"]	;--value is inserted at the head
print join "0" 3				;--value is inserted at the head
print-horizontal-line
;--ajoin: reduces and joins a block of values into a new string.
a: [1 2 3]
print ajoin a					;--a string
a: [1.0 2.0 3.0]
print ajoin a					;--a string
print-horizontal-line
;--rejoin: reduces and joins a block of values
a: [1 2 3]						
print rejoin a					;--a string
a: [1.0 2.0 3.0]
print rejoin a
print-horizontal-line

