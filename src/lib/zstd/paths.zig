const std = @import("std");

inline fn thisDir(allocator: std.mem.Allocator) []const u8 {
  const abspath = comptime std.fs.path.dirname(@src().file) orelse ".";
  return std.fs.path.relative(allocator, "./", abspath) catch unreachable;
}

