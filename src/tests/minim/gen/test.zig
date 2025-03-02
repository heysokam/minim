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
  // TODO:
  // _ = @import("./t003/test.zig"); // Modules and Namespaces
  // _ = @import("./t004/test.zig"); // Standalone Pragmas
  // _ = @import("./t005/test.zig"); // Discard
  // _ = @import("./t006/test.zig"); // Comments and Newlines
  // _ = @import("./t007/test.zig"); // Control Flow
  // _ = @import("./t008/test.zig"); // Calls
  // _ = @import("./t009/test.zig"); // Types
  // _ = @import("./t010/test.zig"); // Affixes
  // _ = @import("./t011/test.zig"); // Cast
}

