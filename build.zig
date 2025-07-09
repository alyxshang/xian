// Xian by Alyx Shang.
// Licensed under the FSL v1.

// Importing the standard library for
// using this as a script.
const std = @import("std");

// The main function to invoke any
// build routines.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    b.addModule(
        "xian",
        .{
            .root_source_file = b.path("src/root.zig")
        }
    );
    const lib_test = b.addTest(
        .{
            .root_source_file = b.path("./src/tests.zig"),
            .target = target,
            .optimize = optimize,
        }
    );
    const test_step = b.step("test", "Run library tests.");
    test_step.dependOn(&lib_test.step);
}
