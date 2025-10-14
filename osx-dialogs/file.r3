#!/usr/local/bin/r3
REBOL [ 
] 
;r3-3.20.1
cv: import 'opencv
file: request-file/title/filter "Select an image" [%jpg %png %bmp %tif %tiff %gif]
print file
with cv [
	img: imread/image file 	;--as a rebol image
	imshow :img 
	waitKey 0
]



;REFINEMENTS:
;     /save         File save mode
;     /multi        Allows multiple file selection, returned as a block
;    /file         Default file name or directory
;  		name         [file!] 
;     /title        Window title
;      text         [string!] 
;     /filter       Block of filters
;      list         [block!] 



;Oldes
;On mac it may be used as:
;request-file/filter [%txt %csv %json %xml]   
;or
;request-file/title/filter "Select a spreadsheet:" [
;    "com.microsoft.excel.xls"
;    "org.openxmlformats.spreadsheetml.sheet"
;    "com.apple.iwork.numbers.numbers"
;]
