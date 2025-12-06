#!/usr/local/bin/r3
REBOL [ 
] 
{Additionally, this extension provides a streaming API, 
allowing data to be (de)compressed in chunks without requiring it
 to be fully loaded into memory.}
brotli: import brotli      ;; Import the module and assign it to a variable
enc: brotli/make-encoder   ;; Initialize the Brotli encoder state handle
brotli/write :enc "Hello"  ;; Process some input data
brotli/write :enc " "
brotli/write :enc "Brotli"
;; When there is enough data to compress,
;; use `read` to finish the current data block and get the encoded chunk
bin1: brotli/read :enc
;; Continue with other data and use `/finish` to encode all remaining input
;; and mark the stream as complete.
bin2: brotli/write/finish :enc " from Rebol!"
;; Decompress both compressed blocks again (using extension's command this time):
print text: to string! brotli/decompress join bin1 bin2
