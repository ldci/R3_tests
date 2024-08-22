#!/usr/local/bin/r3
REBOL [
]
comment [
"All these types can be used"
#(byte!)
#(i8! )
#(i16!)
#(i32!)
#(i64!)
#(u8! )
#(u16!)
#(u32!)
#(u64!)
#(f32!)
#(f64!)
#(int8!)
#(int16!)
#(int32!)
#(int64!)
#(uint8!)
#(uint16!)
#(uint32!)
#(uint64!)
#(float!) 	;--32-bit
#(double!)	;--64-bit	
]

;--see vector-test.r3

print "Compact construction syntax (empty)"
prin "i32!: "  probe #(i32!)
prin "u32!: "  probe #(u32!)

print "Compact construction syntax (size)"
prin "i32!: "  probe #(i32! 3)
prin "u32!: "  probe #(u32! 3)

print "Compact construction syntax (data)"
prin "i32!: "  probe #(i32! [1 2 3])
prin "u32!: "  probe #(u32! [4 5 6])

print "Compact construction syntax (data with index)"
prin "i32!: "  probe #(i32! [1 2 3] 2)
prin "u32!: "  probe #(u32! [4 5 6] 2)

print "Semi-compact construction"
prin "i32!: "  probe make vector! [i32!]
prin "u32!: "  probe make vector! [u32!]

prin "i32!: "  probe make vector! [i32! 3]
prin "u32!: "  probe make vector! [u32! 3]

prin "i32!: "  probe make vector! [i32! [1 2 3]]
prin "u32!: "  probe make vector! [u32! [4 5 6]]

prin "i32!: "  probe make vector! [i32! [1 2 3] 2]
prin "u32!: "  probe make vector! [u32! [4 5 6] 2]