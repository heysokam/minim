//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");

test {
  std.testing.refAllDecls(@This());
  _ = @import("./minim/t000/test.zig"); // Basic Codegen
  _ = @import("./minim/t001/test.zig"); // Procs
}

