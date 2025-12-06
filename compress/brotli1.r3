#!/usr/local/bin/r3
REBOL [ 
] 
;--default Rebol compress and decompress functions
import 'brotli
bin: compress "some data from Rebol" 'br
print bin
txt: to string! decompress bin 'br
print txt