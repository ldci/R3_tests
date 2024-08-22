#!/usr/local/bin/r3
REBOL [ 
] 


print-horizontal-line
;-- we play with map datatype
print "map! datatype"
;--map! (not a serie)
print-horizontal-line
m1: #[1 "Red" 2 "Rebol" 3 "C" 4 "Python" 5 "Java"]
print ["N Keys-Values: " length? m1]	;--number of key-value pairs (5)
print ["Keys:" keys-of m1]			;--keys
print ["Values:" values-of m1]		;--values
print ["Body:" body-of m1]			;--as a block
;--find works only on keys
print ["Python?" find m1 "Python"]	;--find -> none
print ["Modula?" find m1 "Modula"]	;--find -> none


print-horizontal-line
;--we force a serie-like behaviour
print "Series like behaviour" 
print "Use select"
m2: make map! [1 "Red" 2 "Rebol" 3 "C" 4 "Python" 5 "Java"]
repeat i 5 [print select m2 i]		;--with map select function

print-horizontal-line
print "Use path notation"
repeat i 5 [print m2/:i]			;--with path notation
print ""

print-horizontal-line
print "map modifications"
;--modify map
put m2 5 none		;--delete key 5 and its value
print m2
put m2 5 "Pascal"	;--modified value
print m2 
put m2 6 "Modula"	;--append a new value
print m2 
print "Extend map"
;--merging maps
;extend m2 'i [7 "Java" 8 "C++"] ??
append m2 [7 "Java" 8 "C++"]

print m2
print-horizontal-line
print "Get map values"

;--new map shortcut creation for redbol languages
m3: #[n1 18 n2 76]
print [m3/n1 m3/n2]

a: 18
b: 76

m4: #[n1 a n2 b]
print [get m4/n1 get m4/n2]

m5: #[-2 -1 -1 -1 0 0 1 1 2 1]
print [m5/-2 m5/-1 m5/0 m5/1 m5/2] ;OK
print ""

foreach [key val] #[a: 1 b: 2] [print [key val]]
print-horizontal-line
