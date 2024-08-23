#!/usr/local/bin/r3
REBOL [ 
] 
;--from Galen Ivanov
;--https://github.com/red/red/wiki/Red-functions-for-Python-programmers

range: function [
    _end [integer!]
    /from
        start [integer!]
    /by
        step  [integer!]
][
    _start: either from [_end][1]
    _end: either from [start][_end]
    step: any [step 1]
    rng: make block! (absolute _end - _start / step)
    cmp?: get pick [<= >=] step > 0

    while [_start cmp? _end][
        append rng _start
        _start: _start + step
    ]
    rng
]

probe range 10
probe range/from 2 10
probe range/from/by 10 20 2
probe range/from/by 50 10 -5
probe range/from/by 5 -5 -1
probe range/from/by -5 5 1