const std = @import("std");
pub fn parse(str: []const u8) !void {
    var sum: i32 = 0;

    var plus_iter = std.mem.split(u8, str, "+");
    while (plus_iter.next()) |x| {
        sum += parse_mult(x);
    }

    std.debug.print("Output Number: {}\n", .{sum});
}

fn parse_mult(x: []const u8) i32 {
    var prod: i32 = 1;
    var mult_iter = std.mem.split(u8, x, "*");
    while (mult_iter.next()) |y| {
        prod *= std.fmt.parseInt(i32, y, 10) catch |e| {
            std.debug.print("Error: {}, {s} would not parse", .{ e, y });
            unreachable;
        };
    }
    return prod;
}
