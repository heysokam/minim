//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Zig = @This();
// @deps std
const std = @import("std");
// @deps minim
const Ast = @import("../ast.zig");
// @deps slate
const slate = @import("../../lib/slate.zig");


pub fn func (N :Ast.Node, A :std.mem.Allocator) !slate.C.Ast.Node {
  const result = "42"; // FIX: Should not be hardcoded

  var body = slate.C.Func.Body.create(A);
  try body.add(slate.C.Stmt.Return.new(slate.C.Expr.Literal.Int.new(.{ .val= result })));
  return slate.C.Ast.Node{.Func= slate.C.Func{
    .retT= slate.C.Ident.Type{ .name= N.Proc.retT.?.any.name, .type= .i32 },
    .name= slate.C.Ident.Name{ .name= N.Proc.name.name },
    .body= body,
    }}; // << Func{ ... }
}

