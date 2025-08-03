//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const config = @import("config.zig");
const testing = std.testing;
//thinking about how this problem is it is best to use a parallel approach
// the bytes in a field could have nested values be have windows and have a custom type

//#1 we will use async/await (Some exceptions will be made for simple inline functions)
//#2 pure functions for everything unless absolutely needed
//#3 we will use snake_case no exceptions
//#4 global constance will be in the config.zig file and will be in all caps
//NOTE: keep global constance to a minimum and accompany them with documentation always
//#5 all dsl functions that are C macros or comptime zig will be prefixed with make_... and suffixed with the construct it returns e.g _type or _fn
//#6 We will ideally keep all of the code in Zig, some exceptions can be made for C or assembly, though unlikely
//#7: We will leverage compiler-enabled safety features (e.g., debug and safe builds, sanitizers) during development and testing.
//#8: Every function/macro that calls another function is required to have a unit test to validate its behavior and correctness.
//NOTE: These tests must be declared in test blocks at the bottom function code they are testing.

pub fn make_type_union(comptime byte_fields: anytype) type {
    _ = byte_fields;
    return union(enum) {
        err: ?*anyopaque, // The field for an error, typically a pointer to an error type.
    };
}
test "make_type_union" {
    std.debug.print("\n[test] make_type_union\n", .{});
    std.debug.print("[test] calling make_type_union(type)", .{});
    const test_type = make_type_union(.{});
    std.debug.print("[test] creation of the type was successful {any}\n", .{test_type});
}

/// this is a comptime fn that returns a obj that contanes the fn for parsing the bytes
pub fn make_protocol_type(comptime header_byte_fields: anytype, comptime message_types: anytype) type {
    return struct {

        //this is how the compiler know how to handel the vals that are returned after inspection
        //this is unfortunate for messages with large data fields as the val will be large but the
        //trade off is that we can have lazy dynamic behavior with a minimal memory overhead
        return_union: type = union(enum) {
            header_types: make_type_union(header_byte_fields),
            messages_types: make_type_union(message_types),
        },
    };
}
test "make_protocol_type" {
    std.debug.print("\n[test] make_protocol_type\n", .{});
    std.debug.print("[test] calling make_protocol_type(type)\n", .{});
    const test_type = make_protocol_type(.{}, .{});
    std.debug.print("[test] creation of type was successful {any}\n", .{test_type});
}

pub fn make_message_type(comptime byte_fields: anytype) type {
    _ = byte_fields;
    return struct {};
}
test "make_message_type" {}

/// byte_type is the interpretation of the bytes if this is a nested field when the filed is inspected it will grab the parser for that field
pub fn make_byte_field_type(comptime byte_type: type, comptime start_offset: u8) type {
    _ = byte_type;
    _ = start_offset;
    return struct {
        pub fn interpret_bytes(raw_bytes: []const u8) byte_type {}
    };
}
test "make_byte_field_type" {
    std.debug.print("\n[test] make_byte_field_type\n", .{});
}
