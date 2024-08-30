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
const prnt = zstd.prnt;
// @deps minim
const M = @import("../minim.zig");

const generate = struct {
  const C   = @import("./gen/C.zig");
  const Zig = @import("./gen/zig.zig");
};

//______________________________________
/// @descr Converts the given minim {@arg ast} into the C programming language.
pub fn C (ast :*const M.Ast) !slate.C.Ast {
  if (ast.empty()) return slate.C.Ast.newEmpty();

  var result = slate.C.Ast.create(ast.A);
  for (ast.list.data.?.items) | N | {
    switch (N) {
    .Proc => try result.add(try generate.C.proc(N, ast.A)),
    }
  }
  return result;
}

//______________________________________
/// @descr Converts the given minim {@arg ast} into the Zig programming language.
pub fn Zig (ast :*const M.Ast) !slate.C.Ast {
  if (ast.empty()) return slate.C.Ast.newEmpty();

  var result = slate.C.Ast.create(ast.A);
  for (ast.list.data.?.items) | N | {
    switch (N) {
    .Proc => try result.add(try generate.C.proc(N, ast.A)),
    }
  }
  return result;
}
