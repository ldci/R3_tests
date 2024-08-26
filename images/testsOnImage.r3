#!/usr/local/bin/r3
REBOL [ 
] 
;--test R2 compatibility (https://www.rebol.com/docs/image.html)
;--as documented: image effects should generally be done using the face EFFECT engine

cv: import opencv
random/seed now/time/precise
color: random white
delay: 300
im1: load %../pictures/lena.png				
imc: copy im1										
im2: make image! reduce [100x100 color]

;--copy tests
cv: import opencv
cv/imshow/name im1 "Source"	cv/waitkey delay
imc: copy im1
cv/imshow/name imc "Copy" cv/waitkey delay

;--To extract part of an image as a separate image
imcp: copy/part im1 220x200							
cv/imshow/name imcp "Copy/part"	
;cv/moveWindow "Copy/part" 260x4
cv/waitkey delay

;--Use the indexing functions to set the position of the COPY
imcp: copy/part skip im1 80x128 100x80
cv/imshow/name imcp "Copy/part"	 cv/waitkey delay

;--To copy an image (img2) into another image (img1) at a given location (xy)
change at im1 50x50 im2
cv/imshow/name im1 "Change at"	cv/waitkey delay

;--To extract sub-images from an image
im1: copy imc
imgs: copy []
size: 64x64 ;--width and height of each subimage 
repeat y 4 [
	repeat x 4 [
		xy: size * as-pair x - 1 y - 1 
		append imgs copy/part at im1 xy size
	] 
]
repeat i length? imgs [
	cv/imshow/name imgs/:i "Split" cv/waitkey 250	
	cv/moveWindow "Split" as-pair 1 (i * 20)
]
cv/waitkey delay


;--change
;--To set an area  of an image to blue:
change/dup at im1 100x100 blue 50x50				
cv/imshow/name im1 "Change/dup at"	cv/waitkey delay

;--To copy an image into another image  at a given location (xy):
im1: copy imc									
change at im1 10x10 im2	
cv/imshow/name im1 "Another image"cv/waitkey delay

;--To set the top line of an image to blue
im1: copy imc
;change/dup im1 blue im1/size/x			;--error					
;change/dup im1/rgb blue im1/size/x		;--no	
change/dup at im1 0x0 blue 512x1				
cv/imshow/name im1 "Top line" cv/waitkey delay

;--To remove the top line of an image
;remove/part im1 im1/size/x					;-error
remove/part tail im1/rgb negate im1/size/x	;--no
cv/imshow/name im1 "Remove" cv/waitkey delay

;--append 2 images
im1: make image! reduce [256x128 black]
im2: make image! reduce [256x128 green]
im3: make image! reduce [256x256 black]
im3/rgb: append im1/rgb im2/rgb
cv/imshow/name im3 "Append" cv/waitkey delay

;--changing pixels with poke at line 128
im1: make image! reduce [256x256 black]
repeat i 256 [
	p: as-pair i 128
	poke im1 p white
]
;--or with change
change/dup at im1 1x118 blue 256x1
change/dup at im1 1x138 red 256x1

change/dup at im1 118x1 blue 1x256
change/dup at im1 128x1 white 1x256
change/dup at im1 138x1 red 1x256

cv/imshow/name im1 "Poke"  
cv/waitkey 0
cv/destroyAllWindows



;--ANDing, ORing, and XORing Images not supported in R3
;--but supported by OpenCV extension



