#!/usr/local/bin/r3
REBOL [
    Title: "Dynamic Time Warping (DTW) Algorithm"
    Purpose: "Basic DTW implementation for time series comparison"
    Note: "Adapted from Red's rcvDTW.red - thanks to Red Sensei"
]

b2d: 	import 'blend2d
cv2: 	import 'opencv 

; Helper function: minimum of three values
dtw-min: function [x y z][
    min min x y z
]

; Calculate Euclidean distance matrix between two sequences
dtw-distances: function [
    x [block!] "First sequence"
    y [block!] "Second sequence"
][
    lx: length? x
    ly: length? y
    
    ; Create distance matrix (ly rows x lx columns)
    dmat: array/initial reduce [ly lx] 0.0
    repeat i ly [
        repeat j lx [
            ;dist: abs (x/:j - y/:i)
            dist: (x/:j - y/:i) ** 2
            dmat/:i/:j: dist
        ]
    ]
    dmat
]

; Calculate accumulated cost matrix
dtw-costs: function [
    dmat [block!] "Distance matrix"
][
    ly: length? dmat
    lx: length? dmat/1
    
    ; Create cost matrix
    cmat: array/initial reduce [ly lx] 0.0
    ; Initialize first cell
    cmat/1/1: dmat/1/1
    
    ; Initialize first row
    repeat j (lx - 1) [
        ++ j ;j: j + 1
        cmat/1/:j: dmat/1/:j + cmat/1/(j - 1)
    ]
    
    ; Initialize first column
    repeat i (ly - 1) [
        ++ i; i: i + 1
        cmat/:i/1: dmat/:i/1 + cmat/(i - 1)/1
    ]
    
    ; Fill the rest of the matrix
    for i 2 ly 1 [
        for j 2 lx 1 [
            cost: dtw-min 
                cmat/(i - 1)/:j      ; from above
                cmat/:i/(j - 1)      ; from left
                cmat/(i - 1)/(j - 1) ; from diagonal
            cmat/:i/:j: dmat/:i/:j + cost
        ]
    ]
    cmat
]

; Get DTW distance (bottom-right corner of cost matrix)
dtw-distance: function [cmat [block!]][
    last last cmat
]

; Main DTW function
dtw: function [
    "Calculate DTW distance between two sequences"
    x [block!] "First sequence"
    y [block!] "Second sequence"
    /with-path "Also return the warping path"
][
    dmat: dtw-distances x y
    cmat: dtw-costs dmat
    dist: dtw-distance cmat
    
    either with-path [
        ; Backtrack to find optimal path
        path: copy []
        i: length? y
        j: length? x
        append path reduce [i j]
        
        while [any [i > 1 j > 1]][
            either i = 1 [
                j: j - 1
            ][
                either j = 1 [
                    i: i - 1
                ][
                    ; Find minimum neighbor
                    case [
                        cmat/(i - 1)/(j - 1) <= min cmat/(i - 1)/:j cmat/:i/(j - 1) [
                            i: i - 1
                            j: j - 1
                        ]
                        cmat/(i - 1)/:j <= cmat/:i/(j - 1) [i: i - 1]
                        true [j: j - 1]
                    ]
                ]
            ]
            insert path reduce [i j]
        ]
        reduce [dist path]
    ][
        dist
    ]
]

; === USAGE EXAMPLE ===
x: [9 3 1 5 1 2 0 1 0 2 2 8 1 7 0 6 4 4 5]
y: [9 3 1 5 1 2 0 1 0 2 2 8 1 7 0 6 4 4 5]
;--print ["DTW Distance:" dtw x y]
;--With warping path
result: dtw/with-path x y
print-horizontal-line
prin "x == y "
print ["DTW Distance:" result/1]		;--must be = 0.0
print ["Warping Path:" mold result/2]
print-horizontal-line

x: [9 3 1 5 1 2 0 1 0 2 2 8 1 7 0 6 4 4 5]
y: [1 0 5 5 0 1 0 1 0 3 3 2 8 1 0 6 4 4 5 8 9]
result: dtw/with-path x y
prin "x != y "
print ["DTW Distance:" result/1]		;--must be > 0.0
print ["Warping Path:" mold result/2]
print-horizontal-line
print "Any key to close"

;--Optimal path visualisation
imgSize: as-pair (length? x) (length? y)
imgSize: imgSize * 10

;--optimal warping path (we use b2d module)
code: compose [
	font %/System/Library/Fonts/Geneva.ttf
	text 1x105 10 "Y"
	text 95x210 10 "X"
	line-width 1
	pen black 
	line 10x0 10x200
	line 10x200 190x200
	pen red
	line
]

foreach [v1 v2] result/2 [
	v1: imgSize/y - (v1 * 10)	;--y from the bottom
	v2: v2 * 10					;--x from the left
	append code as-pair v2 v1
]

;probe code

img: draw imgSize :code
;probe img/size

;--OpenCV
with cv2 [
	namedWindow win: "DTW"
	moveWindow win 260x10
	imshow/name img win
	waitkey 0
]
