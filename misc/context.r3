#!/usr/local/bin/r3
REBOL [
]
;-- I don't remember author's name
rocks: []
append rocks bind 'rock rural-park: context [rock: "mineral"]
append rocks bind 'rock festival: context [rock: "genre"]
append rocks bind 'rock wrestling: context [rock: "Dwayne"]
append rocks bind 'rock dark-souls: context [rock: "Havel"]
print ["Context:" reduce rocks]
