//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");

test {
  std.testing.refAllDecls(@This());
  _ = @import("./runic/C.zig");
  _ = @import("./runic/zig.zig");
}

