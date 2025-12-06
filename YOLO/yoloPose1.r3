#!/usr/local/bin/r3
Rebol [
]
cv: import opencv												;--use opencv module
testFile: "group.jpg"											;--any image
imgFile:  rejoin ["images/" testFile]							;--test file
prog: "yolo pose predict model=models/yolo11n-pose.pt source="	;--YOLO CLI mode
append prog rejoin ["'" imgFile "'"]							;--append file name
str: copy ""													;--for returned str
destination: "/opt/homebrew/runs/pose/predict/"					;--destination dir
if exists? to-file destination [delete-dir to-file destination]	;--avoid duplicates
print "Loading Yolo model"
with cv [
	tt: dt [
		src: imread/with imgFile IMREAD_UNCHANGED				;--read source file
		src: resize src 75%
		imshow/name src  "Source"								;--show source file
		size: get-property src MAT_SIZE 						;--get source file size
		moveWindow "Source" 10x10								;--move it
		print "Processing data..."
		call/wait/shell/output prog str							;--call YOLO command
		append destination testFile								;--and returned file
		img: imread/with destination IMREAD_UNCHANGED			;--load returned file
		img: resize img 75%
		imshow/name img "Pose Estimation" 						;--show result
		pos: as-pair size/x + 15 10								;--result position
		moveWindow "Pose Estimation" pos						;--move to position
	]
	print ["Done in: " third tt " sec"]							;--all process duration
	waitKey 0													;--any key to quit
]

write %result.txt str
print read/string %result.txt



