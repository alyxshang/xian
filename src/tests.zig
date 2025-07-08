// Xian by Alyx Shang.
// Licensed under the FSL v1.

// Importing the standard
// library.
const std = @import("std");

// Defining the "ArrayList" structure.
const ArrayList = std.ArrayList;

// Aliasing the "expect" function
// from the standard library.
const expect = std.testing.expect;

// Importing the main module
// containing the `String`
// structure.
const string = @import("string.zig");

// Importing the module
// that provides functions
// for string slices.
const slices = @import("slices.zig");

// Testing the "fromArray" function.
test "Testing the \"fromArray\" function." {
    var char_arr: ArrayList(u8) = ArrayList(u8)
        .init(std.testing.allocator);
    try char_arr.append('h');
    try char_arr.append('e');
    try char_arr.append('l');
    try char_arr.append('l');
    try char_arr.append('o');
    try char_arr.append(0);
    var arr_str = string
        .String
        .fromCharArray(
            char_arr,
            std.testing.allocator
        );
    defer arr_str.deinit();
    try expect(arr_str.len() == 5);
}

// Testing the "len" function.
test "Testing the \"len\" function." {
    var my_str: string.String = try string
        .String
        .init(
            "hello", 
            std.testing.allocator
        );
    defer my_str.deinit();
    try expect(my_str.len() == 5);
}

// Testing the "contains" function.
test "Testing the \"contains\" function." {
    var my_str: string.String = try string
        .String
        .init(
            "hello", 
            std.testing.allocator
        );
    defer my_str.deinit();
    try expect(my_str.contains('e'));
}

// Testing the "chars" function.
test "Testing the \"chars\" function." {
    var my_str: string.String = try string
        .String
        .init(
            "hello", 
            std.testing.allocator
        );
    defer my_str.deinit();
    var char_arr: ArrayList(u8) = ArrayList(u8)
        .init(std.testing.allocator);
    defer char_arr.deinit();
    try char_arr.append('h');
    try char_arr.append('e');
    try char_arr.append('l');
    try char_arr.append('l');
    try char_arr.append('o');
    try char_arr.append(0);
    try expect(slices.compareCharArrays(my_str.chars(),char_arr));
}

// Testing the "sliceLen" function.
test "Testing the \"sliceLen\" function." {
    const my_str: [*:0]const u8 = "hehe";
    try expect(slices.sliceLen(my_str) == 4);
}

// Testing the "clear" and the "isEmpty" 
// function.
test "Testing the \"clear\" and \"isEmpty\" functions."{
    var new_str: string.String = try string
        .String
        .init(
            "haha hehe",
            std.testing.allocator
        );
    var empty_str: string.String = new_str.clear();
    try expect(empty_str.isEmpty() == true);
}

// Testing the "remove", "push", and "asSlice" functions."
test "Testing the \"remove\", \"push\", and \"asSlice\" functions." {
    var new_str: string.String = try string
        .String
        .init(
            "haha",
            std.testing.allocator
        );
    defer new_str.deinit();
    var edited: string.String = try new_str.remove(3);
    defer edited.deinit();
    try edited.push('a');
    try expect(slices.compareSlices(new_str.asSlice(), "haha") == true);
}

// Testing the "pop" function.
test "Testing the \"pop\" function." {
    var new_str: string.String = try string
        .String
        .init(
            "haha",
            std.testing.allocator
        );
    defer new_str.deinit();
    try new_str.pop();
    try expect(new_str.len() == 3);
}

// Testing the "joinStrings" function.
test "Testing the \"joinStrings\" function." {
    var str_arr = ArrayList(string.String)
        .init(std.testing.allocator);
    defer str_arr.deinit();
    var part_one: string.String = try string
        .String
        .init(
            "haha",
            std.testing.allocator
        );
    defer part_one.deinit();
    var part_two: string.String = try string
        .String
        .init(
            "hehe",
            std.testing.allocator
        );
    defer part_two.deinit();
    var joiner: string.String = try string
        .String
        .init(
            " ",
            std.testing.allocator
        );
    defer joiner.deinit();
    try str_arr.append(part_one);
    try str_arr.append(part_two);
    var new_str: string.String = try string.joinStrings(
        str_arr,
        joiner,
        std.testing.allocator
    );
    defer new_str.deinit();
    try expect(slices.compareSlices(new_str.asSlice(), "haha hehe"));
}

// Testing the "split" function.
test "Testing the \"split\" function." {
    var orig: string.String = try string
        .String
        .init(
            "haha hehe",
            std.testing.allocator
        );
    defer orig.deinit();
    var part_one: string.String = try string
        .String
        .init(
            "haha",
            std.testing.allocator
        );
    defer part_one.deinit();
    var part_two: string.String = try string
        .String
        .init(
            "hehe",
            std.testing.allocator
        );
    defer part_two.deinit();
    var split_list = try orig.split(
        ' ' 
    );
    defer {
        for (split_list.items) |*str| {
            str.deinit();
        }
        split_list.deinit();
    }
    var joiner = try string
        .String
        .init(
            " ",
            std.testing.allocator
        );
    defer joiner.deinit();
    var joined = try string
        .joinStrings(
            split_list,
            joiner,
            std.testing.allocator
        );
    defer joined.deinit();
    try expect(
        slices.compareSlices(
            joined.asSlice(),
            "haha hehe"
        )
    );
}
