//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps zstd
const zstd = @import("../../lib//zstd.zig");

pub const Pragma = enum {
  pure, Inline, Noreturn,

  pub const List = struct {
    const Data = zstd.seq(Pragma);
    data :?Data,
  };
};

