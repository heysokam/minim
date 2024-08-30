//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const stmt = @This();
// @deps std
const std = @import("std");
// @deps slate
const slate = @import("../../../lib/slate.zig");
// @deps minim
const Ast = @import("../../ast.zig");

/// @descr Converts a Minim return statement into a C return statement
pub fn retrn (S :*const Ast.Stmt) slate.C.Stmt {
  if (S.Retrn.body == null or S.Retrn.body.? == .Empty) return slate.C.Stmt.Return.new(slate.C.Expr.Empty);

  return slate.C.Stmt.Return.new(slate.C.Expr.Literal.Int.new(.{
    .val= switch (S.Retrn.body.?) {
      .Lit => switch (S.Retrn.body.?.Lit) {
        .Intgr => S.Retrn.body.?.Lit.Intgr.val,
        else => unreachable
        }, //:: .Lit
      .Empty => "",
      }})); //:: .val
}

