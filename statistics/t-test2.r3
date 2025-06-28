#!/usr/local/bin/r3
REBOL [
	author: @ldci
]

v1: make vector! [integer! 32 [0 1 2 3 4 5 6 7 8 9]]
v2: make vector! [integer! 32 [10 11 12 13 14 15 16 17 18 19]]
v3: make vector! [integer! 32 [-5 2 -3 2 -3 3 -4 1 -1 2]] ;--difference of 2 vectors 

;--Oldes's suggestion to use the most optimal query
set [mean1 std1 n1] query v1 [:mean :sample-deviation :length]
set [mean2 std2 n2] query v2 [:mean :sample-deviation :length]
set [mean3 std3 n3] query v3 [:mean :sample-deviation :length]

n1: n1 * 1.0 n2: n2 * 1.0 n3: n3 * 1.0 ;--for sqrt 

print-horizontal-line
;--1 sample
mu: 5
print "One sample"
print ["t  = " t: abs (mean1 - mu) / (std1 / sqrt n1)]
print ["df = " n1 - 1]
print ["p  =  0.005" as-yellow "Non significant"] 	;-- <2.250

print-horizontal-line
;--paired
print "Paired"
print ["t  = " t: abs (mean3 - 0) / (std3 / sqrt n3)]
print ["df = " n3 - 1]
print ["p  =  0.005" as-yellow "Non significant"]	;-- <2.250

print-horizontal-line
;--independent samples
print "Two independent samples"
print ["t  = " t: abs( mean1 - mean2) / sqrt((std1 ** 2 / n1) + (std2 ** 2 / n2))]
print ["df = " n1 + n2 - 2]
print ["p  =  0.001" as-red "Significant"] ;-- > 3.610

print-horizontal-line

;-- for t-table reading uncomment the next line
;browse https://www.sjsu.edu/faculty/gerstman/StatPrimer/t-table.pdf
;--for a nice open-source statistical tool: https://jasp-stats.org

