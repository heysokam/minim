//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Parser Process: Procedures & Functions
//_______________________________________________________|
const proc = @This();
// @deps minim
const Tok    = @import("../tok.zig");
const Tk     = Tok.Tk;
const Par    = @import("../par.zig");
const Ast    = @import("../ast.zig");
const ident  = @import("./ident.zig");
const stmt   = @import("./statement.zig");
const pragma = @import("./pragma.zig");


//______________________________________
// @section Checks
//____________________________
/// @descr Triggers an error if any of the {@arg ids} are not the current Token in the {@arg P} Parser.
fn expectAny (P:*Par, ids :[]const Tk.Id) void { P.expectAny(ids, "Proc"); }
/// @descr Triggers an error if {@arg id} isn't the current Token in the {@arg P} Parser.
fn expect (P:*Par, id :Tk.Id) void { P.expect(id, "Proc"); }


//______________________________________
// @section Properties
//__________________________
/// @descr Returns whether or not the current Token is a public marker Token.
fn public (P:*Par) bool {
  // TODO: Make these two `star` tokens be one single Token
  // FIX: Should expect a star, not an op_star/sp_star
  return P.tk().id == Tk.Id.sp_star or P.tk().id == Tk.Id.op_star;
}


//______________________________________
// @section Arguments
//__________________________
const args = struct {
  //__________________________
  /// @descr Returns whether the current argument of the current proc is mutable or not
  /// @note Skips/Moves the parser accordingly
  fn mutable (P :*Par) bool {
    P.ind(.any());
    if (P.tk().id == .kw_var or P.tk().id == .kw_mut) { P.move(1); return true; }
    return false;
  }
  //__________________________
  /// @descr Returns the current argument of the current proc
  fn current (P:*Par) !Ast.Proc.Arg {
    // Arg name
    P.ind(.any());
    // FIX: Multi-name with single-type (comma separated)
    const name = ident.name(P);
    P.move(1);
    P.ind(.any());
    // Arg type
    proc.expect(P, Tk.Id.sp_colon);
    P.move(1);
    P.ind(.any());
    const mut = proc.args.mutable(P);
    P.ind(.any());
    const typ = try ident.type.parse(P, mut);
    P.ind(.any());
    return Ast.Proc.Arg{.id= name, .type= typ, .write= mut};
  }


  //__________________________
  /// @descr Returns the argument list of the current proc
  fn list (P:*Par) !Ast.Proc.ArgStore.Pos {
    proc.expect(P, Tk.Id.sp_paren_L);
    P.move(1);
    P.ind(.any());
    if (P.tk().id == Tk.Id.sp_paren_R) { P.move(1); return .None; } // .None means the proc has no arguments
    // ... parse args
    var result = try Ast.Proc.Args.create(P.A);
    while (true) {
      P.ind(.any());
      if (P.tk().id == Tk.Id.sp_paren_R) { break; }
      try result.add(try proc.args.current(P));
      // Arg separator or end
      if (P.tk().id == Tk.Id.sp_semicolon) { P.move(1); continue; }
      break;
    }
    proc.expect(P, Tk.Id.sp_paren_R);
    P.move(1);
    return P.res.add_args(result);
  } //:: Par.proc.args.list
}; //:: Par.proc.args


//______________________________________
// @section Parser.Proc: Body Statements
//__________________________
/// @descr Creates the Body of the current `proc`
/// :: Proc.Body = eq ind Stmt.List
fn body (P :*Par) !Ast.Proc.BodyStore.Pos {
  proc.expect(P, Tk.Id.sp_eq);
  P.move(1);
  P.ind(.increase());
  var result = try Ast.Proc.Body.create(P.A);
  while (true) { switch (P.tk().id) {
    .kw_return                  => try result.add(try stmt.Return(P)),
    .kw_let, .kw_var, .kw_const => try result.add(try stmt.variable(P)),
    else => |token| P.fail("Unknown First Token for Proc.Body Statement '{s}'", .{@tagName(token)})
  } break; }
  return P.res.add_stmts(result);
}


//______________________________________
// @section Parser.Proc: Entry Point
//__________________________
/// @descr
///  Creates a topLevel `proc` or `func` statement and returns resulting Node.
///  Applies syntax error checking along the process.
pub fn parse (P :*Par) !Ast.Proc {
  var result = Ast.Proc.create_empty();
  // pure/proc case
  switch (P.tk().id) {
    .kw_func => result.pure = true,
    .kw_proc => result.pure = false,
    else => |token| P.fail("Unknown First Token for Proc '{s}'", .{@tagName(token)})
    } P.move(1);
  P.ind(.any());
  // name = Ident
  proc.expect(P, Tk.Id.b_ident);
  result.name = ident.name(P);
  P.move(1);
  P.ind(.any());

  // public/private case
  result.public = proc.public(P);
  P.skip(Tk.Id.sp_star);
  P.ind(.any());

  // Args
  result.args = try proc.args.list(P);
  P.ind(.any());

  // Pragma  (new location after args)
  result.pragmas = try pragma.parse(P);
  P.ind(.any());

  // Return Type
  proc.expect(P, Tk.Id.sp_colon);
  P.move(1);
  P.ind(.any());
  const hasError = // FIX: Better hasError detection
    P.next_at(1).id == .sp_excl or (
    P.next_at(2).id == .sp_excl and P.next_at(1).id == .wht_space) or (
    P.next_at(2).id == .sp_excl and P.next_at(1).id == .b_ident);
  if (hasError) {
    result.err = ident.name(P);
    P.move(1);
    P.ind(.any());
    proc.expect(P, Tk.Id.sp_excl);
    P.move(1);
    P.ind(.any());
  }
  result.ret.write = if (P.tk().id == .kw_mut) blk: {
    P.move(1);
    P.ind(.any());
    break :blk true;
  } else false;
  result.ret.type = try ident.type.parse(P, true);
  P.ind(.any());

  // Return Body
  const hasBody = P.tk().id == Tk.Id.sp_eq;
  if (hasBody) {
    proc.expect(P, Tk.Id.sp_eq);
    result.body = try proc.body(P);
  } else {
    result.body = .None;
    P.ind(.any());
  }

  return result;
} //:: Par.proc.parse

