#!/usr/local/bin/r3
Rebol [
]
;--Oldes's suggestion
encode-braille: function [
    "Process ANSI string and returns Braille string"
    text [string!]
][  
    out: copy ""
    foreach char text [
        if char <= 255 [char: char + 10240]
        append out char
    ]
    out
]
decode-braille: function [
    "Process string while decoding Braille's characters"
    text [string!]
][
    out: copy ""
    foreach char text [
        if all [char >= 10240 char <= 10495] [char: char - 10240]
        append out char
    ]
    out
]
print-horizontal-line
print bra: encode-braille "Hello Fantastic Red and Rebol Worlds!"
print-horizontal-line
print txt: decode-braille bra
print-horizontal-line