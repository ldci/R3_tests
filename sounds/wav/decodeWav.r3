#!/usr/local/bin/r3
Rebol [
]
;--for canonical wave file format 
OS: system/platform	
isFile?: true
print ["Version:" OS]
WaveFileH: make object! [
	RIFF: ""			;--Chunk ID (RIFF)
	file_length: 0 		;--Chunk size
	WAVE: ""			;--format (WAVE)
	FMT: ""				;--Subchunk1ID (fmt)
	fmt_length: 0		;--SubChunk1 Size (16 for PCM)
	FormatTag: 0		;--format PCM = 1 (Linear quantization) >1 = compression
    nChannels: 0		;--number of channels (i.e. mono, stereo,etc.)     	
    nSamplesPerSec: 0	;--sample rate
    nAvgBytesPerSec: 0  ;--byte Rate (for buffer estimation)
    nBlockAlign: 0 		;--block size of data 	
	PCMnBitsSample: 0	;--bits per sample	
	DATA: #{}			;--Subchunk2ID (data)
	data_length: 0		;--SubChunk2 Size 
] 

idx: 0

extractHeader: funct [header [binary!]] [
	;--byte 0 big endian 4 bytes (ChunkID)
	WaveFileH/RIFF: to string! copy/part header 4 
	
	;--byte 4 little endian 4 bytes (ChunckSize)
	header: skip header 4
	s: reverse copy/part header 4	
	WaveFileH/file_length:  (to-integer s)
	
	;--byte 8 big endian 4 bytes (Format)
	header: skip header 4
	s: copy/part header 4	
	WaveFileH/WAVE: to string! s
	
	;--byte 12 big endian 4 bytes (SubChunk1ID)
	header: skip header 4
	s: copy/part header 4	
	WaveFileH/FMT: to string! s
	
	;--byte 16 little endian 4 bytes (SubChunk1 Size)
	header: skip header 4
	s: reverse copy/part header 4	;--4 bytes
	WaveFileH/fmt_length: to integer! s
	
	;--byte 20 little endian (Audio Format)
	header: skip header 4
	s: reverse copy/part header 2	;--2 bytes
	WaveFileH/FormatTag: to-integer  s
	
	;--byte 22 little endian 2 bytes (NumChannels)
	header: skip header 2
	s: reverse copy/part header 2	
	WaveFileH/nChannels: to-integer s 
	
	;--byte 24 little endian  4 bytes (Sample Rate)
	header: skip header 2
	s: reverse copy/part header 4	
	WaveFileH/nSamplesPerSec: to-integer s
	
	;--byte 28 little endian 4 bytes (ByteRate)
	header: skip header 4 
	s: reverse copy/part header 4 
	WaveFileH/nAvgBytesPerSec: to-integer s
	
	;--byte 32 little endian (block align)
	header: skip header 4
	s: reverse copy/part header 2	;--2 bytes
	WaveFileH/nBlockAlign: to-integer s
	
	;--byte 34 little endian 4 bytes (bits per sample)
	header: skip header 2
	s: reverse copy/part header 2
	WaveFileH/PCMnBitsSample: to-integer s
	
	;--byte 36 big endian 4 bytes (SubChunk2ID)
	header: skip header 2
	s: copy/part header 4	
	WaveFileH/DATA: to string! s
	
	;--byte 40 big little  4 bytes (SubChunk2 Size)
	header: skip header 4
	s: reverse copy/part header 4	
	WaveFileH/data_length: to-integer s
	;--byte 44: raw sound data
]

extractData: does [
	ch1: copy [] ch2: copy []
	dataSize: WaveFileH/PCMnBitsSample / 8
	n: WaveFileH/data_length / WaveFileH/nChannels / dataSize
	wav: head wav
	wdata: skip wav idx				;--first value
	for i 0 n 1 [
		s: copy/part wdata dataSize
		;if OS = 'macOS [reverse s]
		value: to-integer s
		either WaveFileH/nChannels = 1 [append ch1 value]
   		[either odd? i [append ch1 value] [append ch2 value]]
   		wdata: skip wdata dataSize	;--next value
	]
]

loadFile: func [f [file!]] [
	print ["File:" f]
	wav: read/binary f
	isFile?: true
	idx: index? find wav "data"
	idx: idx + 7
	if idx > 44 [
		print "Non canonical wave file"
		isFile?: false
		exit
	]
	wheader: copy/part wav idx
	extractHeader wheader
	extractData 
]


;************************ MainProgram ******************
file: request-file/title/filter "Select a sound" [%wav]
unless none? file [
	loadFile file
	? WaveFileH
	if isfile? [
		probe ch1/1 
		probe ch2/1
	]
	
]
