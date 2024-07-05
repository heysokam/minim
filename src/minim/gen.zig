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
const Str  = zstd.Str;
// @deps minim
const M = @import("../minim.zig");

fn func(ast:*const M.Ast, N :M.Ast.Node) !slate.C.Ast.Node {
  const result = "42"; // FIX: Should not be hardcoded

  var body = slate.C.Func.Body.init(ast.A);
  try body.append(slate.C.Stmt.Return.new(slate.C.Expr.Literal.Int.new(.{ .val= result })));
  return slate.C.Ast.Node{.Func= slate.C.Func{
    .retT= slate.C.Ident.Type{ .name= N.Proc.retT.?.any.name, .type= .i32 },
    .name= slate.C.Ident.Name{ .name= N.Proc.name.name },
    .body= body,
    }}; // << Func{ ... }
}

//______________________________________
/// @descr Converts the given minim {@arg ast} into the C programming language.
pub fn C(ast:*const M.Ast) !slate.C.Ast {
  if (ast.empty()) return slate.C.Ast.newEmpty();

  var result = slate.C.Ast.create(ast.A);
  for (ast.list.data.?.items) | N | {
    switch (N) {
    .Proc => try result.append(try Gen.func(ast, N)),
    }
  }
  return result;
}

