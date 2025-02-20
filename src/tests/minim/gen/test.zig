//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");

test {
  std.testing.refAllDecls(@This());
  _ = @import("./bugs/test.zig"); // Bug Fixes
  _ = @import("./t000/test.zig"); // Basic Codegen
  _ = @import("./t001/test.zig"); // Procs
  _ = @import("./t002/test.zig"); // Variables
}

