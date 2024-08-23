#!/usr/local/bin/r3
REBOL []
{I like the number datatype, which lets you write general functions for integer, 
float (decimal) and percent values. We can also use money and pair datatypes}

_div: func [
	a [number! money! pair!]
	b [number!]
][
	either b <> 0 [return a / b] [return 0]
]

print-horizontal-line
print _div 3 3 							;--an integer!
print _div 3 2 							;--a float!
print _div 3.0 2 						;--a float!
print _div 3 2.0 						;--a float!
print _div 3.0 2.0 						;--a float!
print _div 50% 2 						;--a float!
print _div 100% 2.0 					;--a float!
print _div 100% 0.0 					;--an error (0)
print round/to _div $1240.0 2 0.001		;--a float!
print round/to _div $1240.5 2.5 0.001	;--a float!
print _div 100x100 2					;--a pair!
print _div 100x100 2.5					;--a pair!
print-horizontal-line
 
;Then it's up to me to manage the returned values according to the returned type.


