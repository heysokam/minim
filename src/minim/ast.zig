//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Ast = @This();
const std = @import("std");
// @deps minim
pub const Lang = @import("./rules.zig").Lang;
pub const Node = @import("./ast/node.zig").Node;

/// @descr Describes which output language the AST is targeting
lang  :Lang,
/// @descr Contains the list of Top-Level nodes of the AST
list  :Node.List,

/// @descr Returns true if the AST has no nodes in its {@link Ast.list} field
pub fn empty(ast :*const Ast) bool { return ast.list.empty(); }


//__________________________
/// @descr Frees all resources owned by the Parser object.
pub fn destroy(A:*Ast) void {
  _=A;
  // A.buf.deinit(A.A);
  // A.res.destroy(A.A);
}

