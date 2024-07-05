//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Ast = @This();
// @deps std
const std = @import("std");
// @deps minim
pub const Lang  = @import("./rules.zig").Lang;
pub const Node  = @import("./ast/node.zig").Node;
pub const Proc  = @import("./ast/proc.zig");
pub const Ident = @import("./ast/ident.zig").Ident;
pub const Stmt  = @import("./ast/statement.zig").Stmt;
pub const Expr  = @import("./ast/expression.zig").Expr;

/// @descr The Allocator used by the AST object
A     :std.mem.Allocator,
/// @descr Describes which output language the AST is targeting
lang  :Lang,
/// @descr Contains the list of Top-Level nodes of the AST
list  :Node.List,

/// @descr Returns true if the AST has no nodes in its {@link Ast.list} field
pub fn empty(ast :*const Ast) bool { return ast.list.empty(); }
/// @descr Adds the {@arg val} Node to the Node.List of the {@arg ast}.
pub fn append(ast :*Ast, val :Node) !void { try ast.list.append(val); }


//__________________________
/// @descr Frees all resources owned by the Parser object.
pub fn destroy(ast:*Ast) void {
  ast.list.destroy();
}

