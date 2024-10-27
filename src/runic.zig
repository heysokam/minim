//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const runic = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("./lib/zstd.zig");
const cstr = zstd.cstr;
// @deps minim
const Ast = @import("./minim/ast.zig").Ast;
pub const Lang = @import("./minim/rules.zig").Lang;
// @deps runic
pub const C   = @import("./runic/C.zig");
pub const zig = @import("./runic/zig.zig");


pub fn get2 (
    src  : cstr,
    lang : Lang,
    in   : Ast.create.Options,
    A    : std.mem.Allocator,
  ) !Ast {
  switch (lang) {
    .Minim => return Ast.get2(src, in, A),
    .Zig   => return runic.zig.get2(src, in, A),
    .C     => return runic.C  .get2(src, in, A),
  }
}
pub fn get (src :cstr, lang :Lang, A :std.mem.Allocator) !void { try runic.get2(src, lang, .{}, A); }

