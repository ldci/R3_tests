#!/usr/local/bin/r3
REBOL [ 
] 
;--based on Modula2: https://www.modula2.org/projects/pi_by_montecarlo.php
random/seed now/time/precise
cTotal: 1000000
cInside: 0

repeat i cTotal [
	x: random 1.0
	y: random 1.0
	d: (x * x) + (y * y)
	if d <= 1.0 [++ cInside]
]

estimatedPI: 4.0 * (cInside / cTotal)
print ["PI by Monte Carlo estilation =" round/to estimatedPI 0.00001]
print ["Rebol 3 pi value             =" round/to pi 0.00001]