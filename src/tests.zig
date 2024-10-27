//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");

test {
  std.testing.refAllDecls(@This());
  // _ = @import("./lib/slate/src/tests.zig");
  _ = @import("./tests/t000/test.zig"); // Basic Codegen
  _ = @import("./tests/t001/test.zig"); // Procs
}

