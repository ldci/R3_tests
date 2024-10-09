#!/usr/local/bin/r3
REBOL [Title: "Simple Async HTTP"
Note: {
		Based on original Port examples which can be found at:
		https://web.archive.org/web/20131012055435/http://www.rebol.net:80/wiki/Port_Examples
	}
]

send-http-request: func [port] [
    write port to-binary ajoin [
        "GET " port/spec/path " HTTP/1.0" crlf
        "Host: " port/spec/host crlf
        crlf
    ]
]

read-http: func [
    "Async HTTP reader"
    url [url!]
    /local spec port
][
    spec: probe decode-url url
    spec/2: to-lit-word 'tcp
    port: open spec

    port/awake: func [event] [
        print ["Awake-event:" event/type]
        switch/default event/type [
            lookup [open event/port]
            connect [send-http-request event/port]
            wrote [read event/port]
            read  [
                print ["Read" length? event/port/data "bytes"]
                read event/port
            ]
            close [return true]
        ] [
            print ["Unexpected event:" event/type]
            close event/port
            return true
        ]
        false ; returned
    ]
    port
]

print "reading..."
rp: read-http http://www.rebol.net/
wait [rp 10]
close rp
print to-string rp/data

data: copy/part find/tail rp/data #{0d0a0d0a} tail rp/data

write %rebol-net.html data
browse %rebol-net.html