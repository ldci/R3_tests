#!/usr/local/bin/r3
REBOL [
]
;--Red
comment [
make vector! 10
make vector! [char! 16 1000]
make vector! [float! 64 1000]
make vector! [1.1 2.2 3.3 4.4]
make vector! [integer! 8 [1 2 3 4]]
make vector! [integer! 32 4 [1 2 3 4]]
make vector! [float! 32 4 [1.0 2.0 3.0 4.0]]
{The following actions are added to vector! datatype: clear, copy, poke, 
remove, reverse, take, sort, find, select, add, subtract, multiply, divide, 
remainder, and, or, xor.}
x: make vector! [1 2 3 4]
y: make vector! [2 3 4 5]
x + y
]

;--Oldes comment: when you construct a vector using the make method, you don't have to use the length integer.
;--Rebol R3
probe make vector! 10
;probe make vector! [char! 16 10] ;--not supported so use 8-bit integer
make vector! [integer! 8 [#"^(00)" #"^(01)" #"^(02)" #"a" #"b"]]
probe make vector! [decimal! 64 10]
;probe make vector! [1.1 2.2 3.3 4.4]
probe make vector! [float! [1.0 2.0 3.0 4.0]]
probe make vector! [integer! 8  [1 2 3 4]]
probe make vector! [integer! 32 [1 2 3 4]]  
probe make vector! [float! [1 2 3 4]]
probe make vector! [decimal! 64 [1 2 3 4]]

; equal? #(int64! [1 2 3 4]) make vector! [integer! 64 [1 2 3 4]]  
;== #(true)

probe vec: #(double! [
    	0.1 0.9 0.0 
        0.3 0.0 0.7 
        0.1 0.1 0.8
        ]
    )
    
vectRandomI: func [v [vector!] value [number!]
][
	; for interpreted
	n: length? v
	i: 1
	while [i <= n] [v/(i): random value i: i + 1]
	v
]
vectRandomC: func [v [vector!] value [number!]
][
	; for compiled
	forall v [v/1: random value]
	v
]


vectSameValue: func [v [vector!] value [number!]][
	n: length? v
	collect [i: 0 until [keep i: i + 1 v/:i: value i = n]]
	v
]

a: make vector! [decimal! 64 10]
;probe vectRandomI a 1.0
;print length? a
;probe vectRandomC a 10.0
;print length? a

probe  vectSameValue a 10


