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
    var result = zstd.str.init(t.A);
    try result.appendSlice(src);
    return try result.toOwnedSliceSentinel(0);
  } //:: tests.case.Random.generate
}; //:: tests.case.Random

pub const Hello42 = struct {
  pub const src :slate.source.Code= "proc main *() :int= return 42\n";
  pub const res = struct {
    pub const lex = &[_]slate.Lx{
      slate.Lx{.id= .ident, .  loc= slate.source.Loc{.start=  0, .end=  3}},
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start=  4, .end=  4}},

      slate.Lx{.id= .ident, .  loc= slate.source.Loc{.start=  5, .end=  8}},
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start=  9, .end=  9}},

      slate.Lx{.id= .star,    .loc= slate.source.Loc{.start= 10, .end= 10}},
      slate.Lx{.id= .paren_L, .loc= slate.source.Loc{.start= 11, .end= 11}},
      slate.Lx{.id= .paren_R, .loc= slate.source.Loc{.start= 12, .end= 12}},
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 13, .end= 13}},

      slate.Lx{.id= .colon,   .loc= slate.source.Loc{.start= 14, .end= 14}},
      slate.Lx{.id= .ident,   .loc= slate.source.Loc{.start= 15, .end= 17}},
      slate.Lx{.id= .eq,      .loc= slate.source.Loc{.start= 18, .end= 18}},
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 19, .end= 19}},

      slate.Lx{.id= .ident,   .loc= slate.source.Loc{.start= 20, .end= 25}},
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 26, .end= 26}},

      slate.Lx{.id= .number,  .loc= slate.source.Loc{.start= 27, .end= 28}},
    };

    pub const tok = &[_]M.Tok.Tk{
      minim.Tk{.id= .kw_proc,     .loc= slate.source.Loc{.start=  0, .end=  3}},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start=  4, .end=  4}},

      minim.Tk{.id= .b_ident,     .loc= slate.source.Loc{.start=  5, .end=  8}},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start=  9, .end=  9}},

      minim.Tk{.id= .sp_star,     .loc= slate.source.Loc{.start= 10, .end= 10}},
      minim.Tk{.id= .sp_paren_L,  .loc= slate.source.Loc{.start= 11, .end= 11}},
      minim.Tk{.id= .sp_paren_R,  .loc= slate.source.Loc{.start= 12, .end= 12}},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 13, .end= 13}},

      minim.Tk{.id= .sp_colon,    .loc= slate.source.Loc{.start= 14, .end= 14}},
      minim.Tk{.id= .b_ident,     .loc= slate.source.Loc{.start= 15, .end= 17}},
      minim.Tk{.id= .sp_eq,       .loc= slate.source.Loc{.start= 18, .end= 18}},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 19, .end= 19}},

      minim.Tk{.id= .kw_return,   .loc= slate.source.Loc{.start= 20, .end= 25}},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 26, .end= 26}},

      minim.Tk{.id= .b_number,    .loc= slate.source.Loc{.start= 27, .end= 28}},
      minim.Tk{.id= .wht_newline, .loc= slate.source.Loc{.start= 29, .end= 29}},
    };
  }; //:: tests.case.Hello42.res
}; //:: tests.case.Hello42

pub const HelloIndentation = struct {
  pub const src :slate.source.Code=
    \\proc main *() :int=
    \\  return 42
    ;
  pub const res = struct {
    pub const lex = &[_]slate.Lx{
      slate.Lx{.id= .ident, .  loc= slate.source.Loc{.start=  0, .end=  3}},
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start=  4, .end=  4}},

      slate.Lx{.id= .ident, .  loc= slate.source.Loc{.start=  5, .end=  8}},
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start=  9, .end=  9}},

      slate.Lx{.id= .star,    .loc= slate.source.Loc{.start= 10, .end= 10}},
      slate.Lx{.id= .paren_L, .loc= slate.source.Loc{.start= 11, .end= 11}},
      slate.Lx{.id= .paren_R, .loc= slate.source.Loc{.start= 12, .end= 12}},
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 13, .end= 13}},

      slate.Lx{.id= .colon,   .loc= slate.source.Loc{.start= 14, .end= 14}},
      slate.Lx{.id= .ident,   .loc= slate.source.Loc{.start= 15, .end= 17}},
      slate.Lx{.id= .eq,      .loc= slate.source.Loc{.start= 18, .end= 18}},
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 19, .end= 19}},

      slate.Lx{.id= .ident,   .loc= slate.source.Loc{.start= 20, .end= 25}},
      slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 26, .end= 26}},

      slate.Lx{.id= .number,  .loc= slate.source.Loc{.start= 27, .end= 28}},
    };

    pub const tok = &[_]M.Tok.Tk{
      minim.Tk{.id= .kw_proc,     .loc= slate.source.Loc{.start=  0, .end=  3}},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start=  4, .end=  4}},

      minim.Tk{.id= .b_ident,     .loc= slate.source.Loc{.start=  5, .end=  8}},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start=  9, .end=  9}},

      minim.Tk{.id= .sp_star,     .loc= slate.source.Loc{.start= 10, .end= 10}},
      minim.Tk{.id= .sp_paren_L,  .loc= slate.source.Loc{.start= 11, .end= 11}},
      minim.Tk{.id= .sp_paren_R,  .loc= slate.source.Loc{.start= 12, .end= 12}},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 13, .end= 13}},

      minim.Tk{.id= .sp_colon,    .loc= slate.source.Loc{.start= 14, .end= 14}},
      minim.Tk{.id= .b_ident,     .loc= slate.source.Loc{.start= 15, .end= 17}},
      minim.Tk{.id= .sp_eq,       .loc= slate.source.Loc{.start= 18, .end= 18}},
      minim.Tk{.id= .wht_newline, .loc= slate.source.Loc{.start= 19, .end= 19}},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 20, .end= 21}},

      minim.Tk{.id= .kw_return,   .loc= slate.source.Loc{.start= 22, .end= 27}},
      minim.Tk{.id= .wht_space,   .loc= slate.source.Loc{.start= 28, .end= 28}},

      minim.Tk{.id= .b_number,    .loc= slate.source.Loc{.start= 29, .end= 30}},
    };
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
      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=   0, .end=   3 }}, //  0: `proc`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=   4, .end=   4 }}, //  1: ` `

      slate.Lx{.id= .ident,     .loc= slate.source.Loc{.start=   5, .end=   9 }}, //  2: `hello`
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  10, .end=  10 }}, //  3: ` `

      slate.Lx{.id= .paren_L,   .loc= slate.source.Loc{.start=  11, .end=  11 }}, //  4: `(`
      slate.Lx{.id= .newline,   .loc= slate.source.Loc{.start=  12, .end=  12 }}, //  5: `\n`

      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  13, .end=  13 }}, //  6: ` `
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  14, .end=  14 }}, //  7: ` `
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  15, .end=  15 }}, //  8: ` `
      slate.Lx{.id= .space,     .loc= slate.source.Loc{.start=  16, .end=  16 }}, //  9: ` `
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
      minim.Tk{.id= .kw_proc,       .loc= slate.source.Loc{.start=   0, .end=   3 }}, //  0: `proc`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=   4, .end=   4 }}, //  1: ` `

      minim.Tk{.id= .b_ident,       .loc= slate.source.Loc{.start=   5, .end=   9 }}, //  2: `hello`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  10, .end=  10 }}, //  3: ` `

      minim.Tk{.id= .sp_paren_L,    .loc= slate.source.Loc{.start=  11, .end=  11 }}, //  4: `(`
      minim.Tk{.id= .wht_newline,   .loc= slate.source.Loc{.start=  12, .end=  12 }}, //  5: `\n`

      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  13, .end=  16 }}, //  6: `    `
      minim.Tk{.id= .b_ident,       .loc= slate.source.Loc{.start=  17, .end=  19 }}, //  7: `one`
      minim.Tk{.id= .wht_space,     .loc= slate.source.Loc{.start=  20, .end=  20 }}, //  8: ` `

      minim.Tk{.id= .sp_colon,      .loc= slate.source.Loc{.start=  21, .end=  21 }}, //  9: `:`
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

