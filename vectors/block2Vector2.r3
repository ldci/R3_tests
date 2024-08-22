#!/usr/local/bin/r3
REBOL [
]

;--Oldes's very elegant suggestion with map and words
block2Vector: function[
	type 	[word!] 
	block 	[block!]
][
	make vector! compose/only select make map! [
		int8    [integer! 8  (block)]
		int16   [integer! 16 (block)]
		int32   [integer! 32 (block)]
		int64   [integer! 64 (block)]
		uint8   [unsigned integer! 8  (block)]
		uint16  [unsigned integer! 16 (block)]
		uint32  [unsigned integer! 32 (block)]
		uint64  [unsigned integer! 64 (block)]
		float32 [decimal! 32 (block)]
		float64 [decimal! 64 (block)]
		double	[decimal! 64 (block)]
	] type
]

probe b: [#"A" #"B" #"a" #"b"]
probe block2vector 'int8 b 
probe block2vector 'uint16 b  
probe block2vector 'int32 b
probe block2vector 'int64 b
probe block2vector 'float32 b
probe block2vector 'float64 b
probe block2vector 'double b
