//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps zstd
const zstd = @import("../../lib//zstd.zig");
const Seq  = zstd.Seq;

pub const Pragma = enum {
  pure, Inline, Noreturn,

  pub const List = struct {
    data :?Seq(Pragma),
  };
};

