//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");

test {
  std.testing.refAllDecls(@This());
  //_ = @import("./tests/t000/test.zig");
  //_ = @import("./lib/slate/src/tests.zig");
}

test "4321" {
  const Tk = @import("./minim/rules.zig").Tk;

  const name = @typeName(Tk.Wht);
  std.debug.print("{s}\n", .{name});
  const start = start: {
    const last = std.mem.lastIndexOfScalar(u8, name, '.') orelse 0;
    if (last == 0) { break :start last;   }
    else           { break :start last+1; }
  };
  std.debug.print("{?}\n", .{start});
  const T = name[start..name.len];
  std.debug.print("{s}\n", .{T});

  std.debug.print("............\n", .{});
  const asd :Tk.Id= Tk.Id.Wht_space;
  std.debug.print("4321: {s}\n", .{@tagName(asd)});
}

