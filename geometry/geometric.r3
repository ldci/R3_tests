#!/usr/local/bin/r3
REBOL [ 
] 

; based on R2 code by Sylvain Maltais (gladir.com)
;--b: base h: height w: width l: length r: radius s: surface 

circleArea: function [r] [pi * (r * r)]
triangleArea: function [b h][0.5 * b * h]
equilateralTriangleArea: function [s][(((square-root 3) * (s * s)) / 4)]
rectangularPrismSurfaceArea: function [h w l][(2 * h * w) + (2 * h * l) + (2 * l * w)]
rectangularPrismSurfaceVolume: function [h w l][h * w * l]

print-horizontal-line
print "Circle"
print ["The area of a circle of radius 1 cm  is "  circleArea 1 "cm2"]
print ["The area of a circle of radius 5 cm  is "  circleArea 5 "cm2"]
print ["The area of a circle of radius 8 cm  is "  circleArea 8 "cm2"]
print ["The area of a circle of radius 10 cm is " circleArea 10 "cm2"]

print-horizontal-line
print "Triangle"
print ["A triangle 10 cm high by 10 cm wide contains an area of " triangleArea 10 10 "cm2"]
print ["A triangle 5 cm high by 10 cm wide contains an area  of " triangleArea 5  10 "cm2"]
print ["A triangle 3 cm high by 2 cm wide contains an area   of " triangleArea 3   2 "cm2"]

print-horizontal-line
print "Equilateral triangle"
print ["Equilateral triangle of 10 cm contains an area of " equilateralTriangleArea 10 "cm2"]
print ["Equilateral triangle of 5  cm contains an area of " equilateralTriangleArea  5 "cm2"]
print ["Equilateral triangle of 3  cm contains an area of " equilateralTriangleArea  3 "cm2"]

print-horizontal-line
print "Rectangular Prism"
print ["The surface area of a 10x5x5 rectangular prism is" RectangularPrismSurfaceArea 10 5 5 "cm2"]
print ["The surface area of a 2x3x4 rectangular prism  is" RectangularPrismSurfaceArea 2 3 4 "cm2"]
print ["The surface area of a 4x5x3 rectangular prism  is" RectangularPrismSurfaceArea 4 5 3 "cm2"]

print-horizontal-line
print "Volume"
print ["The volume of a 4x5x3 rectangular prism is " rectangularPrismSurfaceVolume 4 5 3 "cm3"]
print-horizontal-line



 
