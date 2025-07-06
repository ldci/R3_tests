#!/usr/local/bin/r3
REBOL [ 
	author: @ldci
] 

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
		sigma: 0.0
		repeat i nInput [sigma: sigma + (aInput/:i * wInput/:i/:j)]
		if standard  [poke aHidden j 1 / (1 + exp negate sigma)]
		if sigmoidal [poke aHidden j sigmoid sigma] 
	]
	; output activations
	repeat j nOutput [
		sigma: 0.0
		repeat i nHidden [
		sigma: sigma + (aHidden/:i * wOutput/:i/:j)]
		if standard  [poke aOutput j 1 / (1 + exp negate sigma)]
		if sigmoidal [poke aOutput j sigmoid sigma]
	]
	aOutput
]

backPropagation: func [targets [block!] lr [number!] mf [number!] /standard /sigmoidal] 
[
	; calculate error terms for output
	oDeltas: make1DMatrix  nOutput 0.0
	sigma: 0.0
	repeat k nOutput [
		if sigmoidal [sigma: targets/:k - aOutput/:k 
						poke oDeltas k (dsigmoid aOutput/:k) * sigma
					]
		if standard [ao: aOutput/:k
		poke oDeltas k ao * (1 - ao) * (targets/:k - ao)]
	]
	; calculate error terms for hidden
	hDeltas: make1DMatrix  nHidden 0.0
	repeat j nHidden [
		sigma: 0.0
		repeat k nOutput [sigma: sigma + (oDeltas/:k * wOutput/:j/:k)]
		if sigmoidal [poke hDeltas j (dsigmoid aHidden/:j) * sigma]
		if standard [poke hDeltas j (aHidden/:j * (1 - aHidden/:j) * sigma)]
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
b2d: import 'blend2d 	;--use blend2d (draw module)
cv:  import 'opencv		;--for visualisation

changePattern: func [v1 v2 v3 v4][
	change pattern/1/2 v1
	change pattern/2/2 v2
	change pattern/3/2 v3
	change pattern/4/2 v4
	expected: ajoin [pattern/1/2 pattern/2/2 pattern/3/2 pattern/4/2]
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
	x: 5
	;--for blend2 draw
	plot: compose [
		fill blue
		font %NotoSans-Regular.ttf
		text 250x20  18 "Back Propagation"
		text 280x40 18 op
		text 335x40 18 expected
		text 52x245  12 "60"
		text 112x245 12 "120"
		text 172x245 12 "180"
		text 232x245 12 "240"
		text 292x245 12 "300"
		text 352x245 12 "360"
		text 412x245 12 "420"
		text 472x245 12 "480"
		text 532x245 12 "540"
		text 592x245 12 "600"
		text 662x10  12 "1.0"
		text 662x125 12 "0.5"
		text 662x230 12 "0.0"
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
		clear calculated
		foreach p pattern [
			either sigmoid? [r: computeMatrices/sigmoidal p/1 
							error: error + backPropagation/sigmoidal p/2 lr mf]
						    [r: computeMatrices/standard p/1 
						    error: error + backPropagation/standard p/2 lr mf]
			append blk error
			append calculated form to integer! round/half-ceiling r/1
			either expected = calculated [isLearned?: true] [isLearned?: false]
			++ count
		]
		if (mod count step) = 0 [
			y: to integer! 230 - (error * 230)	;--scale error values in y
			if x = 5 [append plot reduce['line as-pair x y]];--starting point for line
			append plot as-pair x y	;--then just add coordinates
			++ x	
		]
	]
	append plot reduce ['text 270x60 12 form error]
	img: draw imgSize :plot
	blk
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
imgSize: 		680x250
lr: 0.5			;--learning rate 
mf: 0.1			;--momentum factor
n: 				640	; n training sample [160 320 480 640 800 960]
step: 			1
isLearned?: 		false
calculated: 	copy ""

pattern: [
	[[0 0] [0]]
	[[0 1] [0]]
	[[1 0] [0]]
	[[1 1] [0]]
]	

ops: ["AND" "NAND" "OR" "XOR" "NOR" "XNOR"]
op: ops/1
switch op [
	"AND" 	[changePattern 0 0 0 1] ;--OK
	"NAND"	[changePattern 1 1 1 0] ;--OK
    "OR"  	[changePattern 0 1 1 1] ;--OK
    "XOR" 	[changePattern 1 0 0 1]	;--OK
    "NOR" 	[changePattern 1 0 0 0] ;--OK
    "XNOR"	[changePattern 0 1 1 0]	;--OK
]

t: dt [ 
	makeNetwork nInput nHidden nOutput ;--(2 3 1)  
	b: trainNetwork pattern n lr mf
]

print ["Expected:" expected]
print ["Result  :" calculated]
print ["Duration:" round/to third t 0.01 "sec"]
either isLearned? [print as-yellow "Learning is fine!"]
				  [print as-red "No learning"]

cv/imshow/name :img "Neural Network"
cv/moveWindow "Neural Network"  200x10
cv/waitKey 0


