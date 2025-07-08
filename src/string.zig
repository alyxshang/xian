// Xian by Alyx Shang.
// Licensed under the FSL v1.

// Importing the 
// standard library.
const std = @import("std");

// Importing the library's
// error-handling entity.
const err = @import("err.zig");

// Importing the `ArrayList`
// structure.
const ArrayList = std.ArrayList;

// Importing functions for working
// with slices and arrays.
const slices = @import("slices.zig");

/// A stucture to emulate a
/// string-like entity in Zig.
pub const String = struct {
    characters: ArrayList(u8),
    allocator: std.mem.Allocator,

    /// The default "constructor"
    /// for the `String` entity.
    /// Returns a completed string
    /// or an error if memory-allocation
    /// fails.
    pub fn init(
        subject: [*:0]const u8,
        allocator: std.mem.Allocator
    ) !String {
        var char_array: ArrayList(u8) = ArrayList(u8)
            .init(allocator);
        var ptr_casted = subject;
        while (ptr_casted[0] != 0){
            char_array.append(ptr_casted[0])
                catch return err.XianErr.WriteErr;
            ptr_casted += 1;
        }
        char_array.append(0)
            catch return err.XianErr.WriteErr;
        return String {
            .characters = char_array,
            .allocator = allocator
        };
    }

    /// The typical `length` function.
    /// Returns the length of the string.
    pub fn len(self: *String) usize {
        var result: usize = 0;
        if (self.characters.items.len != 0){
            result = self.characters.items.len - 1;
        }
        return result;
    }

    /// Returns the characters inside the string.
    pub fn chars(self: *String) ArrayList(u8) {
        return self.characters;
    }

    /// Checks whether the current
    /// instance of the `String`
    /// structure contains the specified
    /// character. A boolean reflecting
    /// this is returned.
    pub fn contains(
        self: *String,
        sub: u8
    ) bool {
        var is_found: bool = false;
        for (self.characters.items) |item| {
            if (item == sub) {
                is_found = true;
            }
        }
        return is_found;
    }

    /// Creates a new instance of the
    /// `String` entity given an array
    /// of characters. This instance
    /// is then returned.
    pub fn fromCharArray(
        subject: ArrayList(u8),
        allocator: std.mem.Allocator
    ) String {
        return String {
            .characters = subject,
            .allocator = allocator
        };
    }
 
    /// Compares two strings.
    /// Returns a boolean based
    /// on the result of the
    /// comparison.
    pub fn compareStrings(
        self: *String,
        other: String
    ) bool {
        var result: bool = true;
        for (self.characters.items, 0..) |item, i|{
            if (item != other.characters.items[i]){
                result = false;
            }
        }
        return result;
    }

    /// Returns a new `String`
    /// with the character array
    /// contained within being empty.
    pub fn clear(
        self: *String
    ) String {
        self.characters.clearAndFree();
        return String {
            .characters = ArrayList(u8).init(self.allocator),
            .allocator = self.allocator
        };
    }

    /// Checks whether the string's
    /// length is zero or not.
    /// Returns a boolean depending
    /// on this.
    pub fn isEmpty(
        self: *String
    ) bool {
        var result: bool = undefined;
        if (self.len() == 0){
            result = true;
        }
        else {
            result = false;
        }
        return result;
    }

    /// Removes the character
    /// at the given index.
    /// If this index does
    /// not exist, an 
    /// error is returned.
    pub fn remove(
        self: *String,
        idx: usize
    ) !String {
        var new_chars: ArrayList(u8) = ArrayList(u8)
            .init(self.allocator);
        const length: usize = self.len();
        if (idx < 0 or idx > length){
            return err.XianErr.EmptyArray;
        }
        else {
            var counter: usize = 0;
            for (self.characters.items) |item| {
                if (counter != idx) {
                    new_chars.append(item)
                        catch return err.XianErr.WriteErr;
                }
                counter = counter + 1;
            }
        }
        return String.fromCharArray(
            new_chars, 
            self.allocator
        );
    }

    /// Builds a string
    /// slice from the current
    /// instance of the `String`
    /// structure.
    pub fn asSlice(
        self: *String
    ) [*:0]const u8 {
        const result: [*:0]const u8 = @ptrCast(
            self.characters.items.ptr
        );
        return result;
    }
 
    /// Appends a character to
    /// the string. Returns `void`
    /// if successful and an error
    /// if not.
    pub fn push(
        self: *String,
        sub: u8
    ) !void {
        self.characters.append(sub)
            catch return err.XianErr.WriteErr;
    }

    /// Removes the last character before
    /// the null-terminator from a string.
    /// If the operation fails, an error
    /// is returned.
    pub fn pop(
        self: *String
    ) !void {
        const last_idx: usize =
            self.len() - 1;
        const new_array = slices.removeIndex(
            last_idx,
            &self.characters,
            self.allocator
        )
            catch return err.XianErr.WriteErr;
        self.characters.deinit();
        self.characters = new_array;
    }

    pub fn split(
        self: *String,
        splitter: u8
    ) !ArrayList(String) {
        var arr_list = ArrayList(String)
            .init(self.allocator);
        var buffer = ArrayList(u8)
            .init(self.allocator);
        defer buffer.deinit();
        for (self.characters.items) |character| {
            if (character == splitter){
                buffer.append(0)
                    catch return err.XianErr.WriteErr;
                var buffer_copy = ArrayList(u8)
                    .init(self.allocator);
                buffer_copy.appendSlice(buffer.items)
                    catch return err.XianErr.WriteErr;
                const new_str = String.fromCharArray(
                    buffer_copy, 
                    self.allocator
                );
                arr_list.append(new_str)
                    catch return err.XianErr.WriteErr;
                buffer.clearRetainingCapacity();
            }
            else {
                buffer.append(character)
                    catch return err.XianErr.WriteErr;
            }
        }
        buffer.append(0)
            catch return err.XianErr.WriteErr;
        var buffer_copy = ArrayList(u8)
            .init(self.allocator);
        buffer_copy.appendSlice(buffer.items)
            catch return err.XianErr.WriteErr;
        const new_str = String.fromCharArray(
            buffer_copy, 
            self.allocator
        );
        arr_list.append(new_str)
            catch return err.XianErr.WriteErr;
        return arr_list;
    }

    /// Frees the memory allocated
    /// to the character array of
    /// this entity.
    pub fn deinit(
        self: *String
    ) void {
        self.characters.deinit();
    }
};

/// This function joins an array
/// of strings given a joining 
/// character into a new string.
pub fn joinStrings(
    arr: ArrayList(String),
    joiner: String,
    allocator: std.mem.Allocator
) !String {
    var char_array = ArrayList(u8)
        .init(allocator);
    for (arr.items, 0..) |item, i| {
        for (item.characters.items) |str_char| {
            if (str_char != 0){
                char_array.append(str_char)
                    catch return err.XianErr.WriteErr;
            }
        }
        if (i != arr.items.len - 1){
            for (joiner.characters.items) |character| {
                if (character != 0){
                    char_array.append(character)
                        catch return err.XianErr.WriteErr;
                }
            }
        }
    }
    char_array.append(0)
        catch return err.XianErr.WriteErr;
    const result = String.fromCharArray(
        char_array, 
        allocator
    );
    return result;
}
