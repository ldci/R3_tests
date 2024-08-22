#!/usr/local/bin/r3
REBOL [ 
] 
;--With hash!, you get a type that has all the navigational functionality that exists for series.

print-horizontal-line
print "hash! datatype"
h1: make hash! [a 10 b 50 c 100]
print ["length  :  " length? h1]		;--8	
print ["with key:  " h1/a h1/b h1/c]	;--path notation with key
print ["with index:" h1/2 h1/4 h1/6]	;--path notation with index
print ["with key:  " select h1 [a]]		;--key in a block
print ["with word: " select h1 'b]		;--key as a literal word
print ["with get:  " get 'h1/c]			;--with get word function

print-horizontal-line
;--hash with external variables
a: 100 b: 200 c: 300
blk: compose [n1 (a) n2 (b) n3 (c)]		;--make block
h2: make hash! blk						;--hash block
print [h2/2 h2/4 h2/6]	;--OK

print-horizontal-line
;--The hash! word can also be used without any key-values,
;--just to provide a series with fast lookup
languages: ["Red" "Rebol" "C" "Python" "Java"]
to-hash languages					;--for faster access
repeat i 5 [print languages/:i]
print-horizontal-line