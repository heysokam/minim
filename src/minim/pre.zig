//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Core logic for the Minim's compiler preprocessor
//_________________________________________________________________|
pub const Pre = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");

/// TODO: Implement the preprocessor logic
pub fn process (code :*zstd.string) !zstd.string {
  return try code.clone();
}

