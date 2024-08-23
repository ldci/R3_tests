#!/usr/local/bin/r3
REBOL [ 
] 
{Expressions are evaluated from left to right. 
There is no operator precedence except for infix functions 
which do have precedence over prefix calls.
so in many cases we need parens () for a correct evaluation
Parenthetical subexpressions are evaluated first
Both approaches in redBol functional (e.g. add) and an infix operator (e.g. +)
}
;--infix operators
print-horizontal-line
print "infix operators"
print 1 + 2 * 3				;-- (1 + 2) * 3 returns 9
print (1 + 2 * 3 = 9)		;-- ((1 + 2) * 3) = 9 returns TRUE
;print (9 = 1 + 2 * 3)		;-- ((9 = 1) + 2) * 3 raises an error!
print (9 = (1 + 2 * 3)) 	;-- correct
print (1 + (2 * 3))			;-- 1 + (2 * 3) returns 7

print-horizontal-line
print "functional operators"
;--functional operators
print (multiply add 1 2 3)	;-- returns 9
print (divide add 1 2 3)	;-- returns 1

print-horizontal-line
print "with strings"
;--strings 
print [do "2 + 5 * 3"]		;-- returns 21
print [do "2 + (5 * 3)"]	;-- returns 17
print-horizontal-line


{red math
Evaluates a block! using the normal mathematical rules of precedence, that is, divisions
and multiplications are evaluated before additions and subtractions and so on.
math [1 + 2 * 3] --> 7
math [(1 + 2) * 3] --> 9
math [(1 + 2) * 3 * 3] --> 27 }


