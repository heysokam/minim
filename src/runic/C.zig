//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const zig = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps minim
const Ast = @import("../minim/ast.zig").Ast;

pub fn get2 (
    src  : cstr,
    in   : Ast.create.Options,
    A    : std.mem.Allocator,
  ) !Ast {
  _=src; _=in; _=A;
  return undefined;
}

