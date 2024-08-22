#!/usr/local/bin/r3
Rebol [
    title: "Console Color test"
]
print-horizontal-line
print "Running test on Rebol build:" 	
print as-white mold to-block system/build
print-horizontal-line
print as-blue   "Hello Blue"        
print as-cyan 	"Hello Cyan"            
print as-green  "Hello Green"         
print as-purple	"Hello Purple"           
print as-red 	"Hello Red"             
print as-white 	"Hello White"           
print as-yellow "Hello Yellow" 
print-horizontal-line
n: 1000
print [as-red "Test value:" as-yellow n as-green "Correct"]
print-horizontal-line
