// Xian by Alyx Shang.
// Licensed under the FSL v1.

// Declaring the error module.
const err = @import("err.zig");

// Declaring the main "string"
// module.
const string = @import("string.zig");

// Declaring the "slices" module.
const slices = @import("slices.zig");

// Exporting the module for handling 
// errors in this library.
pub usingnamespace err;

// Exporting the main module providing
// the `String` structure.
pub usingnamespace string;

// Exporting the module providing
// functions for string slices.
pub usingnamespace slices;
