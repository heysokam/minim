pub const Ident = @This();
// @deps std
const std  = @import("std");
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps minim
const M     = @import("../rules.zig");
const Keyw  = M.Keyw;
const Value = M.Value;

Id  :Ident.Name,
Kw  :Ident.Keyword,
Ty  :Ident.Type,

const Templ = "{s}";

pub const Name = struct {
  name :cstr,
};

pub const Type = Value.Type;

pub const Keyword = struct {
  id :Keyw,
};

