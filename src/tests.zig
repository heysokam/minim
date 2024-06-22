//:____________________________________________________________________
//  msyn  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
const std = @import("std");

test {
  std.testing.refAllDecls(@This());
  _ = @import("./tests/t000/test.zig");
}
