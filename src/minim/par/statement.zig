//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const stmt      = @This();
const statement = @This();
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
// @deps minim
const Tok    = @import("../tok.zig").Tok;
const Tk     = Tok.Tk;
const Par    = @import("../par.zig").Par;
const Ast    = @import("../ast.zig").Ast;


//____________________________
/// @descr Triggers an error if any of the {@arg ids} are not the current Token in the {@arg P} Parser.
pub fn expectAny (P:*Par, ids :[]const Tk.Id) void { P.expectAny(ids, "Statement"); }
/// @descr Triggers an error if {@arg id} isn't the current Token in the {@arg P} Parser.
pub fn expect (P:*Par, id :Tk.Id) void { P.expect(id, "Statement"); }

pub fn Return (P:*Par) Ast.Stmt {
  stmt.expect(P, Tk.Id.kw_return);
  P.move(1);
  P.ind();
  stmt.expectAny(P, &.{Tk.Id.b_number, Tk.Id.wht_newline});
  const ret = switch (P.tk().id) {
    .b_number    => Ast.Expr.Literal.Int.new(.{.val= P.tk().val.items,}),
    .wht_newline => Ast.Expr.Empty,
    else => |id| P.fail("Unexpected Token for Return Statement value. Expected '{s}', but found:  {d}:'{s}'", .{@tagName(id), P.pos, @tagName(P.tk().id)}),
  };
  if (P.tk().id == Tk.Id.b_number) P.move(1);
  return Ast.Stmt.Return.new(ret);
}

