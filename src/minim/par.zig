//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Par = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const prnt = zstd.prnt;
const echo = zstd.echo;
const cstr = zstd.cstr;
// @deps minim
const M = @import("../minim.zig");

const Tk = @import("./rules.zig").Tk;
A      :std.mem.Allocator,
pos    :usize,
buf    :Tk.List,
res    :M.Ast,
parsed :zstd.str,

//__________________________
/// @descr Triggers an fatal error and prints the contents parsed so far
fn fail (P:*const Par, comptime msg :cstr, args :anytype) noreturn {
  echo(P.parsed.items);
  zstd.fail(msg, args);
}

//__________________________
/// @descr Returns the Token located in the current position of the buffer
fn tk (P:*Par) Tk { return P.buf.get(P.pos); }
//__________________________
/// @descr Moves the current position of the Parser by {@arg n} Tokens
fn move (P:*Par, n :i64) void {
  P.parsed.appendSlice(P.tk().val.items) catch {};
  P.pos += @intCast(n);
}
//__________________________
/// @descr Moves the Parser forwards by 1 only if the {@arg id} Token is found at the current position.
fn skip (P:*Par, id :Tk.Id) void {
  if (P.tk().id == id){ P.move(1); }
}


//__________________________
/// @descr Creates a new Parser object from the given {@arg T} Tokenizer contents.
pub fn create (T:*const M.Tok) Par {
  return Par {
    .A      = T.A,
    .pos    = 0,
    .buf    = T.res,
    .res    = M.Ast{
      .A    = T.A,
      .lang = .C,
      .list = M.Ast.Node.List.create(T.A),
      }, //:: .res
    .parsed = zstd.str.init(T.A),
  };
}
//__________________________
/// @descr Frees all resources owned by the Parser object.
pub fn destroy (P:*Par) void {
  P.buf.deinit(P.A);
  P.res.destroy();
}

//__________________________
/// Identifier Rules
//__________________________
/// :: Ident.Name = TODO
/// :: Ident.Type = Ident.Name
const ident = struct {
  //____________________________
  /// @descr Triggers an error if {@arg id} isn't the current Token in the {@arg P} Parser.
  pub fn expect (P:*Par, id :Tk.Id, kind :cstr) void {
    if (P.tk().id != id) P.fail("Unexpected Token for {s}. Expected '{s}', but found:  {d}:'{s}'",
      .{kind, @tagName(id), P.pos, @tagName(P.tk().id)});
  }
  //__________________________
  /// @descr
  ///  Creates an Ident.Name object from the current Token, and returns it.
  ///  Will fail if the current Token is not an Identifier
  fn name (P:*Par) M.Ast.Ident.Name {
    ident.expect(P, Tk.Id.b_ident, "Ident.name");
    return M.Ast.Ident.Name{.name= P.tk().val.items};
  }
  //__________________________
  /// @descr
  ///  Creates an Ident.Type object from the current Token, and returns it.
  ///  Will fail if the current Token is not an Identifier
  fn typ (P:*Par) M.Ast.Ident.Type {
    ident.expect(P, Tk.Id.b_ident, "Ident.Type");
    return M.Ast.Ident.Type{.any= M.Ast.Ident.Type.Any{.name= P.tk().val.items}}; // TODO: Static Typechecking
  }
};

//__________________________
/// Statement Rules
/// :: kw_return   = 'return'
/// :: Stmt.Return = kw_return Expr
const stmt = struct {
  //____________________________
  /// @descr Triggers an error if {@arg id} isn't the current Token in the {@arg P} Parser.
  fn expectAny (P:*Par, ids :[]const Tk.Id) void {
    for (ids) | id | {
      if (P.tk().id == id) { return; }
    }
    P.fail("Unexpected Token for Statement. Expected '{any}', but found:  {d}:'{s}'", .{ids, P.pos, @tagName(P.tk().id)});
  }

  fn expect (P:*Par, id :Tk.Id) void {
    if (P.tk().id == id) { return; }
    P.fail("Unexpected Token for Statement. Expected '{s}', but found:  {d}:'{s}'", .{@tagName(id), P.pos, @tagName(P.tk().id)});
  }

  fn Return (P:*Par) M.Ast.Stmt {
    stmt.expect(P, Tk.Id.kw_return);
    P.move(1);
    P.skip(Tk.Id.wht_space);
    stmt.expectAny(P, &.{Tk.Id.b_number, Tk.Id.wht_newline});
    const ret = switch (P.tk().id) {
      .b_number    => M.Ast.Expr.Literal.Int.new(.{.val= P.tk().val.items,}),
      .wht_newline => M.Ast.Expr.Empty,
      else => |id| P.fail("Unexpected Token for Return Statement value. Expected '{s}', but found:  {d}:'{s}'", .{@tagName(id), P.pos, @tagName(P.tk().id)}),
    };
    if (P.tk().id == .b_number) P.move(1);
    stmt.expect(P, Tk.Id.wht_newline);
    return M.Ast.Stmt.Return.new(ret);
  }
};

//__________________________
/// Procedure Rules
/// :: Proc
/// ::   = s Ident.Name s Proc.Public? s?
/// ::     paren_L ind? (Proc.Args | kw_void) ind? paren_R s? Proc.Ret Proc.Body?
/// :: Proc.Public = star
/// :: Proc.Args   = Ident.Name s? colon s? Ident.Type
/// :: Proc.Ret    = Ident.Type
/// :: Proc.Body   = eq ind Stmt.List
/// :........
/// :..TODO
/// :. Pragma for Proc   (aka Proc.Attr)
/// :. Pragma for Proc.Args
/// :. Pragma for Proc.Ret
/// :........
const proc = struct {
  //____________________________
  /// @descr Triggers an error if {@arg id} isn't the current Token in the {@arg P} Parser.
  fn expect (P:*Par, id :Tk.Id) void {
    if (P.tk().id != id) {
      P.fail("Unexpected Token for Proc. Expected '{s}', but found:  {d}:'{s}'", .{@tagName(id), P.pos, @tagName(P.tk().id)});
    }
  }

  //__________________________
  /// @descr Returns whether or not the current Token is a public marker Token.
  fn public (P:*Par) bool {
    // TODO: Make these two `star` tokens be one single Token
    // FIX: Should expect a star, not an op_star/sp_star
    return P.tk().id == Tk.Id.sp_star or P.tk().id == Tk.Id.op_star;
  }

  const args = struct {
    //__________________________
    /// @descr Returns whether the current argument of the current proc is mutable or not
    /// @note Skips/Moves the parser accordingly
    fn mutable (P:*Par) bool {
      P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST
      if (P.tk().id == .kw_var) { P.move(1); return true; }
      return false;
    }
    //__________________________
    /// @descr Returns the current argument of the current proc
    fn current (P:*Par) !M.Ast.Proc.Arg {
      // Arg name
      P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST
      // FIX: Multi-name with single-type (comma separated)
      const name = ident.name(P);
      P.move(1);
      P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST
      // Arg type
      proc.expect(P, Tk.Id.sp_colon);
      P.move(1);
      P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST
      const mut = proc.args.mutable(P);
      P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST
      const typ = ident.typ(P);
      P.move(1);
      P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST
      return M.Ast.Proc.Arg{.type= typ, .name= name, .mut= mut};
    }

    //__________________________
    /// @descr Returns the argument list of the current proc
    fn list (P:*Par) !?M.Ast.Proc.Arg.List {
      proc.expect(P, Tk.Id.sp_paren_L);
      P.move(1);
      P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST
      if (P.tk().id == Tk.Id.sp_paren_R) { P.move(1); return null; } // null means the proc has no arguments
      // ... parse args
      var result = M.Ast.Proc.Arg.List.create(P.A);
      while (true) {
        try result.add(try proc.args.current(P));
        // Arg separator or end
        if (P.tk().id == Tk.Id.sp_semicolon) { P.move(1); continue; }
        break;
      }
      proc.expect(P, Tk.Id.sp_paren_R);
      P.move(1);
      return result;
    }
  };

  //__________________________
  /// @descr Creates the Body of the current `proc`
  /// :: Proc.Body = eq ind Stmt.List
  fn body (P:*Par) !M.Ast.Proc.Body {
    proc.expect(P, Tk.Id.sp_eq);
    P.move(1);
    proc.expect(P, Tk.Id.wht_space);
    P.move(1);
    var result = M.Ast.Proc.Body.init(P.A);
    switch (P.tk().id) {
      Tk.Id.kw_return => try result.add(stmt.Return(P)),
      else => |token| P.fail("Unknown First Token for Proc.Body Statement '{s}'", .{@tagName(token)})
    }
    return result;
  }

  //__________________________
  /// @descr
  ///  Creates a topLevel `proc` or `func` statement and adds the resulting Node into the {@arg P.res} AST result.
  ///  Applies syntax error checking along the process.
  pub fn parse (P:*Par) !void {
    var result  = M.Ast.Proc.newEmpty();
    // pure/proc case
    switch (P.tk().id) {
      .kw_func => result.pure = true,
      .kw_proc => result.pure = false,
      else => |token| P.fail("Unknown First Token for Proc '{s}'", .{@tagName(token)})
      } P.move(1);
    P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST
    // name = Ident
    proc.expect(P, Tk.Id.b_ident);
    result.name = ident.name(P);
    P.move(1);
    P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST

    // public/private case
    result.public = proc.public(P);
    // FIX: Make these two `star` tokens be one single Token
    P.skip(Tk.Id.sp_star);
    P.skip(Tk.Id.op_star);
    P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST
    // Args
    result.args = try proc.args.list(P);

    // Return Type
    P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST
    proc.expect(P, Tk.Id.sp_colon);
    P.move(1);
    proc.expect(P, Tk.Id.b_ident);
    // ... parse return type here
    result.retT = ident.typ(P);
    P.move(1);
    P.skip(Tk.Id.wht_space); // TODO: Pass formatting into the AST

    // FIX: Return Body
    proc.expect(P, Tk.Id.sp_eq);
    result.body = try proc.body(P);

    // pub fn new(args :struct {
    //   name    :cstr,
    //   public  :bool= false,
    //   args    :?Proc.Arg.List= null,
    //   retT    :cstr,
    //   body    :?Proc.Body= null,
    //   pragmas :?Pragma.List= null,
    // }) Proc {
    try P.res.add(M.Ast.Node{.Proc=result});
  }
};


//__________________________
/// Global Rules
/// :: nl   = '\n'+ | '\r'+
/// :: s    = ' '+
/// :: ind  = (s | nl)
/// :: tab  = '\t'+
/// :: star = '*'
///
//__________________________
/// Top-Level Rules
/// :: kw_proc = 'proc' | 'pr'
/// :: kw_func = 'func' | 'fn'
/// :: topLevel
/// ::   = whenStmt
/// ::   | (kw_proc | kw_func) procedure
/// ::   | 'type' section(typeDef)
/// ::   | 'const' section(constant)
/// ::   | ('let' | 'var' | 'using') section(variable)
/// :........
/// :..TODO
/// :.   | staticStmt
/// :.   | asmStmt
/// :.   | 'iterator' routine
/// :.   | 'template' routine
/// :........
//__________________________
/// @descr Parser Entry Point
pub fn process (P:*Par) !void {
  while (P.pos < P.buf.len) : ( P.move(1) ) {
    switch (P.tk().id) {
    .kw_proc, .kw_func => try proc.parse(P),
    else => |token| P.fail("Unknown Top-Level Token {d}:'{s}'", .{P.pos+1, @tagName(token)})
    }
  }
}

pub fn report (P:*Par) void {
  std.debug.print("--- minim.Parser ---\n", .{});
  if (P.res.list.data != null) {
    for (P.res.list.data.?.items, 0..) | id, val | {
      std.debug.print("{s} : {any}\n", .{@tagName(id), val});
    }
  }
  std.debug.print("--------------------\n", .{});
}

