#!/usr/local/bin/r3
REBOL [
]

;--les data du vecteurs sont sous la forme d'un bloc
;--on doit donc pouvoir utiliser les mêmes operateurs

;--short syntax
{vec: #(double! [
    0.1 0.9 0.0 
    0.3 0.0 0.7 
    0.1 0.1 0.8
    ]
)
}

vec: make vector! [decimal! 64 9 [0.1 0.9 0.0 0.3 0.0 0.7 0.1 0.1 0.8]]
comment [
;--for red
	vec: make vector! [float! 64 9 [ 0.1 0.9 0.0 0.3 0.0 0.7 0.1 0.1 0.8]]
]

b: to-block vec
;--navigating
;n: length? vec
n: vec/length
print ["Length:" n]
print ["Head:   " head vec]
print ["Index?  " index? vec]
print ["Tail?   " tail? vec]
print ["First:  " first vec]
print ["Last:   " last vec]
print ["Tail?   " tail? vec]
print ["Next:   " next vec]
print ["Back:   " back vec]
print ["At 4:   " at vec 4]
print ["At 1:   " at vec 1]

print ["Path/6: " vec/6]
i: 6
print ["Path/:i:" vec/:i]		;--use the :idx get word notation
print ["Pick:   " pick vec 6]
print ["Skip 3: " skip vec 3]
print ["Skip -3:" skip vec -3]
;--looping
print ["Forall:  "]
print [forall vec [print vec]]
print ["Foreach: "]
print [foreach v vec [print v]]
print ["While:   "]
while [not tail? vec] [
	print first vec
	vec: next vec 
]
print ["Tail?   " tail? vec] 

;--unsupported by R3 vectors (but supported by R3 blocks)
;clear
;extract
;take
;remove
;select
;find
;sort
;change
;append
;repend
;insert




