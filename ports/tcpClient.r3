#!/usr/local/bin/r3
REBOL []

file-name: %color.png

info: query file-name none!
size: info/size
file: none

client: open tcp://127.0.0.1:8080

send-chunk: func [port file /local data] [
    data: read/part file 20000
    if empty? data [return false]
    print ["send:" length? data "bytes"]
    write port data
    true
]

client/awake: func [event /local port result] [
    probe event/type
    port: event/port
    switch event/type [
        read [
            ; What did the server tell us?
            result: load port/data
            clear port/data
            print ["Server says:" result]
            either result = 'go [
                file: open file-name
                send-chunk port file
            ][
                close port
            ]
        ]
        wrote [
            ; Ready for next chunk:
            either file [
                unless send-chunk port file [
                    close port ; finished!
                    return true
                ]
            ][
                ; Ask for server reply:
                read port
            ]
        ]
        close [
            if file [close file]
            close port
            return true
        ]
        lookup [open port]
        connect [
            write port to-binary remold [file-name size]
        ]
    ]
    false
]

wait [client 10] ; timeout after 10 seconds
if file [close file] ; to be sure
close client