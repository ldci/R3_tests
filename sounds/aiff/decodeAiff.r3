#!/usr/local/bin/r3
Rebol [
]
OS: system/platform	;--for little/big endian
print [OS "version"]

AiffFileH: make object! [
	signature: ""
	formType: ""
]

;--common chunk
AiffCom: make object! [
	ckID: "" 	
	chunkSize: 0 
    nChannels: 0 	   	
    nSamplesFrames: 0 	
    sampleSize: 0 	
    sampleRate: 0 
]

AiffSsnd: make object! [ 
    ckID: ""	; ssnd chunk 	
	chunkSize: 0
	offset: 0
	blockSize: 0
]

loadFile: func [f [file!]] [
	print f
	aiff: read/binary f
	extractHeader
	;extractData
]

extractHeader: does [
	;12 bit 
	AiffFileH/signature: to string! copy/part aiff 4
	aiff: skip aiff 8
	s: to string! copy/part aiff 4
	AiffFileH/formType: s
	; This COMM chunk is obligatory ;;
	;--byte 16
	aiff: skip aiff 4
	tmp: copy/part aiff 22 s: copy/part tmp 4 AiffCom/ckID: to string! s 
	tmp: skip tmp 4 s: copy/part tmp 4 AiffCom/chunkSize: to-integer s
	tmp: skip tmp 4 s: copy/part tmp 2 AiffCom/nChannels: to-integer s
	tmp: skip tmp 2 s: copy/part tmp 4 AiffCom/nSamplesFrames: to-integer s
	tmp: skip tmp 4 s: copy/part tmp 2 AiffCom/sampleSize: to-integer s
	tmp: skip tmp 2 s: copy/part tmp 6 AiffCom/sampleRate: to-integer s
	;--Sound Data Chunk  is required just before data sample !
	tmp: copy/part aiff 12 s: copy/part tmp 4 AiffSsnd/ckID: to string! s
	tmp: skip tmp 4 s: copy/part tmp 4 AiffSsnd/chunkSize: to-integer s
	tmp: skip tmp 4 s: copy/part tmp 4 AiffSsnd/offset: to-integer s
	tmp: skip tmp 4 s: copy/part tmp 4 AiffSsnd/blockSize: to-integer s
]
 
 ;************************ MainProgram ******************
loadFile %../sound_files/12StrStart.aiff
? AiffFileH 
? AiffCom
? AiffSsnd
 