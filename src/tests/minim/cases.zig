//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Preset Cases
//_____________________________|
pub const case = @This();
// @deps std
const std = @import("std");
// @deps minim
const t     = @import("./base.zig");
const M     = @import("../../minim.zig");
const slate = @import("slate");
const zstd  = @import("zstd");
const minim = struct {
  const Tk = M.Tok.Tk;
};


pub const Nim = struct {
  const Kind = enum { all, variable, proc, };
  fn random (kind :case.Nim.Kind) !zstd.cstr {
    // Configuration for nimgen
    const seed = try std.fmt.allocPrint(t.A, "{x}", .{std.testing.random_seed});
    defer t.A.free(seed);
    const file = try std.fmt.allocPrint(t.A, "{s}.nim", .{@tagName(kind)});
    defer t.A.free(file);
    const result = try std.fs.path.join(t.A, &.{".","bin",".cache","tests", seed, file});
    // Create the nimgen Command  (assumes nimgen exists)
    var cmd = zstd.shell.Cmd.create(t.A);
    defer cmd.destroy();
    try cmd.add("./bin/nimgen");
    try cmd.add(@tagName(kind));
    try cmd.add(result);
    try cmd.add(seed);
    // Run the command and return the path of the resulting file
    try cmd.exec();
    try t.eq(cmd.result.?.code.?, 0);
    return result;
  }

  pub fn generate (kind : case.Nim.Kind) !slate.source.Code {
    const file = try Nim.random(kind);
    defer t.A.free(file);
    const src = try zstd.files.read(file, t.A, .{});
    defer t.A.free(src);
    var result = zstd.string.create_empty(t.A);
    try result.add(src);
    return try result.zstring();
  } //:: tests.case.Random.generate
}; //:: tests.case.Random


pub const Hello42 = struct {
  pub const src :slate.source.Code= "proc main *() :int= return 42\n";
  pub const res = struct {
    pub const lex = &[_]slate.Lx{
      slate.Lx{.id= .ident, .  loc= slate.source.Loc{.start=  0, .end=  3}},  // 00: `proc`
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start=  4, .end=  4}},  // 01: ` `

      slate.Lx{.id= .ident, .  loc= slate.source.Loc{.start=  5, .end=  8}},  // 02: `main`
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start=  9, .end=  9}},  // 03: ` `

      slate.Lx{.id= .star,    .loc= slate.source.Loc{.start= 10, .end= 10}},  // 04: `*`
      slate.Lx{.id= .paren_L, .loc= slate.source.Loc{.start= 11, .end= 11}},  // 05: `(`
      slate.Lx{.id= .paren_R, .loc= slate.source.Loc{.start= 12, .end= 12}},  // 06: `)`
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 13, .end= 13}},  // 07: ` `

      slate.Lx{.id= .colon,   .loc= slate.source.Loc{.start= 14, .end= 14}},  // 08: `:`
      slate.Lx{.id= .ident,   .loc= slate.source.Loc{.start= 15, .end= 17}},  // 09: `int`
      slate.Lx{.id= .eq,      .loc= slate.source.Loc{.start= 18, .end= 18}},  // 10: `=`
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 19, .end= 19}},  // 11: ` `

      slate.Lx{.id= .ident,   .loc= slate.source.Loc{.start= 20, .end= 25}},  // 12: `return`
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 26, .end= 26}},  // 13: ` `

      slate.Lx{.id= .number,  .loc= slate.source.Loc{.start= 27, .end= 28}},  // 14: `42`
      slate.Lx{.id= .newline, .loc= slate.source.Loc{.start= 29, .end= 29}},  // 15: `\n`
    }; //:: tests.case.Hello42.res.lex

    pub const tok = &[_]M.Tok.Tk{
      minim.Tk{.id= .kw_proc,     .loc= slate.source.Loc{.start=  0, .end=  3}, .indent= 0},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start=  4, .end=  4}, .indent= 0},

      minim.Tk{.id= .b_ident,     .loc= slate.source.Loc{.start=  5, .end=  8}, .indent= 0},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start=  9, .end=  9}, .indent= 0},

      minim.Tk{.id= .sp_star,     .loc= slate.source.Loc{.start= 10, .end= 10}, .indent= 0},
      minim.Tk{.id= .sp_paren_L,  .loc= slate.source.Loc{.start= 11, .end= 11}, .indent= 0},
      minim.Tk{.id= .sp_paren_R,  .loc= slate.source.Loc{.start= 12, .end= 12}, .indent= 0},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 13, .end= 13}, .indent= 0},

      minim.Tk{.id= .sp_colon,    .loc= slate.source.Loc{.start= 14, .end= 14}, .indent= 0},
      minim.Tk{.id= .b_ident,     .loc= slate.source.Loc{.start= 15, .end= 17}, .indent= 0},
      minim.Tk{.id= .sp_eq,       .loc= slate.source.Loc{.start= 18, .end= 18}, .indent= 0},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 19, .end= 19}, .indent= 0},

      minim.Tk{.id= .kw_return,   .loc= slate.source.Loc{.start= 20, .end= 25}, .indent= 0},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 26, .end= 26}, .indent= 0},

      minim.Tk{.id= .b_number,    .loc= slate.source.Loc{.start= 27, .end= 28}, .indent= 0},
      minim.Tk{.id= .wht_newline, .loc= slate.source.Loc{.start= 29, .end= 29}, .indent= 0},
    }; //:: tests.case.Hello42.res.tok

    pub fn ast () !M.Ast {
      var result  = try M.Ast.create.empty(.Zig, case.Hello42.src, t.A);
      var body    = try M.Ast.Proc.Body.create(t.A);
      const scope = slate.Depth{.indent= 0, .scope= .from(1)};
      try body.add(M.Ast.Stmt.Return.create(M.Ast.Expr.Literal.Int.create(case.Hello42.res.lex[14].loc, scope), scope));
      _= try result.add_node(M.Ast.Node{.Proc= M.Ast.Proc{
        .name   = M.Ast.Proc.Name{.name= case.Hello42.res.lex[2].loc},
        .public = true,
        .ret    = .{.type= try result.add_type(M.Ast.Type{.any= M.Ast.Type.Any{
          .name = case.Hello42.res.lex[9].loc,
          }})},
        .body   = try result.add_stmts(body),
        .depth  = slate.Depth{.indent= 0, .scope= .Root},
        }});
      return result;
    } //:: tests.case.Hello42.res.ast
  }; //:: tests.case.Hello42.res
}; //:: tests.case.Hello42

pub const HelloIndentation = struct {
  pub const src :slate.source.Code=
    \\proc main *() :int=
    \\  return 42
    ;
  pub const res = struct {
    pub const lex = &[_]slate.Lx{
      slate.Lx{.id= .ident, .  loc= slate.source.Loc{.start=  0, .end=  3}},  // 00: `proc`
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start=  4, .end=  4}},  // 01: ` `

      slate.Lx{.id= .ident, .  loc= slate.source.Loc{.start=  5, .end=  8}},  // 02: `main`
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start=  9, .end=  9}},  // 03: ` `

      slate.Lx{.id= .star,    .loc= slate.source.Loc{.start= 10, .end= 10}},  // 04: `*`
      slate.Lx{.id= .paren_L, .loc= slate.source.Loc{.start= 11, .end= 11}},  // 05: `(`
      slate.Lx{.id= .paren_R, .loc= slate.source.Loc{.start= 12, .end= 12}},  // 06: `)`
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 13, .end= 13}},  // 07: ` `

      slate.Lx{.id= .colon,   .loc= slate.source.Loc{.start= 14, .end= 14}},  // 08: `:`
      slate.Lx{.id= .ident,   .loc= slate.source.Loc{.start= 15, .end= 17}},  // 09: `int`
      slate.Lx{.id= .eq,      .loc= slate.source.Loc{.start= 18, .end= 18}},  // 10: `=`
      slate.Lx{.id= .newline, .loc= slate.source.Loc{.start= 19, .end= 19}},  // 11: `\n`

      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 20, .end= 20}},  // 12: ` `
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 21, .end= 21}},  // 12: ` `
      slate.Lx{.id= .ident,   .loc= slate.source.Loc{.start= 22, .end= 27}},  // 14: `return`

      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 28, .end= 28}},  // 15: ` `
      slate.Lx{.id= .number,  .loc= slate.source.Loc{.start= 29, .end= 30}},  // 16: `42`
    }; //:: tests.case.HelloIndentation.res.lex

    pub const tok = &[_]M.Tok.Tk{
      minim.Tk{.id= .kw_proc,     .loc= slate.source.Loc{.start=  0, .end=  3}, .indent= 0},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start=  4, .end=  4}, .indent= 0},

      minim.Tk{.id= .b_ident,     .loc= slate.source.Loc{.start=  5, .end=  8}, .indent= 0},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start=  9, .end=  9}, .indent= 0},

      minim.Tk{.id= .sp_star,     .loc= slate.source.Loc{.start= 10, .end= 10}, .indent= 0},
      minim.Tk{.id= .sp_paren_L,  .loc= slate.source.Loc{.start= 11, .end= 11}, .indent= 0},
      minim.Tk{.id= .sp_paren_R,  .loc= slate.source.Loc{.start= 12, .end= 12}, .indent= 0},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 13, .end= 13}, .indent= 0},

      minim.Tk{.id= .sp_colon,    .loc= slate.source.Loc{.start= 14, .end= 14}, .indent= 0},
      minim.Tk{.id= .b_ident,     .loc= slate.source.Loc{.start= 15, .end= 17}, .indent= 0},
      minim.Tk{.id= .sp_eq,       .loc= slate.source.Loc{.start= 18, .end= 18}, .indent= 0},
      minim.Tk{.id= .wht_newline, .loc= slate.source.Loc{.start= 19, .end= 19}, .indent= 0},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 20, .end= 21}, .indent= 0},

      minim.Tk{.id= .kw_return,   .loc= slate.source.Loc{.start= 22, .end= 27}, .indent= 2},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 28, .end= 28}, .indent= 2},

      minim.Tk{.id= .b_number,    .loc= slate.source.Loc{.start= 29, .end= 30}, .indent= 2},
    }; //:: tests.case.HelloIndentation.res.tok

    pub fn ast () !M.Ast {
      var result  = try M.Ast.create.empty(.Zig, case.HelloIndentation.src, t.A);
      var body    = try M.Ast.Proc.Body.create(t.A);
      const scope = slate.Depth{.indent= 2, .scope= .from(1)};
      try body.add(M.Ast.Stmt.Return.create(M.Ast.Expr.Literal.Int.create(case.HelloIndentation.res.lex[16].loc, scope), scope));
      _= try result.add_node(M.Ast.Node{.Proc= M.Ast.Proc{
        .name   = M.Ast.Proc.Name{.name= case.HelloIndentation.res.lex[2].loc},
        .public = true,
        .ret    = .{.type= try result.add_type(M.Ast.Type{.any= M.Ast.Type.Any{
          .name = case.HelloIndentation.res.lex[9].loc,
          }})},
        .body   = try result.add_stmts(body),
        .depth  = slate.Depth{.indent= 0, .scope= .Root},
        }});
      return result;
    } //:: tests.case.HelloIndentation.res.ast
  }; //:: tests.case.HelloIndentation.res
}; //:: tests.case.HelloIndentation

pub const TypeWithPragma = struct {
  pub const src :slate.source.Code=
    \\proc hello (
    \\    one : ptr int;
    \\    two : ptr i32 {.readonly.};
    \\  ) {.importc.} :ptr u64 {.readonly.}=
    \\  return 0
    \\
    ;
  pub const res = struct {
    pub const lex = &[_]slate.Lx{
      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=   0, .end=   3 }}, // 00: `proc`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=   4, .end=   4 }}, // 01: ` `

      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=   5, .end=   9 }}, // 02: `hello`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  10, .end=  10 }}, // 03: ` `

      slate.Lx{.id= .paren_L,   .loc= slate.source.Loc{.start=  11, .end=  11 }}, // 04: `(`
      slate.Lx{.id= .newline,   .loc= slate.source.Loc{.start=  12, .end=  12 }}, // 05: `\n`

      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  13, .end=  13 }}, // 06: ` `
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  14, .end=  14 }}, // 07: ` `
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  15, .end=  15 }}, // 08: ` `
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  16, .end=  16 }}, // 09: ` `
      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=  17, .end=  19 }}, // 10: `one`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  20, .end=  20 }}, // 11: ` `

      slate.Lx{.id= .colon,     .loc= slate.source.Loc{.start=  21, .end=  21 }}, // 12: `:`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  22, .end=  22 }}, // 13: ` `

      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=  23, .end=  25 }}, // 14: `ptr`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  26, .end=  26 }}, // 15: ` `

      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=  27, .end=  29 }}, // 16: `int`
      slate.Lx{.id= .semicolon, .loc= slate.source.Loc{.start=  30, .end=  30 }}, // 17: `;`
      slate.Lx{.id= .newline,   .loc= slate.source.Loc{.start=  31, .end=  31 }}, // 18: `\n`

      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  32, .end=  32 }}, // 19: ` `
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  33, .end=  33 }}, // 20: ` `
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  34, .end=  34 }}, // 21: ` `
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  35, .end=  35 }}, // 22: ` `
      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=  36, .end=  38 }}, // 23: `two`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  39, .end=  39 }}, // 24: ` `

      slate.Lx{.id= .colon,     .loc= slate.source.Loc{.start=  40, .end=  40 }}, // 25: `:`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  41, .end=  41 }}, // 26: ` `

      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=  42, .end=  44 }}, // 27: `ptr`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  45, .end=  45 }}, // 28: ` `

      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=  46, .end=  48 }}, // 29: `i32`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  49, .end=  49 }}, // 30: ` `

      slate.Lx{.id= .brace_L,   .loc= slate.source.Loc{.start=  50, .end=  50 }}, // 31: `{`
      slate.Lx{.id= .dot,       .loc= slate.source.Loc{.start=  51, .end=  51 }}, // 32: `.`
      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=  52, .end=  59 }}, // 33: `readonly`
      slate.Lx{.id= .dot,       .loc= slate.source.Loc{.start=  60, .end=  60 }}, // 34: `.`
      slate.Lx{.id= .brace_R,   .loc= slate.source.Loc{.start=  61, .end=  61 }}, // 35: `}`
      slate.Lx{.id= .semicolon, .loc= slate.source.Loc{.start=  62, .end=  62 }}, // 36: `;`
      slate.Lx{.id= .newline,   .loc= slate.source.Loc{.start=  63, .end=  63 }}, // 37: `\n`

      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  64, .end=  64 }}, // 38: ` `
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  65, .end=  65 }}, // 39: ` `
      slate.Lx{.id= .paren_R,   .loc= slate.source.Loc{.start=  66, .end=  66 }}, // 40: `)`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  67, .end=  67 }}, // 41: ` `

      slate.Lx{.id= .brace_L,   .loc= slate.source.Loc{.start=  68, .end=  68 }}, // 42: `{`
      slate.Lx{.id= .dot,       .loc= slate.source.Loc{.start=  69, .end=  69 }}, // 43: `.`
      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=  70, .end=  76 }}, // 44: `importc`
      slate.Lx{.id= .dot,       .loc= slate.source.Loc{.start=  77, .end=  77 }}, // 45: `.`
      slate.Lx{.id= .brace_R,   .loc= slate.source.Loc{.start=  78, .end=  78 }}, // 46: `}`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  79, .end=  79 }}, // 47: ` `

      slate.Lx{.id= .colon,     .loc= slate.source.Loc{.start=  80, .end=  80 }}, // 48: `:`
      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=  81, .end=  83 }}, // 49: `ptr`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  84, .end=  84 }}, // 50: ` `

      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=  85, .end=  87 }}, // 51: `u64`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  88, .end=  88 }}, // 52: ` `

      slate.Lx{.id= .brace_L,   .loc= slate.source.Loc{.start=  89, .end=  89 }}, // 53: `{`
      slate.Lx{.id= .dot,       .loc= slate.source.Loc{.start=  90, .end=  90 }}, // 54: `.`
      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=  91, .end=  98 }}, // 55: `readonly`
      slate.Lx{.id= .dot,       .loc= slate.source.Loc{.start=  99, .end=  99 }}, // 56: `.`
      slate.Lx{.id= .brace_R,   .loc= slate.source.Loc{.start= 100, .end= 100 }}, // 57: `}`
      slate.Lx{.id= .eq,        .loc= slate.source.Loc{.start= 101, .end= 101 }}, // 58: `=`
      slate.Lx{.id= .newline,   .loc= slate.source.Loc{.start= 102, .end= 102 }}, // 59: `\n`

      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start= 103, .end= 103 }}, // 60: ` `
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start= 104, .end= 104 }}, // 61: ` `
      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start= 105, .end= 110 }}, // 62: `return`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start= 111, .end= 111 }}, // 63: ` `

      slate.Lx{.id= .number,    .loc= slate.source.Loc{.start= 112, .end= 112 }}, // 64: `0`
      slate.Lx{.id= .newline,   .loc= slate.source.Loc{.start= 113, .end= 113 }}, // 65: `\n`
    }; //:: tests.case.bugs.TypeWithPragma.res.lex

    pub const tok = &[_]M.Tok.Tk{
      minim.Tk{.id= .kw_proc,       .loc= slate.source.Loc{.start=   0, .end=   3 }}, // 00: `proc`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=   4, .end=   4 }}, // 01: ` `

      minim.Tk{.id= .b_ident,       .loc= slate.source.Loc{.start=   5, .end=   9 }}, // 02: `hello`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  10, .end=  10 }}, // 03: ` `

      minim.Tk{.id= .sp_paren_L,    .loc= slate.source.Loc{.start=  11, .end=  11 }}, // 04: `(`
      minim.Tk{.id= .wht_newline,   .loc= slate.source.Loc{.start=  12, .end=  12 }}, // 05: `\n`

      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  13, .end=  16 }}, // 06: `    `
      minim.Tk{.id= .b_ident,       .loc= slate.source.Loc{.start=  17, .end=  19 }}, // 07: `one`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  20, .end=  20 }}, // 08: ` `

      minim.Tk{.id= .sp_colon,      .loc= slate.source.Loc{.start=  21, .end=  21 }}, // 09: `:`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  22, .end=  22 }}, // 10: ` `

      minim.Tk{.id= .kw_ptr,        .loc= slate.source.Loc{.start=  23, .end=  25 }}, // 11: `ptr`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  26, .end=  26 }}, // 12: ` `

      minim.Tk{.id= .b_ident,       .loc= slate.source.Loc{.start=  27, .end=  29 }}, // 13: `int`
      minim.Tk{.id= .sp_semicolon,  .loc= slate.source.Loc{.start=  30, .end=  30 }}, // 14: `;`
      minim.Tk{.id= .wht_newline,   .loc= slate.source.Loc{.start=  31, .end=  31 }}, // 15: `\n`

      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  32, .end=  35 }}, // 16: `    `
      minim.Tk{.id= .b_ident,       .loc= slate.source.Loc{.start=  36, .end=  38 }}, // 17: `two`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  39, .end=  39 }}, // 18: ` `

      minim.Tk{.id= .sp_colon,      .loc= slate.source.Loc{.start=  40, .end=  40 }}, // 19: `:`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  41, .end=  41 }}, // 20: ` `

      minim.Tk{.id= .kw_ptr,        .loc= slate.source.Loc{.start=  42, .end=  44 }}, // 21: `ptr`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  45, .end=  45 }}, // 22: ` `

      minim.Tk{.id= .b_ident,       .loc= slate.source.Loc{.start=  46, .end=  48 }}, // 23: `i32`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  49, .end=  49 }}, // 24: ` `

      minim.Tk{.id= .sp_braceDot_L, .loc= slate.source.Loc{.start=  50, .end=  51 }}, // 25: `{.`
      minim.Tk{.id= .b_ident,       .loc= slate.source.Loc{.start=  52, .end=  59 }}, // 26: `readonly`
      minim.Tk{.id= .sp_braceDot_R, .loc= slate.source.Loc{.start=  60, .end=  61 }}, // 27: `.}`
      minim.Tk{.id= .sp_semicolon,  .loc= slate.source.Loc{.start=  62, .end=  62 }}, // 28: `;`
      minim.Tk{.id= .wht_newline,   .loc= slate.source.Loc{.start=  63, .end=  63 }}, // 29: `\n`

      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  64, .end=  65 }}, // 30: `  `
      minim.Tk{.id= .sp_paren_R,    .loc= slate.source.Loc{.start=  66, .end=  66 }}, // 31: `)`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  67, .end=  67 }}, // 32: ` `

      minim.Tk{.id= .sp_braceDot_L, .loc= slate.source.Loc{.start=  68, .end=  69 }}, // 33: `{.`
      minim.Tk{.id= .b_ident,       .loc= slate.source.Loc{.start=  70, .end=  76 }}, // 34: `importc`
      minim.Tk{.id= .sp_braceDot_R, .loc= slate.source.Loc{.start=  77, .end=  78 }}, // 35: `.}`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  79, .end=  79 }}, // 36: ` `

      minim.Tk{.id= .sp_colon,      .loc= slate.source.Loc{.start=  80, .end=  80 }}, // 37: `:`
      minim.Tk{.id= .kw_ptr,        .loc= slate.source.Loc{.start=  81, .end=  83 }}, // 38: `ptr`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  84, .end=  84 }}, // 39: ` `

      minim.Tk{.id= .b_ident,       .loc= slate.source.Loc{.start=  85, .end=  87 }}, // 40: `u64`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  88, .end=  88 }}, // 41: ` `

      minim.Tk{.id= .sp_braceDot_L, .loc= slate.source.Loc{.start=  89, .end=  90 }}, // 42: `{.`
      minim.Tk{.id= .b_ident,       .loc= slate.source.Loc{.start=  91, .end=  98 }}, // 43: `readonly`
      minim.Tk{.id= .sp_braceDot_R, .loc= slate.source.Loc{.start=  99, .end= 100 }}, // 44: `.}`
      minim.Tk{.id= .sp_eq,         .loc= slate.source.Loc{.start= 101, .end= 101 }}, // 45: `=`
      minim.Tk{.id= .wht_newline,   .loc= slate.source.Loc{.start= 102, .end= 102 }}, // 46: `\n`

      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start= 103, .end= 104 }}, // 47: `  `
      minim.Tk{.id= .kw_return,     .loc= slate.source.Loc{.start= 105, .end= 110 }}, // 48: `return`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start= 111, .end= 111 }}, // 49: ` `

      minim.Tk{.id= .b_number,      .loc= slate.source.Loc{.start= 112, .end= 112 }}, // 50: `0`
      minim.Tk{.id= .wht_newline,   .loc= slate.source.Loc{.start= 113, .end= 113 }}, // 51: `\n`
    }; //:: tests.case.TypeWithPragma.res.tok
  }; //:: tests.case.TypeWithPragma.res
}; //:: tests.case.TypeWithPragma

pub const TinyNim = struct {
  pub const src :slate.source.Code=
    \\var x :i32  # Toplevel variable declaration
    \\
    \\proc main *() :i32=
    \\  var arr :array[42, int]  # Unbounded array (conceptually)
    \\  var y :i32 = 0  # Variable declaration with assignment
    \\  while x < 43:
    \\    x = x + 2   # Increment
    \\    x = x - 1   # Decrement
    \\    arr[x] = y  # Store value
    \\    y = arr[x]  # Retrieve value
    \\    if x == 42:
    \\      break
    \\    if x != 42: y = y + 1
    \\  return x
    ;
  pub const res = struct {
    pub const lex = &[_]slate.Lx{
    }; //:: tests.case.bugs.TinyNim.res.lex

    pub const tok = &[_]M.Tok.Tk{
    }; //:: tests.case.TinyNim.res.tok
  }; //:: tests.case.TinyNim.res
}; //:: tests.case.TinyNim

