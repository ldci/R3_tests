#!/usr/local/bin/r3
Rebol [
]
src: "Hello Rebol 3 World"
print src
print b: to-binary src 
i: 1
print binary/read b [str: STRING]
print binary/read b 2
print binary/read next b 2