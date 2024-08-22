#!/usr/local/bin/r3
REBOL [ 
] 
;--from Oldes
print "----------- MD5 --------------"
print checksum "my house in the middle of our street" 'MD5 
print "---------- SHA1 --------------"
print checksum "my house in the middle of our street" 'SHA1 
print "--------- SHA256 --------------"
print checksum "my house in the middle of our street" 'SHA256 
print "--------- SHA384 -------------"
print checksum "my house in the middle of our street" 'SHA384 
print "--------- SHA512 -------------"
print checksum "my house in the middle of our street" 'SHA512 
print "--------- CRC32 --------------"
print checksum "my house in the middle of our street" 'CRC32 
print "---------- TCP --------------"
print checksum "my house in the middle of our street" 'TCP
