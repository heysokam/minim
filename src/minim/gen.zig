//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Gen = @This();
// @deps std
const std = @import("std");
// @deps *Slate
const slate = @import("../lib/slate.zig");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const Str  = zstd.Str;
const Ast  = @import("./ast.zig");


/// @descr Converts the given {@arg ast} into the C programming language.
pub fn C(ast :Ast, A :std.mem.Allocator) Str {
  _ = ast;
  _ = A;
  return;
}

