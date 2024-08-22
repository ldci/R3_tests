#!/usr/local/bin/r3
REBOL [
]
;--"QUERY on vector"
;--when vector is created, these properties are public
;--see t-vector.c
;--Oldes's comment: when you construct a vector using the make method, you don't have to use the length integer.
v: make vector! [unsigned integer! 16 [1 2 3 4]]
probe v
print ["Type:   " v/type]
print ["Size:   " v/size]
print ["Signed: " v/signed]
print ["Length: " v/length]
;--to get data
prin   "Data:    "
b: [] repeat i v/length [append b v/:i]
print b
print lf

print "With Query:"
probe b: query v vector! none!
probe b: query v [type size signed length]
print lf

;--REFLECT on vector
print "With Reflect"
print ["Spec:   " reflect v 'spec]
print ["Type:   " reflect v 'type]
print ["Size:   " reflect v 'size]
print ["Signed: " reflect v 'signed]
print ["Length: " reflect v 'length]





