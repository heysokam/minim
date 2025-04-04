//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");

test {
  std.testing.refAllDecls(@This());
  _ = @import("./minim/tok/test.zig"); // Tokenizer
  _ = @import("./minim/par/test.zig"); // Parser
  _ = @import("./minim/gen/test.zig"); // Codegen
  _ = @import("./minim/cc/test.zig") ; // Binary Compilation
}

