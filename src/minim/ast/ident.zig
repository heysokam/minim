//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std  = @import("std");
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps minim
const M     = @import("../rules.zig");
const Keyw  = M.Keyw;
const Value = M.Value;

pub const Ident = union(enum) {
  Id  :Ident.Name,
  Kw  :Ident.Keyword,
  Ty  :Ident.Type,

  pub const Name = struct {
    name :cstr,
  };

  pub const Type = Value.Type;

  pub const Keyword = struct {
    id :M.Tk.Id,
  };
};

