#!/usr/local/bin/r3
REBOL [ 
] 
;--[deflate zlib gzip br crush lzma]
method: 'zlib									;--a word
img: load %../pictures/in.png					;--use your own image	
bin: img/rgb									;--image as RGB binary
print ["Method    :" form method]	
print ["Image size:" img/size]
print ["Before compression:" nU: length? bin]
t: dt [cImg: compress bin method]				;--R3/Red compress
print ["After  compression:" nC: length? cImg]
ratio: round/to 1.0 - (nC / nU) * 100 0.01		;--compression ratio
print ["Compression :" form ratio "%"]
print ["Compress    :" third t * 1000  "ms"]	;--in msec
t: dt [uImg: decompress cImg method]			;--R3/Red decompress
print ["Decompress  :" third t * 1000  "ms"]	;--in msec
print ["After decompression:" length? uImg]