// Xian by Alyx Shang.
// Licensed under the FSL v1.

// Importing the standard
// library.
const std = @import("std");

// Importing the error-handling
// entity.
const err = @import("err.zig");

// Importing the "ArrayList"
// entity.
const ArrayList = @import("std").ArrayList;

/// This function returns
/// the length of a string slice
/// with a null-terminator as an 
/// unsigned integer.
pub fn sliceLen(
    subject: [*:0]const u8
) usize {
    var len: usize = 0;
    var copy = subject;
    while (copy[0] != 0) {
        len += 1;
        copy += 1;
    }
    return len;
}


/// This function comapres
/// two string slices. A boolean
/// is returned depending on whether
/// they are equal or not.
pub fn compareSlices(
    one: [*:0]const u8,
    two: [*:0]const u8
) bool {
    var result: bool = true;
    const one_len: usize = sliceLen(one);
    for (0..one_len) |idx| {
        if (one[idx] != two[idx]){
            result = false;
        }
    }
    return result;
}

/// Compares the items 
/// in two arrays of unsigned
/// integers of maximum length 8.
/// Returns a boolean depending on
/// their equality.
pub fn compareCharArrays(
    one: ArrayList(u8),
    two: ArrayList(u8)
) bool {
    var result: bool = true;
    if (one.items.len != two.items.len){
        result = false;
    }
    else {
        for (one.items, 0..) |item, idx| {
            if (two.items[idx] != item){
                result = false;
            }
        }
    }
    return result;
}

/// Removes the character
/// at the given index and
/// returns that array. If
/// the operation fails,
/// an error is returned.
pub fn removeIndex(
    idx: usize,
    sub: *ArrayList(u8),
    allocator: std.mem.Allocator
) !ArrayList(u8) {
    var new_arr: ArrayList(u8) = ArrayList(u8)
        .init(allocator);
    for (sub.items, 0..) |item, i| {
        if (i != idx){
            new_arr.append(item)
                catch return err.XianErr.WriteErr;
        }
    }
    return new_arr;
}
