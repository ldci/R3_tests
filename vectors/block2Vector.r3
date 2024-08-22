#!/usr/local/bin/r3
REBOL [
]

;--to-block make vector! [integer! 32 10] OK
;--to-vector block : cannot MAKE #(vector!) from: [0 1 2 3 4 5 6 7 8 9]
;--make vector! [0 1 2 3 4 5 6 7 8 9] supported by Red and not by r3 

block2Vector: func [
	b		[block!]
	bitSize	[integer!]
	vtype 	[word!] 
][
	n: length? b
	case  [
		vtype = 'char [
			repeat i n [b/:i: to integer! b/:i]	;--avoid errors
			v: make vector! compose [integer! (bitSize) (n)]
		]
		vtype = 'integer [v: make vector! compose [integer! (bitSize) (n)]]
		vtype = 'decimal [v: make vector! compose [decimal! (bitSize) (n)]]
	]
	repeat i n [v/:i: b/:i]
	v
]

print "With internal block"
print ["Char:   " make vector! [integer! 8  [#"A" #"B" #"a" #"b"]]]
print ["Integer:" make vector! [integer! 8  [1 2 3 4]]]
print ["Decimal:" make vector! [decimal! 64 [1.0 2.0 3.0 4.0]]]

print "With external block"
b: [#"A" #"B" #"C" #"a" #"b" #"c"]
print ["Char:   " block2Vector b 8 'char]
b: [0 1 2 3 4 5 6 7 8 9]
print ["Integer:" block2Vector b 64 'integer]
b: [1.1 2.2 3.3 4.4 5.5 6.6 7.7 8.8 9.9]
print ["Decimal:" block2Vector b 64 'decimal]


 



