#!/usr/local/bin/r3
REBOL [ 
	author: @ldci
] 

b2d: import 'blend2d ;--use blend2d (draw module)
cv:  import 'opencv

{This code is based on Back-Propagation Neural Networks 
by Neil Schemenauer <nas@arctrix.com>
Thanks to  Karl Lewin for the first Rebol 2 version}


;--Calculates a random number where: a <= rand < b
rand: function [a b [number!] 
][
	(b - a) * ((random 10000.0) / 10000.0) + a
]

;--Make matrices
make1DMatrix: function [mSize[integer!] value [number!] 
][
	m: copy []
	repeat i mSize [append m value]
	m
]
make2DMatrix: function [line [integer!] col [integer!] value [number!] 
][
	m: copy []
	repeat i line [
		blk: copy []
		repeat j col [append blk value]
		append/only m blk
	]
	m
]

;--sigmoid function, tanh seems better than the standard 1/(1+e^-x)
tanh: function [x [number!]][ (exp x - exp negate x) / (exp x + exp negate x)]
sigmoid: function [x [number!]][tanh x]
;derivative of  sigmoid function
dsigmoid: function [y [number!]][1.0 - y * y]

randomizeMatrix: function [mat [block!] v1 [number!] v2 [number!]][
	foreach elt mat [loop length? elt [elt: change/part elt rand v1 v2 1]]
]

createMatrices: func [] [
	aInput: 	make1DMatrix nInput	1.0
	aHidden:	make1DMatrix nHidden 1.0
	aOutput: 	make1DMatrix nOutput 1.0
	wInput: 	make2DMatrix nInput nHidden 0.0
	wOutput: 	make2DMatrix nHidden nOutput 0.0
	cInput:		make2DMatrix nInput nHidden 0.0
	cOutput:	make2DMatrix nHidden nOutput 0.0
	randomizeMatrix wInput -2.0 2.0
	randomizeMatrix wOutput -2.0 2.0
]

computeMatrices: func [inputs [block!] /standard /sigmoidal] [
	; input activations
	repeat i (nInput - 1) [poke aInput i to decimal! inputs/:i]
	; hidden activations
	repeat j nHidden [
		sum: 0.0
		repeat i nInput [sum: sum + (aInput/:i * wInput/:i/:j)]
		if standard  [poke aHidden j 1 / (1 + EXP negate sum)]
		if sigmoidal [poke aHidden j sigmoid sum] 
	]
	; output activations
	repeat j nOutput [
		sum: 0.0
		repeat i nHidden [
		sum: sum + (aHidden/:i * wOutput/:i/:j)]
		if standard  [poke aOutput j 1 / (1 + EXP negate sum)]
		if sigmoidal [poke aOutput j sigmoid sum]
	]
	aOutput
]

backPropagation: func [targets [block!] lr [number!] mf [number!] /standard /sigmoidal] 
[
	; calculate error terms for output
	oDeltas: make1DMatrix  nOutput 0.0
	sum: 0.0
	repeat k nOutput [
		if sigmoidal [sum: targets/:k - aOutput/:k 
						poke oDeltas k (dsigmoid aOutput/:k) * sum
					]
		if standard [ao: aOutput/:k
		poke oDeltas k ao * (1 - ao) * (targets/:k - ao)]
	]
	; calculate error terms for hidden
	hDeltas: make1DMatrix  nHidden 0.0
	repeat j nHidden [
		sum: 0.0
		repeat k nOutput [sum: sum + (oDeltas/:k * wOutput/:j/:k)]
		if sigmoidal [poke hDeltas j (dsigmoid aHidden/:j) * sum]
		if standard [poke hDeltas j (aHidden/:j * (1 - aHidden/:j) * sum)]
	]
	; update output weights
	repeat j nHidden [
		repeat k nOutput [
			chnge: oDeltas/:k * aHidden/:j
			poke wOutput/:j k (wOutput/:j/:k + (lr * chnge) + (mf * cOutput/:j/:k))
			poke cOutput/:j k chnge
		]
	]
	; update hidden weights
	repeat i nInput [
		repeat j nHidden [
			chnge: hDeltas/:j * aInput/:i
			poke wInput/:i j (wInput/:i/:j + (lr * chnge) + (mf * cInput/:i/:j))
			poke cInput/:i j chnge
		]
	]
	; calculate error
	error: 0
	repeat k nOutput [error: error + (0.5 * ((targets/:k - aOutput/:k) ** 2))]
	error
]

;*************************** Main Program *************************

changePattern: func [v1 v2 v3 v4][
 	change second first pattern  v1 
	change second second pattern v2 
	change second third pattern  v3 
	change second fourth pattern v4
]

makeNetwork: func [ni [integer!] nh [integer!] no [integer!]] [
	random/seed now/time/precise
	nInput: 		ni + 1;+1 for bias node
	nHidden: 		nh
	nOutput: 		no
	createMatrices
]

trainNetwork: func [pattern[block!] iterations [number!] lr [number!] mf [number!]
][
	blk: copy []
	count: 0
	x: 10
	learned?: 0
	plot: compose [
		fill blue
		font %NotoSans-Regular.ttf
		text 250x20  18 "Back Propagation"
		text 52x230  12 "60"
		text 112x230 12 "120"
		text 172x230 12 "180"
		text 232x230 12 "240"
		text 292x230 12 "300"
		text 352x230 12 "360"
		text 412x230 12 "420"
		text 472x230 12 "480"
		text 532x230 12 "540"
		text 592x230 12 "600"
		line-width 1 pen red 
		line 0x230 660x230 line 0x120 660x120 line 1x0 1x230 
		line 60x0 60x230 line 120x0 120x230 line 180x0 180x230
		line 240x0 240x230 line 300x0 300x230 line 360x0 360x230
		line 420x0 420x230 line 480x0 480x230 line 540x0 540x230
		line 600x0 600x230 line 660x0 660x230
		pen green
	]
	
	
	repeat i iterations [
		error: 0.0
		foreach p pattern [
			either sigmoid? [r: computeMatrices/sigmoidal p/1 
							error: error + backPropagation/sigmoidal p/2 lr mf]
						    [r: computeMatrices/standard p/1 
						    error: error + backPropagation/standard p/2 lr mf]
			append blk error
			count: count + 1
		]
		if (mod count step) = 0 [
				y: to integer! 230 - (error * 320)
				if x = 10 [append plot reduce['line (as-pair x y)]]
				append plot (as-pair x y)
				++ x	
		]
	]
	append plot reduce ['text 270x40 12 form error]
	img: draw imgSize :plot
	blk
]

;XOR [changePattern 0 1 1 0]
;AND [changePattern 0 0 0 1] 
;OR  [changePattern 0 1 1 1]
;NOR [changePattern 1 0 0 0]
;NAND[changePattern 1 1 1 0]

;XOR by default pattern
pattern: [
	[[0 0] [0]]
	[[1 0] [1]]
	[[0 1] [1]]
	[[1 1] [0]]
]
;--default number of input, hidden, and output nodes
nInput: 		2
nHidden: 		3
nOutput: 		1
;--activation for nodes
aInput:			[]
aHidden:		[]
aOutput: 		[]
;--weight matrices
wInput: 		[]
wOutput: 		[]
;--Matrices for last change in weights for momentum
cInput: 		[]
cOutput: 		[]
sigmoid?: 		true
imgSize: 		660x240
threshold:		0.05
lr: 0.5			; learning rate 
mf: 0.1			; momentum factor
;data: [160 320 640 1280 2560]
n: 			640	; n training sample
step: 		1;


changePattern 0 1 1 0
makeNetwork 2 3 1  
b: trainNetwork pattern n lr mf
v: last b
either (v <= threshold) [print as-yellow "Learning is OK!"][print as-red "No learning"]
cv/imshow/name :img "Neural Network"
cv/waitKey 0

