#!/usr/local/bin/r3
REBOL [ 
] 
{Brotli can compress files in the following formats: text/xml, text/plain, text/css, 
application/javascript, application/x-javascript, application/rss+xml, text/javascript, 
image/tiff, image/svg+xml, application/json, and application/xml.}

brotli: import brotli 

compress-file: function[file][
    src: open/read file                 ;; input file
    out: open/new/write join file %.br  ;; output file
    enc: brotli/make-encoder/level 6    ;; initialize Brotli encoder
    enc/size-hint: size? src
    enc/mode: 1 ;= text input (0, 1 ou 2)
    chunk-size: 65536
    while [not finish][
        chunk: copy/part src chunk-size
        ;; If length of the chunk is less than chunk-size,
        ;; it must be the last chunk and we can finish the stream.
        finish: chunk-size > length? chunk
        ;; Flush output after each chunk.
        write out brotli/write/flush/:finish :enc :chunk
    ]
    close src
    close out
]
decompress-file: function[file][
    src: open/read file                 ;; input file
    dec: brotli/make-decoder            ;; initialize Brotli decoder
    chunk-size: 65536
    while [not empty? chunk: copy/part src chunk-size][
        brotli/write :dec :chunk
    ]
    close src
    brotli/read :dec
]

file: request-file/title "Select file"
bin: compress-file file
txt: decompress-file bin
print to string! txt
