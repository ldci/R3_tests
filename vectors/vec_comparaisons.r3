#!/usr/local/bin/r3
REBOL [
]
;--Oldes's comment: when you construct a vector using the make method, you don't have to use the length integer.

;-- VECTOR can be initialized using a block with CHARs
;--R3 uses integer! or byte! datatype for char!
probe v: make vector! [integer! 16 5]										;--OK
probe v: make vector! [integer! 8 [#"^(00)" #"^(01)" #"^(02)" #"a" #"b"]]	;--OK
probe v: make vector! [integer! 16 [#"^(00)" #"^(01)" #"^(02)" #"a" #"b"]]	;--OK
probe v: make vector! [integer! 32 [#"^(00)" #"^(01)" #"^(02)" #"a" #"b"]]	;--OK
probe v: make vector! [byte! 8 [#"^(00)" #"^(01)" #"^(02)" #"a" #"b"]]		;--OK

comment [
;--Red uses char! datatype
probe v: make vector! [char! 16 5]											;--OK
probe v: make vector! [char! 8 [#"^(00)" #"^(01)" #"^(02)" #"a" #"b"]]		;--OK
probe v: make vector! [char! 16 [#"^(00)" #"^(01)" #"^(02)" #"a" #"b"]]		;--OK
probe v: make vector! [char! 32 [#"^(00)" #"^(01)" #"^(02)" #"a" #"b"]]		;--OK
]

probe v: make vector! [integer! 16 5]										;--OK
;probe v: make vector! [float! 64 5]										;--not OK
{returns:
== make vector! [decimal! 32 60 [
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
]]
}
probe v: make vector! [decimal! 64 5]										;--OK	
probe v: #(double! 5)														;--OK
{returns: == make vector! [decimal! 64 5 [0.0 0.0 0.0 0.0 0.0]]}
comment [
;--Red
probe v: make vector! [integer! 16 5]										;--OK
probe v: make vector! [float! 64 5]											;--OK
]

;--Randomize vector
;--r3
probe v1: make vector! [integer! 32  [1 2 3 4 5]]							;--OK
probe v2: random v1															;--OK

comment [
;--Red
probe v1: make vector! [integer! 32 [1 2 3 4 5]]							;--OK
probe v2: random v1															;--OK
]	

;--Binary 
;--R3
probe v: make vector! [integer! 16 #{010002000300}]							;--OK	
b: to binary! make vector! [decimal! 32 [1.0 -1.0]]							;--OK
probe v: make vector! compose [decimal! 32 (b)]								;--OK											

comment [
;--Red
probe v: make vector! [integer! 16 #{010002000300}]							;--not OK
b: to binary! make vector! [float! 32 [1.0 -1.0]]							;--not OK
probe v: make vector! compose [float! 32 (b)]								;--not OK
]

probe #(double! 4)
probe make vector! [decimal! 64 [0.0 0.0 0.0 0.0]]
probe #(byte! 4) 

n: 5
probe make vector! reduce n
probe make vector! compose [decimal! 64 (n)]
b: [0 1 2 3 4 5 6 7 8 9]
v: make vector! reduce length? b
repeat i length? b [v/:i: b/:i]
probe v



