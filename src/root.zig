//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

pub export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}

//thinking about how this problem is it is best to use a parallel approach
// the bytes in a field could have nested values be have windows and have a custom type

//#1 we will use async/await (Some exceptions will be made for simple inline functions)
//#2 pure functions for everything unless absolutely needed
//#3 we will use snake_case no exceptions
//#4 global constance will be in the config.zig file and will be in all caps
//NOTE: keep global constance to a minimum and accompany them with documentation always
//#5 all dsl functions that are C macros or comptime zig will be prefixed with make_...
//#6 We will ideally keep all of the code in Zig, some exceptions can be made for C or assembly, though unlikely
//#7: We will leverage compiler-enabled safety features (e.g., debug and safe builds, sanitizers) during development and testing.
//#8: Every function/macro that calls another function is required to have a unit test to validate its behavior and correctness.
//NOTE: These tests must be declared in test blocks at the bottom function code they are testing.

pub fn make_byte_parser() type {}
