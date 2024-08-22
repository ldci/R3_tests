#!/usr/local/bin/r3
REBOL [ 
] 

;--The integer value      5   should produce an output of               101
;--The integer value     50   should produce an output of            110010
;--The integer value   9000   should produce an output of    10001100101000

makeDigitStr: func [
	n		[integer!]
	return: [string!]
][
	str: copy ""
	until[
		append str form n % 2
		n: to-integer n / 2
		n = 0
	]
	reverse str
]


;--test
print-horizontal-line
print "Using makeDigitStr"
print ["5 -> 101" assert [makeDigitStr 5 "101"]]
print ["50 --> 110010" assert [makeDigitStr 50 "110010"]]
print ["9000 --> 10001100101000" assert [makeDigitStr 9000 "10001100101000"]]
print-horizontal-line
print [5 "   " makeDigitStr 5 ]
print [50 "  " makeDigitStr 50]
print [9000 "" makeDigitStr 9000]

print-horizontal-line
print "Rosetta code based"
;--Rosetta code based

foreach number [5 50 9000] [
  ;--any returns first not false value, used to cut leading zeroes
  binstr: form any [find enbase to-binary number 2 "1" "0"]
  print reduce [pad number 5 binstr]
]
print-horizontal-line

;--red version
{foreach number [5 50 9000] [
  ;--any returns first not false value, used to cut leading zeroes
  binstr: form any [find enbase/base to-binary number 2 "1" "0"]
  print reduce [ pad/left number 5 binstr ]
]}