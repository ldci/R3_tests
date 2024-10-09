#!/usr/local/bin/r3
REBOL [
Note: {
		Based on original Port examples which can be found at:
		https://web.archive.org/web/20131012055435/http://www.rebol.net:80/wiki/Port_Examples
	}
]
copy-file: func [
       "Copy a large file"
       from-file to-file
       /local file1 file2 data
   ] [
       file1: open from-file
       file2: open/new to-file
       while [not empty? data: read/part file1 32000] [
           write file2 data
       ]
       close file1
       close file2
       print "Done"
]
;--test program
inp: %color.png
out: %test.png
copy-file inp out
probe query out object!
;probe query out [:type :name :size :date :modified :accessed]