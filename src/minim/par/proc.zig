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
    P.ind();
    if (P.tk().id == .kw_var) { P.move(1); return true; }
    return false;
  }
  //__________________________
  /// @descr Returns the current argument of the current proc
  fn current (P:*Par) !Ast.Proc.Arg {
    // Arg name
    P.ind();
    // FIX: Multi-name with single-type (comma separated)
    const name = ident.name(P);
    P.move(1);
    P.ind();
    // Arg type
    proc.expect(P, Tk.Id.sp_colon);
    P.move(1);
    P.ind();
    const mut = proc.args.mutable(P);
    P.ind();
    const typ = try ident.typ.parse(P);
    P.ind();
    return Ast.Proc.Arg{.id= name, .type= typ, .write= mut};
  }


  //__________________________
  /// @descr Returns the argument list of the current proc
  fn list (P:*Par) !?Ast.Proc.Arg.List {
    proc.expect(P, Tk.Id.sp_paren_L);
    P.move(1);
    P.ind();
    if (P.tk().id == Tk.Id.sp_paren_R) { P.move(1); return null; } // null means the proc has no arguments
    // ... parse args
    var result = Ast.Proc.Arg.List.create(P.A);
    while (true) {
      P.ind();
      if (P.tk().id == Tk.Id.sp_paren_R) { break; }
      try result.add(try proc.args.current(P));
      // Arg separator or end
      if (P.tk().id == Tk.Id.sp_semicolon) { P.move(1); continue; }
      break;
    }
    proc.expect(P, Tk.Id.sp_paren_R);
    P.move(1);
    return result;
  } //:: Par.proc.args.list
}; //:: Par.proc.args


//______________________________________
// @section Parser.Proc: Body Statements
//__________________________
/// @descr Creates the Body of the current `proc`
/// :: Proc.Body = eq ind Stmt.List
fn body (P :*Par) !Ast.Proc.Body {
  proc.expect(P, Tk.Id.sp_eq);
  P.move(1);
  P.ind();
  var result = Ast.Proc.Body.create(P.A);
  switch (P.tk().id) {
    Tk.Id.kw_return => try result.add(try stmt.Return(P)),
    else => |token| P.fail("Unknown First Token for Proc.Body Statement '{s}'", .{@tagName(token)})
  }
  return result;
}


//______________________________________
// @section Parser.Proc: Entry Point
//__________________________
/// @descr
///  Creates a topLevel `proc` or `func` statement and adds the resulting Node into the {@arg P.res} AST result.
///  Applies syntax error checking along the process.
pub fn parse (P :*Par) !void {
  var result = Ast.Proc.create_empty();
  // pure/proc case
  switch (P.tk().id) {
    .kw_func => result.pure = true,
    .kw_proc => result.pure = false,
    else => |token| P.fail("Unknown First Token for Proc '{s}'", .{@tagName(token)})
    } P.move(1);
  P.ind();
  // name = Ident
  proc.expect(P, Tk.Id.b_ident);
  result.name = ident.name(P);
  P.move(1);
  P.ind();

  // public/private case
  result.public = proc.public(P);
  // FIX: Make these two `star` tokens a single Token
  P.skip(Tk.Id.sp_star);
  P.skip(Tk.Id.op_star);
  P.ind();

  // Args
  result.args = try proc.args.list(P);
  P.ind();

  // Pragma  (new location after args)
  result.pragmas = try pragma.parse(P);
  P.ind();

  // Return Type
  proc.expect(P, Tk.Id.sp_colon);
  P.move(1);
  P.ind();
  result.retT = try ident.typ.parse(P);
  P.ind();

  // Return Body
  proc.expect(P, Tk.Id.sp_eq);
  result.body = try proc.body(P);

  // Add the resulting Proc node to the AST
  try P.res.add(Ast.Node{.Proc= result});
} //:: Par.proc.parse

