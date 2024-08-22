#!/usr/local/bin/r3
REBOL [ 
] 
{image-diff: Count difference (using weighted RGB distance) of two images of the same size. 
Returns 0% if images are same and 100% if completely different.}

i1: make image! [10x10 255.0.0]	;--red image
i2: make image! [10x10 255.0.0]	;--red image
i3: make image! [10x10 0.255.0]	;--green image
print-horizontal-line
print ["im1 im2 difference:" image-diff i1 i2]
print-horizontal-line
print ["im1 im3 difference:" round image-diff i1 i3]
print-horizontal-line