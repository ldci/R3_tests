#!/usr/local/bin/r3
REBOL [Title: "Sender"]
;-- Read the data: 
file: %color.png
data: read/binary file
;-- Open the binary TCP socket:
print "Opening to send..."
;--rebol 2
;server: open/binary/no-wait tcp://127.0.0.1:8000

server: open/read file
;-- Send the data:
print ["Sending" file "..."]
;rebol 2
;insert data append remold [file length? data] #"" 
;insert server data

;-- Wait for the server to respond, then close. wait server
close server
ask "Done"