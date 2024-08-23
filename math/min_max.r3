#!/usr/local/bin/r3
REBOL [ 
] 
;--from Galen Ivanov
;--https://github.com/red/red/wiki/Red-functions-for-Python-programmers

max-series: function [
    series [series!]
    /compare
        comparator [integer! any-function!]

][
    cmax: series/1
    cmp: any [
        get pick [comparator greater?]any-function? :comparator
        greater?
    ]
    either integer? :comparator [
        forall series [
            cmax: either cmp cmax/:comparator series/1/:comparator [
                cmax
            ][
                series/1
            ]
        ]
    ][
        forall series [
            cmax: either cmp cmax series/1[
                cmax
            ][
                series/1
            ]
        ]
    ]
]




min-series: function [
    series [series!]
    /compare
        comparator [integer! any-function!]

][
    cmin: series/1
    cmp: any [
        get pick [comparator lesser?] any-function? :comparator
        lesser?
    ]
    either integer? :comparator [
        forall series [
            cmin: either cmp cmin/:comparator series/1/:comparator [
                cmin
            ][
                series/1
            ]
        ]
    ][
        forall series [
            cmin: either cmp cmin series/1 [
                cmin
            ][
                series/1
            ]
        ]
    ]
]

cmp-len: func [a b][(length? a) >= length? b]
cmp-sum: func [a b][(sum a) < sum b]
cmp-min: :lesser?

print-horizontal-line
print max-series [1 3 2 5 4]
print max-series/compare [1 3 2 5 4] :cmp-min

print-horizontal-line
colors: ["Red" "Orange" "Yellow" "Green" "Blue" "Ultraviolet" "Indigo" "Violet"]
print max-series colors
print max-series/compare colors :cmp-len

print-horizontal-line
print min-series [3 1 4 1 5]
print min-series [[5 10] [1 2 3 4] [2 4 6] [4 5] [42]] 
print min-series/compare [[5 10] [1 2 3 4] [2 4 6] [4 5] [42]] :cmp-sum
print max-series [[5 10] [1 2 3 4] [2 4 6] [4 5] [42]] 
print-horizontal-line


