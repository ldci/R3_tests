#!/usr/local/bin/r3
REBOL [ 
]  
; based on r2 code by Sylvain Maltais (gladir.com)
isLeapYear: function [
	year [integer!]
][
 all [((year and 3) = 0) any [(year // 100 <> 0) (year // 400 = 0)]]
]
print-horizontal-line
for i 1948 2028 1 [
	if isLeapYear i [print [i " is a leap year"]]
]
print-horizontal-line