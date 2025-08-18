#!/usr/local/bin/r3
REBOL [
]
;--Oldes's solution

linSpace: function [
    "Generates N linearly spaced numbers from a to b (inclusive)."
    a [number!]  "Start"
    b [number!]  "End"
    n [integer!] "Number of samples"
    /no-end      "Don't include end value in the result"
    /local vec div
][
    either n < 2 [
        vec: make vector! [f64! 1]
        vec/1: a
    ][
        vec: make vector! [f64! :n]
        div: either no-end [n][n - 1]
        step: (b - a) / div
        repeat k n [
            vec/:k: a + (step * (k - 1))
        ]
    ]
    vec
]

; Example usage:
probe linSpace -1.0 0.0 5
;== #(float64! [-1.0 -0.75 -0.5 -0.25 0.0])
probe linSpace -1.0 0.0 1
;== #(float64! [-1.0])
probe linSpace/no-end 0 100 10
;== #(float64! [0.0 10.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0])

;--ldci
probe linSpace 0 100 9
;==#(float64! [0.0 12.5 25.0 37.5 50.0 62.5 75.0 87.5 100.0])

x: linSpace/no-end 0.0 (2.0 * pi) 100
n: length? x
y: make vector! [f64! :n]
repeat i n [
	y/:i: sin x/:i
]

probe y

