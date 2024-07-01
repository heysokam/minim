//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const Seq  = zstd.Seq;
// @deps minim.ast
const Func = @import("./func.zig");


/// @descr Describes a Top-Level Node of the language.
pub const Node = union(enum) {
  Func :Func,
  pub const List = struct {
    data :?Seq(Node),
  };
};

