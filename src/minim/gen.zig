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
// @deps minim
const M = @import("../minim.zig");


/// @descr Converts the given minim {@arg ast} into the C programming language.
pub fn C(ast:*const Ast) slate.C.Ast {
  _ = ast;
  return slate.C.Ast{.list = slate.C.Ast.Node.List{}};
}

