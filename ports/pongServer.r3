#!/usr/local/bin/r3
REBOL [
]
print "Ping pong server"

server: open tcp://:8080

server/awake: func [event /local port] [
    if event/type = 'accept [
        port: first event/port
        port/awake: func [event] [
            ;probe event/type
            switch event/type [
                read [
                    print ["Client said:" to-string event/port/data]
                    clear event/port/data
                    write event/port to-binary "pong!"
                ]
                wrote [
                    print "Server sent pong to client"
                    read event/port
                ]
                close [
                    close event/port
                    return true
                ]
            ]
            false
        ]
        read port
    ]
    false
]

wait [server 30]
close server