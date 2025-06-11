//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Par = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps slate
const slate  = @import("../lib/slate.zig");
const source = slate.source;
const Depth  = slate.Depth;
// @deps minim
const M  = @import("../minim.zig");
const Tk = M.Tok.Tk;

A       :std.mem.Allocator,
/// @descr State tracking the current position of the parser in the buffer
pos     :Par.Pos,
src     :source.Code,
buf     :Tk.List,
res     :M.Ast,
/// @descr State tracking the code that has already been parsed. Mostly for debugging.
parsed  :zstd.string,
/// @descr State tracking the current Indentation/Scope depth level
depth   :Depth=  Depth.default(),

pub const Pos = usize;

//______________________________________
// @section Create/Destroy
//____________________________
/// @descr Creates a new Parser object from the given {@arg T} Tokenizer contents.
pub fn create (T:*const M.Tok, lang :M.Lang) !Par {
  return Par{
    .A      = T.A,
    .pos    = 0,
    .src    = T.src,
    .buf    = try T.res.clone(T.A),
    .res    = try M.Ast.create.empty(lang, T.src, T.A),
    .parsed = zstd.string.create_empty(T.A),
    };
} //:: M.Par.create
//__________________
/// @descr Frees all resources owned by the Parser object.
pub fn destroy (P:*Par) void {
  P.buf.deinit(P.A);
  P.res.destroy();
  P.parsed.destroy();
} //:: M.Par.destroy


//______________________________________
// @section General Tools
//____________________________
pub const report = @import("./par/cli.zig").report;
pub const prnt   = zstd.prnt;
/// @descr Triggers a fatal error and prints the contents parsed so far
pub fn fail (P:*const Par, comptime msg :cstr, args :anytype) noreturn {
  zstd.echo(P.parsed.data());
  zstd.fail(msg, args);
} //:: M.Par.fail


//______________________________________
// @section State/Data Management
pub const data    = @import("./par/data.zig");
pub const tk      = data.tk;
pub const next_at = data.next_at;
pub const move    = data.move;
pub const skip    = data.skip;
//______________________________________
// @section State/Data Checks
pub const check     = @import("./par/check.zig");
pub const expect    = check.expect;
pub const expectAny = check.expectAny;
pub const last      = check.last;
pub const end       = check.end;


//__________________________
/// Rules: Indentation
/// FIX: ind{=} ind{>}
/// :........
pub const indentation = @import("./par/indentation.zig");
pub const ind         = indentation.parse;
pub const expectInd   = indentation.expect;


// //__________________________
// /// Rules: Statement
// /// :: kw_return   = 'return'
// /// :: Stmt.Return = kw_return Expr
// /// :........
pub const stmt = @import("./par/statement.zig");


// //__________________________
// /// Rules: Identifier
// /// :: kw_ptr     = 'ptrconst '
// /// :: kw_array   = 'array'
// /// :: Ident      = TODO
// /// :: Data.Type  = ( kw_ptr )? Ident
// /// :........
// pub const ident = @import("./par/ident.zig");


// //__________________________
// /// Rules: Pragma
// /// :: prag_start   = '{.'
// /// :: prag_end     = '.}'
// /// :: Pragma.Value = colon ind? (Ident)
// /// :: Pragma       = prag_start ind? Ident (ind? Pragma.Value)? ind? prag_end
// /// :........
// pub const pragma = @import("./par/pragma.zig");


//__________________________
/// Rules: Procedure
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


//____________________________
/// Rules: Global
/// :: nl   = '\n'+ | '\r'+
/// :: s    = ' '+
/// :: ind  = (s | nl)
/// :: tab  = '\t'+
/// :: star = '*'
/// :........
///
//____________________________
/// Rules: Top-Level
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
///
const toplevel = struct {
  /// @descr Creates a topLevel `proc`/`func` statement and adds the resulting Node into the {@arg P.res} AST result.
  fn proc (P:*Par) !void {
    _= try P.res.add_node(M.Ast.Node{.Proc= try @import("./par/proc.zig").parse(P)}); // TODO: Modules will need this Node.Store.Pos
  }

  fn variable (P:*Par) !void {
    _= try P.res.add_node(M.Ast.Node{.Var= try @import("./par/statement.zig").variable(P)}); // TODO: Modules will need this Node.Store.Pos
  }
};
//____________________________
/// @descr Parser Entry Point
pub fn process (P:*Par) !void {
  while (P.pos < P.buf.len) : ( P.move(1) ) {
    switch (P.tk().id) {
    .kw_func,
    .kw_proc     => try toplevel.proc(P),
    .kw_let,
    .kw_var,
    .kw_const    => try toplevel.variable(P),
    .wht_space,
    .wht_newline => {}, // TODO: Pass formatting into the AST
    .b_EOF       => break,  // 0x0  (the null character 0 is treated as an EOF marker)
    else => |token| P.fail("Unknown Top-Level Token {d}:'{s}'", .{P.pos+1, @tagName(token)})
    }
    if (P.pos >= P.buf.len) break;
  }
  // FIX: Interpret Lang based on the result
} //:: M.Par.process

