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

print-horizontal-line
;--Greg 
print ["Degrees =" a: sine 45] 				;--degrees by default
print ["Radians =" b: sine/radians pi / 4]	;--same result
print ["Radians =" b: sin pi / 4]			;--same result

print-horizontal-line
angle: 30.0
print ["Tangent Redbol      =" round/to tangent angle 0.0001]	;--OK
print ["Tangent sine/cosine =" round/to (sine angle) / (cosine angle) 0.0001]	;--OK
;--with infix precedence
print ["Tangent sine/cosine =" round/to divide sine angle cosine angle 0.0001] ;--OK

print-horizontal-line
;Propriété 2
print [((sine angle) ** 2) + ((cosine angle) ** 2)]		;--OK
;--with infix precedence
print [add power sine angle 2 power cosine angle 2]		;--OK

print-horizontal-line		 
print ["1 radian  =" piRad: 180 / pi] 	;--1r = 180/π = 57.2957795130823°
print ["1 radian  =" 360 / (2 * pi)]
print ["angle 1πr =" 1 * pi * piRad]	;--1πr-> 180°
print ["angle 2πr =" 2 * pi * piRad]	;--2πr-> 360°
print ["angle 1r  =" 1 * piRad]		;--1r--> 57.2957795130823°
print ["angle 2r  =" 2 * piRad]		;--2r--> 114.591559026165°

print-horizontal-line
print "Rebol 3 native!"
print ["to radian =" c: to-radians angle]
print ["to degree =" to-degrees c]

print-horizontal-line
print "Radians"
print ["1 Radian =" c]
print ["Cos      =" cos c]
print ["Sin      =" sin c]
print ["Tangent  =" (sin c) / (cos c)]

print-horizontal-line
;Property 2
print [((sin c) ** 2) + ((cos c) ** 2)]
radius: 50
print-horizontal-line
; redCV
print ["redCV:" round as-pair (radius * cosine angle) (radius * sine angle)]
print ["redCV:" round as-pair (radius * cos angle) (radius * sin angle)]
print-horizontal-line