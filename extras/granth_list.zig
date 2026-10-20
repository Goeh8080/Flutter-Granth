// Standalone sample; not part of the app build.
const std = @import("std");

pub fn main() void {
    const granths = [_][]const u8{ "Gita", "Kabir Sagar", "Ved" };
    for (granths, 1..) |g, i| std.debug.print("{d}. {s}\n", .{ i, g });
}
// Granth list sample Granth list sampl
