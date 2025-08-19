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
//#9 const's and vars that need to be computed then stored in a struct must fallow the naming convection and be padded with an _ so we can maintain the namespace
// EXAMPLE:
//blk:{
// const _foo_ = ... ;
// return struct {
//          const foo = _foo_
//      }
//    }
pub fn make_type_union(comptime byte_fields: anytype) type {
    _ = byte_fields;
    return union(enum) {
        err: ?*anyopaque, // The field for an error, typically a pointer to an error type.
    };
}
test "make_type_union" {
    std.debug.print("\n[test] ___make_type_union___\n", .{});
    std.debug.print("[test] calling make_type_union(type)\n", .{});
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
    std.debug.print("\n[test] ___make_protocol_type___\n", .{});
    std.debug.print("[test] calling make_protocol_type(type)\n", .{});
    const test_type = make_protocol_type(.{}, .{});
    std.debug.print("[test] creation of type was successful {any}\n", .{test_type});
}

/// byte_type is the interpretation of the bytes if this is a nested field when the filed is inspected it will grab the parser for that field
/// TODO make floats work
/// TODO make non standard bit widths work
/// as of now the float types and custom bit widths dont work and will return a 0 or a 0.0
pub fn make_byte_field_type(comptime byte_type: type, comptime start_offset: u32, comptime endian: std.builtin.Endian, comptime msg_length: u32) type {
    const info = @typeInfo(byte_type);
    const _num_bits_ = info.int.bits;
    const _num_bytes_: u32 = std.math.divCeil(u32, _num_bits_, 8) catch |err| switch (err) {
        else => {
            std.debug.print("Error: {any}\n", .{err});
            return 0; // Return a fallback value
        },
    };
    switch (info) {
        .int => {
            const _bit_remainder_ = _num_bits_ % 8;
            if (_bit_remainder_ != 0) {
                return struct {
                    const num_bits = _num_bits_;
                    const num_bytes: u32 = _num_bytes_;
                    const bit_remainder = _bit_remainder_;
                    pub fn interpret_bytes(raw_bytes: [msg_length]u8) byte_type {
                        _ = raw_bytes;
                        return 0;
                    }
                };
            }
            return struct {
                const num_bits = _num_bits_;
                const num_bytes: u32 = _num_bytes_;
                const bit_remainder = _bit_remainder_;
                pub fn interpret_bytes(raw_bytes: [msg_length]u8) byte_type {
                    const ret: byte_type = std.mem.readInt(byte_type, raw_bytes[start_offset .. start_offset + num_bytes], endian);
                    return ret;
                }
            };
        },
        .float => {
            //const bit_remainder = num_bits % 8;
            return struct {
                const num_bits = _num_bits_;
                const num_bytes: u32 = _num_bytes_;
                pub fn interpret_bytes(raw_bytes: [msg_length]u8) byte_type {
                    _ = raw_bytes;
                    _ = num_bytes;
                    const ret: byte_type = 0.0;
                    return ret;
                }
            };
        },
        else => {},
    }
}
test "make_byte_field_type" {
    const rand = std.crypto.random;
    const rand_bytes = blk: {
        var temp_array: [64]u8 = undefined;
        // This `inline for` loop runs at compile time
        // and unrolls into three separate assignments.
        inline for (0..64) |i| {
            temp_array[i] = rand.int(u8);
        }
        break :blk temp_array;
    };
    std.debug.print("\n[test] ___make_byte_field_type___\n", .{});
    std.debug.print("[test BF] obj creation BF Check\n", .{});
    inline for (config.config().NUMBER_TYPES) |ty| {
        const test_field = make_byte_field_type(ty, 0, .little, 64);
        const res = test_field.interpret_bytes(rand_bytes);
        std.debug.print("[test BF] interpreted bytes was [{any}]\n", .{res});
        std.debug.print("[test BF] creation of type was successful {any}\n", .{test_field});
    }
    //_ = rand_bytes;
    const raw_bytes: [8]u8 = .{ 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08 };
    std.debug.print("[test] testing Hex: 01 02 03 04 05 06 07 08\n", .{});
    std.debug.print("[test 1] Reading a u32 (integer) with little endian\n", .{});
    const field_u32_le = make_byte_field_type(u32, 0, .little, 8);
    const value_u32_le = field_u32_le.interpret_bytes(raw_bytes);
    try std.testing.expectEqual(@as(u32, 0x04030201), value_u32_le);
    std.debug.print("[test 1] pass >> {any} = {any}\n", .{ @as(u32, 0x04030201), value_u32_le });
}

pub fn make_message_type(comptime byte_fields: anytype) type {
    return struct {
        const passed_struct_type = @TypeOf(byte_fields);
        const name = @typeName(passed_struct_type); //_ = passed_struct_type;
        const type_info = @typeInfo(passed_struct_type);

        pub fn print() void {
            std.debug.print("{str}\n", .{name});
            inline for (type_info.@"struct".fields) |value| {
                std.debug.print("{str} {any} {any} {any} {any}\n", value);
            }
        }
    };
}
test "make_message_type" {
    std.debug.print("\n[test] ___make_message_type___\n", .{});
    const test_message = make_message_type(.{ .this = 5, .that = make_byte_field_type(u8, 0, .little, 64) });
    test_message.print();
    //std.debug.print("\n[test] make_message_type fields >> {any}\n", .{test_message.comptime_fields});
}
