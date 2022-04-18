const std = @import("std");
const testing = std.testing;

pub fn Stack(comptime T: type) type {
    return struct {
        stack: std.ArrayList(T),

        const Self = @This();
    };
}

test "stack init" { }
test "stack deinit" { }
test "stack push" { }
test "stack pop" { }
test "stack peek" { }
test "stack peek_mut" { }
test "stack count" { }
test "stack isEmpty" { }
