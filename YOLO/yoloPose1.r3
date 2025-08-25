#!/usr/local/bin/r3
Rebol [
]
cv: import opencv												;--use opencv module
testFile: "group.jpg"											;--the image
imgFile: ajoin ["images/" testFile]								;--test file
prog: "yolo pose predict model=models/yolo11n-pose.pt source="	;--YOLO CLI
append prog ajoin ["'" imgFile "'"]								;--append file name
str: ""															;--for returned str
destination: "/opt/homebrew/runs/pose/predict/"					;--destination dir
if exists? to-file destination [delete-dir to-file destination]	;--avoid duplicates
with cv [
	tt: dt [
		filename: to-rebol-file imgFile							;--source file
		src: imread/with filename IMREAD_UNCHANGED				;--read source file
		imshow/name src  "Source"								;--show source file
		size: get-property src MAT_SIZE 						;--get source file size
		moveWindow "Source" 10x10								;--move to position
		call/wait/shell/output prog str							;--call YOLO commands
	 	append destination testFile								;--and returned file
		filename2: to-rebol-file destination					;--Rebol returned file
		img: imread/with filename2 IMREAD_UNCHANGED				;--load returned file
		imshow/name img "Pose Estimation" 						;--show result
		pos: as-pair size/x + 15 10								;--result position
		moveWindow "Pose Estimation" pos						;--move to position
	]
	print ["Done in: " third tt " sec"]							;--all process duration
	waitKey 0													;--any key to quit
]


