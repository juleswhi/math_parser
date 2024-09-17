const std = @import("std");
const parse = @import("parse.zig").parse;

pub fn main() !void {
    const al = std.heap.page_allocator;
    const data = try read_file("math", &al);
    var expr = std.mem.split(u8, data, "\n");
    const first = expr.first();

    try parse(first);

    // std.debug.print("{s}\n", .{data});
}

fn read_file(filename: []const u8, alloc: *const std.mem.Allocator) ![]const u8 {
    var data = std.ArrayList(u8).init(alloc.*);
    defer data.deinit();
    const file = std.fs.cwd().openFile(filename, .{}) catch |err| {
        std.log.err("Failed to open file: {s}", .{@errorName(err)});
        return err;
    };
    defer file.close();

    while (file.reader().readUntilDelimiterOrEofAlloc(alloc.*, '\n', std.math.maxInt(usize)) catch |err| {
        std.log.err("Failed to read line: {s}", .{@errorName(err)});
        return err;
    }) |line| {
        defer alloc.*.free(line);
        try data.appendSlice(line);
    }

    return data.toOwnedSlice();
}
