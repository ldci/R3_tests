#!/usr/local/bin/r3
REBOL [ 
] 
;--?? system/catalog/compressions
;--[deflate zlib gzip br crush lzav lzma lzw zstd]
;import 'zstd
method: 'br										;-- a word
im1: load %../pictures/lena.png					;--use your png image
iSize: im1/size									;--image size
bin: im1/rgb									;--image as binary rgb
print ["Method    :" form method]	
print ["Image size:" iSize]
print ["Before compression:" nu: length? bin "bytes"]
t: dt [fc: compress bin method]					;--R3 compress
print ["After  compression:" nc: length? fc "bytes"]
ratio: round/to (nu - nc) / nu * 100 0.01		;--Compression ratio
print ["Compression :" form ratio "%"]
print ["Compress    :" third t * 1000  "ms"]
t: dt [fd: decompress fc method]				;--R3 decompress
print ["Decompress  :" third t * 1000  "ms"]
print ["After decompression:" length? fd "bytes"]
im2: make image! reduce [iSize fc]
im3: make image! reduce [iSize fd]
;--openCV module
cv: import opencv							;--for visualisation
cv/imshow/name im1 "Source"					;--show source image
cv/moveWindow "Source" 0x0
cv/imshow/name im2 "Compressed"				;--show Compressed image
cv/moveWindow "Compressed" 260x0
cv/imshow/name im3 "Decompressed"			;--show Decompressed image
cv/moveWindow "Decompressed" 520x0
cv/waitkey 0								;--any key to close
cv/destroyAllWindows						;--destroy all windows
