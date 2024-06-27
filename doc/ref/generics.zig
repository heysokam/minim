const std = @import("std");

fn Base(comptime T: type) type {
  return struct {
    pub fn func(s: T) void {
      std.debug.print("Iter.func {}\n", .{s});
    }
  };
}

const Sub = struct {
  pub usingnamespace Base(Sub);
};

pub fn main() void {
  var x = Sub{};
  x.func();
}
