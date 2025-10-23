#!/usr/local/bin/r3
Rebol [
    title: "Rebol/BlurHash test"
]

blurhash: 	import 'blurhash
cv: 		import 'opencv
;--? blurhash

image: load %../pictures/test1.tiff	;use your own image
print ["Encoding image of size" as-yellow image/size]
hash: blurhash/encode image
print ["String: " hash]
print ["Decoding hash into image"]
blured: resize blurhash/decode hash 32x32 image/size
with cv [
	print "Source Image"
	imshow/name image "Source"
	waitkey 0;1000
	print "Blured Image"
	imshow/name blured "Blured"
	waitkey 0;1000
	print "Original Image"
	imshow/name image "Original"
	print "Any key to close"
	waitkey 0
]

