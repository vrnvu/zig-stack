const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;

pub fn Stack(comptime T: type) type {
    return struct {
        stack: std.ArrayList(T),

        const Self = @This();

        pub fn init(allocator: Allocator) Self {
            return Self{ .stack = std.ArrayList(T).init(allocator) };
        }

        pub fn deinit(self: *Self) void {
            self.stack.deinit();
        }

        pub fn push(self: *Self, value: T) !void {
            try self.stack.append(value);
        }

        pub fn pop(self: *Self) ?T {
            return self.stack.popOrNull();
        }

        pub fn count(self: *Self) usize {
            return self.stack.items.len;
        }

        pub fn isEmpty(self: *Self) bool {
            return self.count() == 0;
        }

        pub fn peek(self: *Self) ?T {
            if (self.isEmpty()) {
                return null;
            }
            return self.stack.items[self.count() - 1];
        }

        pub fn peekMut(self: *Self) ?*T {
            if (self.isEmpty()) {
                return null;
            }
            return &self.stack.items[self.count() - 1];
        }
    };
}

test "stack init and deinit" {
    const IntStack = Stack(i32);
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    var s = IntStack.init(gpa.allocator());
    defer s.deinit();

    try testing.expect(s.isEmpty());
    try testing.expect(s.count() == 0);
}

test "stack push and pop" {
    const IntStack = Stack(i32);
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    var s = IntStack.init(gpa.allocator());
    defer s.deinit();

    try s.push(1);
    try s.push(2);
    try s.push(3);

    try testing.expect(!s.isEmpty());
    try testing.expect(s.count() == 3);

    try testing.expect(s.pop().? == 3);
    try testing.expect(s.pop().? == 2);
    try testing.expect(s.pop().? == 1);

    try testing.expect(s.isEmpty());
}

test "stack peek" {
    const IntStack = Stack(i32);
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    var s = IntStack.init(gpa.allocator());
    defer s.deinit();

    try s.push(1);

    try testing.expect(s.peek().? == 1);
}

test "stack peekMut" {
    const IntStack = Stack(i32);
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    var s = IntStack.init(gpa.allocator());
    defer s.deinit();

    try s.push(1);

    var value = s.peekMut().?;
    value.* = 2;

    try testing.expect(s.peek().? == 2);
}