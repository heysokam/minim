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
const ident  = @import("./ident.zig");


//____________________________
/// @descr Triggers an error if any of the {@arg ids} are not the current Token in the {@arg P} Parser.
pub fn expectAny (P:*Par, ids :[]const Tk.Id) void { P.expectAny(ids, "Statement"); }
/// @descr Triggers an error if {@arg id} isn't the current Token in the {@arg P} Parser.
pub fn expect (P:*Par, id :Tk.Id) void { P.expect(id, "Statement"); }

pub fn Return (P:*Par) !Ast.Stmt {
  stmt.expect(P, Tk.Id.kw_return);
  P.move(1);
  P.ind(.equal());
  stmt.expectAny(P, &.{Tk.Id.b_number, Tk.Id.wht_newline, Tk.Id.sp_semicolon});
  const ret = switch (P.tk().id) {
    .b_number     => Ast.Expr.Literal.Int.create(P.tk().loc, P.scope.current()),
    .wht_newline,
    .sp_semicolon => Ast.Expr.Empty,
    else => |id| P.fail("Unexpected Token for Return Statement value. Expected '{s}', but found:  {d}:'{s}'", .{@tagName(id), P.pos, @tagName(P.tk().id)}),
  };
  if (P.tk().id == Tk.Id.b_number) P.move(1);
  return Ast.Stmt.Return.create(ret, P.scope.current());
}


pub fn variable (P:*Par) !Ast.Stmt {
  stmt.expectAny(P, &.{Tk.Id.kw_const, Tk.Id.kw_let, Tk.Id.kw_var});
  const mut = switch (P.tk().id) {
    .kw_var            => true,
    .kw_const, .kw_let => false,
    else => unreachable,
  };
  const runtime = switch (P.tk().id) {
    .kw_var, .kw_let => true,
    .kw_const,       => false,
    else => unreachable,
  };
  P.move(1);
  P.ind(.any());

  var data = Ast.Stmt.Variable.Data{
    .id      = ident.name(P),
    .write   = mut,
    .runtime = runtime,
    }; //:: result
  P.move(1);
  P.ind(.any());
  // Public/Private
  stmt.expectAny(P, &.{Tk.Id.sp_star, Tk.Id.sp_colon});
  const public = if (P.tk().id == Tk.Id.sp_star) blk: {
    P.move(1);
    P.ind(.any());
    break :blk true;
  } else false;
  // Variable type
  stmt.expect(P, Tk.Id.sp_colon);
  P.move(1);
  P.ind(.any());
  data.type = try ident.type.parse(P, mut);
  P.ind(.any());

  stmt.expectAny(P, &.{Tk.Id.sp_eq, Tk.Id.sp_semicolon});
  // Start without a value
  data.value = Ast.Expr.Empty;
  // Assignment case
  if (P.tk().id == Tk.Id.sp_eq) {
    P.move(1);
    P.ind(.any());

    data.value = switch (P.tk().id) {
      .b_number => Ast.Expr.Literal.Int.create(P.tk().loc, P.scope.current()),
      else => |id| P.fail("Unexpected Token for Assignment Statement value. Expected '{s}', but found:  {d}:'{s}'", .{@tagName(id), P.pos, @tagName(P.tk().id)}),
    };
    if (P.tk().id == Tk.Id.b_number) P.move(1);
  // Declaration case
  } else {
    P.move(1);
    P.ind(.any());
  }

  return Ast.Stmt.Variable.create(data, public);
}

