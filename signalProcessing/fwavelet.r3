#!/usr/local/bin/r3
REBOL [ 
]
;--thanks to http://home.base.be/epm6604b/index.html for the C Code and details

sqrt_2: square-root 2

haar: func [arr [vector!] n [integer!]][
	dimension:  power 2 n		;--vector size
	count: to-integer dimension
	while [count > 1]  [
		moy: copy []
		diff: copy[]
		halfCount: count / 2
		;--means and differences for each pairs
		;--use a 0 index for easier calculation
		for i 0 halfCount - 1 1 [
			append moy (arr/(i * 2 + 1) + arr/((i * 2) + 2)) / 2.0  	;--means
			append diff arr/(i * 2 + 1) - moy/(i + 1)					;--differences	
		]
		;--replace vector values by calculated means and differences (1-based index!)
		for i 1 halfCount 1 [
			arr/(i): moy/:i
			arr/(i + halfCount): diff/:i
		]
		count: count / 2
	]
	arr
]

haarInverse: func [arr [vector!] n [integer!]][
	dimension:  power 2 n
	count: 2
	while [count <= dimension]  [
		halfCount: count / 2
		temp: array/initial count 0.0
		;--calculate left and right parts of the vector
		for i 0 halfCount - 1  1 [
			temp/((i * 2) + 1):  arr/(i + 1) + arr/(i + halfCount + 1)
			temp/((i * 2) + 2):  arr/(i + 1) - arr/(i + halfCount + 1)
		]
		;--write left and right parts in the vector 
		for i 1 count 1 [arr/:i: temp/:i]
		count: count * 2
	]
	arr
]

haarNormalized: func [arr [vector!] n [integer!]][
	dimension:  power 2 n		; taille du vecteur 
	count: to-integer dimension
	while [count > 1]  [
		moy: copy []
		diff: copy[]
		halfCount: count / 2
		;--means and differences for each pairs
		;--use a 0 index for easier calculation
		for i 0 halfCount - 1 1 [
			append moy (arr/((i * 2) + 1) + arr/((i * 2) + 2)) / sqrt_2  		;--means
			append diff (arr/((i * 2) + 1) - arr/((i * 2) + 2)) / sqrt_2		;--differences	
		]
		; replace arr values by calculated mean and differences (1-based index!)
		for i 1 halfCount  1 [
			arr/:i: round moy/(i)
			arr/(i + halfCount): round diff/:i 
		]
		count: count / 2
	]
	arr
]

haarNormalizedInverse: func [arr [vector!] n [integer!]][
	dimension:  power 2 n
	count: 2	
	while [count <= dimension]  [
		halfCount: count / 2
		temp: array/initial count 0.0
		;--calculate left and right parts of the vector
		for i 0 halfCount - 1  1 [
			temp/((i * 2) + 1):  arr/(i + 1) + arr/(i + halfCount + 1) / sqrt_2
			temp/((i * 2) + 2):  arr/(i + 1) - arr/(i + halfCount + 1) / sqrt_2
		]
		;--write left and right parts in the vector
		for i 1 count 1 [arr/:i: round/even temp/:i]
		count: count * 2
	]
	arr
]

