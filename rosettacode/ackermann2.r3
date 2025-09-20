#!/usr/local/bin/r3
REBOl [
	title: "Rosetta code: Ackermann"
    file:  %ackermann2.r3
    url:   https://rosettacode.org/wiki/Ackermann_function#Rebol
    needs: 3.16.0
]

;--Optimized Ackermann with small-m shortcuts
ackermann: func [
    m [integer!]
    n [integer!]
] [
    ;; Small-m closed forms
    case [
        m = 0 [n + 1]
        m = 1 [n + 2]
        m = 2 [(2 * n) + 3]
        m = 3 [
            ;; 2^(n+3) - 3
            (to integer! power 2 (n + 3)) - 3
        ]
        ;; m >= 4 causes stack overflow
    ]
]

print ackermann 0 0
;== 1
print ackermann 3 4
;== 125
