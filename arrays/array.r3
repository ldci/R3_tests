#!/usr/local/bin/r3
REBOL [ 
] 
print-horizontal-line
a: array 9					;--1D array no values
b: array/initial 9 0		;--1D array with 0
c: array/initial [3 3] 1	;--2D array with 1
c: array/initial [3 3 3] 1	;--3D array with 1
random/seed 1.0
c: array/initial [3 3 3] random 1.0
random/seed 100
b: array/initial 9 random 100
probe a 
probe b 
probe c 
print-horizontal-line
a: [[1 2 3][4 5 6][7 8 9]]		;--Red like 3x3 2D array
probe a 
probe a/1
probe a/2
probe a/3
print-horizontal-line

;PRINT-TABLE headers block
h: ["A" "B" "C"];--headers block must contain strings
print-table h a
print-horizontal-line

a: [5 9 1 3 4 10 2 7 6]
probe a 
print ["Find Max: " find-max a]
print ["Find Min: " find-min a]

print ["Find Max: " first find-max a]
print ["Find Min: " first find-min a]

print-horizontal-line