#!/usr/local/bin/r3
REBOL [
	author: @ldci
]

v1: make vector! [integer! 32 [0 1 2 3 4 5 6 7 8 9]]
v2: make vector! [integer! 32 [10 11 12 13 14 15 16 17 18 19]]
v3: make vector! [integer! 32 [-5 2 -3 2 -3 3 -4 1 -1 2]] ;--difference of 2 vectors 

print-horizontal-line
;--1 sample
mu: 5
print "One sample"
print ["t  = " t: abs (v1/mean - mu) / (v1/sample-deviation / sqrt to decimal! v1/length)]
print ["df = " v1/length - 1]
print ["p  =  0.005" as-yellow "Non significant"]
print-horizontal-line

;--paired
print "Paired"
print ["t  = " t: abs (v3/mean - 0) / (v3/sample-deviation / sqrt to decimal! v3/length)]
print ["df = " v3/length - 1]
print ["p  =  0.005" as-yellow "Non significant"]
print-horizontal-line

;--independent samples
print "Two independent samples"
print ["t  = " t: abs( v1/mean - v2/mean) / sqrt((v1/sample-deviation ** 2 / v1/length) 
	+ (v2/sample-deviation ** 2 / v2/length))]
print ["df = " v1/length + v2/length - 2]
print ["p  =  0.001" as-red "Significant"]

print-horizontal-line

;-- for t-table reading uncomment the next line
;browse https://www.sjsu.edu/faculty/gerstman/StatPrimer/t-table.pdf
;--for a nice open-source statistical tool: https://jasp-stats.org
