#!/usr/local/bin/r3
REBOL [ 
] 
import 'zstd	;--Zstandard not yet in R3 bulk; must be imported
;methods: [deflate zlib gzip br crush lzav lzma lzw lz4 zstd];--block of words
methods: copy system/catalog/compressions
n: length? methods
level: 5 						;--0..9
img: load %../pictures/in.png	;--use your own image	
bin: img/rgb					;--image as RGB binary
len: length? bin				;--size for decompression
repeat i n [
	method: methods/:i
	print i
	print ["Method    :" method]	
	print ["Image size:" img/size]
	print ["Before compression:" nU: len "bytes"]
	t: dt [cImg: compress/level bin method level]				;--R3 compress
	print ["After  compression:" nC: length? cImg "bytes"]
	ratio: round/to 1.0 - (nC / nU) * 100 0.01					;--compression ratio
	print ["Compression :" form ratio "%"]
	print ["Compress    :" third t * 1000  "ms"]				;--in msec
	t: dt [uImg: decompress/size cImg method len]				;--R3 decompress
	print ["Decompress  :" third t * 1000  "ms"]				;--in msec
	print ["After decompression:" length? uImg "bytes"]
	print-horizontal-line
]
if system/options/script [ask "DONE"]
