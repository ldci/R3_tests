#!/usr/local/bin/r3
REBOL [ 
] 

deg2rad:  funct [degree [number!]][degree * (pi / 180)]
rad2Deg:  funct [rad [number!]][rad * (180 / pi)]
rad2Grad: funct [rad [number!]][rad * (200 / pi)]
grad2Rad: funct [grad [number!]][grad * (pi / 200)] 
	
print-horizontal-line
print "Rebol 3 native"
;-- R3 natives are not supported in Red
print ["angle 180° =" to-radians 180 "rad"]
print ["rad pi     =" to-degrees pi "°C"]

print-horizontal-line
print "Degree to Radian"
print ["angle 0°   =" deg2rad 0   "rad"]
print ["angle 45°  =" deg2rad 45  "rad"]
print ["angle 90°  =" deg2rad 90  "rad"]
print ["angle 180° =" deg2rad 180 "rad"]
print ["angle 225° =" deg2rad 225 "rad"]
print ["angle 270° =" deg2rad 270 "rad"]
print ["angle 360° =" deg2rad 360 "rad"]

print-horizontal-line
print "Radian to degree"
print ["rad 0                  =" rad2Deg 0 "°"]
print ["rad 0.785398163397448  =" rad2Deg 0.785398163397448 "°C"]
print ["rad 1.5707963267949    =" rad2Deg 1.5707963267949 "°C"]
print ["rad 3.14159265358979   =" rad2Deg 3.14159265358979 "°C"]
print ["rad 3.92699081698724   =" rad2Deg 3.92699081698724 "°C"]
print ["rad 4.71238898038469   =" rad2Deg 4.71238898038469 "°C"]
print ["rad 6.28318530717959   =" rad2Deg 6.28318530717959 "°C"]
print-horizontal-line

