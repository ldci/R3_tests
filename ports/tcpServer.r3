#!/usr/local/bin/r3
REBOL []

dir: %temp/
make-dir dir

do-command: func [port /local cmd] [
    cmd: attempt [load port/data]
    if all [cmd parse cmd [file! integer!]] [
        do in port/locals [
            name: first cmd
            size: second cmd
            file: open/new dir/:name
        ]
        return true
    ]
    false
]

transfer: func [port] [
    ;port/locals: context [name: size: file: none total: 0]
    locals: context [name: size: file: none total: 0]
    port/awake: func [event /locals port locs len] [
        print ['subport event/type]
        port: event/port
        ;locs: port/locals
        locs: copy locals
        probe locs
        switch event/type [
            read [
                ; If the file is open, transfer next chunk:
                either locs/file [
                    len: length? port/data
                    locs/total: locs/total + len
                    write locs/file port/data
                    clear port/data
                    print ["len:" len "total:" locs/total "of" locs/size]
                    read port
                ][
                    ; Otherwise, process the startup command:
                    either do-command port [
                        write port to-binary "go"
                    ][
                        read port ; get rest of start command
                    ]
                ]
            ]
            wrote [read port]
            close [
                if locs/file [close locs/file]
                close port
                return true
            ]
        ]
        false
    ]
    read port ; wait for client to speak
]

server: open tcp://:8080
print "Server Ready"
server/awake: func [event /local port] [
    print ['server event/type]
    if event/type = 'accept [
        transfer first event/port
    ]
    false
]
wait [server 10] ; Note: increase the timeout for large files
close server