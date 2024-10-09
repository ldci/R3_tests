#!/usr/local/bin/r3
REBOL [
]
;--Arabic <> Roman conversions
;--table from rosettacode.org (Didier Cadieu) with some corrections
table: [1000 M 900 CM 500 D 400 CD 100 C 90 XC 50 L 40 XL 10 X 9 IX 5 V 4 IV 1 I]

toRoman: function [n [integer!] return: [string!]][
    out: copy ""
    foreach [a r] table [while [n >= a][append out r n: n - a]]
    out
]

rvalue: function [c [char!]return: [integer!]][
	switch c [
		 #"M" [v: 1000]
		 #"D" [v: 500]
		 #"C" [v: 100]
		 #"L" [v: 50]
		 #"X" [v: 10]
		 #"V" [v: 5]
		 #"I" [v: 1]
	]
	v
]

;--from Roman to Arabic notation with recursive function
toArabic: function [s [string!] return: [integer!]] [
	nc: length? s 
	either nc = 1 [r: rvalue s/1] [
		n1: rvalue  s/1
		if n1 < rvalue s/2 [n1: negate n1]
		s: next s
		r: n1 + toArabic s
	]
	r
]


print-horizontal-line
print "Arabic to Roman"
repeat i 100 [print [i "=" toRoman i]]
print-horizontal-line
print "Roman to Arabic"
repeat i 100  [s: toRoman i print [s "=" toArabic s ]]
print-horizontal-line