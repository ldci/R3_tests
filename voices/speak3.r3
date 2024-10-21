#!/usr/local/bin/r3
Rebol [
]

txt: load %simple.txt	;--french text sample 
speak: import speak		;--import module
print txt
speak/say/as txt 166	;--french voice