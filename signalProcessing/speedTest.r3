#!/usr/local/bin/r3
REBOL [ 
	needs: 3.18.1
]

tt: dt [repeat i 1000 [print i]]
print rejoin ["Done in: " round third tt * 1000 " ms"]