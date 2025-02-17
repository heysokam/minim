//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const t = @This();
// @deps std
const std   = @import("std");
// @deps zdk
const zstd  = @import("../../lib/zstd.zig");
const zstr  = zstd.zstr;
const ztest = @import("ztest");
// @deps minim
const M     = @import("../../minim.zig");
const slate = @import("slate");
const minim = struct {
  const Tk = M.Tok.Tk;
};

//______________________________________
// @section std Aliases
//____________________________
pub const ok     = ztest.ok;
pub const info   = ztest.log.info;
pub const A      = ztest.A;
pub const eq     = ztest.eq;
pub const eq_str = ztest.eq_str;
pub const not    = ztest.not;
pub const it     = ztest.it;
pub const title  = ztest.title;


//______________________________________
// @section Custom checks
//____________________________
pub fn check (src :zstr, trg :zstr, lang :M.Lang) !void {
  const verbose = false;
  // Initialize
  var gpa = std.heap.GeneralPurposeAllocator(std.heap.GeneralPurposeAllocatorConfig{}){};
  defer _ = gpa.deinit();
  var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
  defer arena.deinit();

  const allocator = arena.allocator();
  // const allocator = gpa.allocator();
  // const allocator = t.A;
  // Parse
  var ast = try M.Ast.get2(src, .{.verbose=verbose}, allocator);
  defer ast.destroy();
  // Codegen
  var code = try ast.gen(lang);
  defer code.deinit();
  // Check the result
  if (verbose) zstd.echo(code.items);
  try t.eq(ast.lang, lang);
  try t.eq(ast.empty(), false);
  try t.eq_str(trg, code.items);
}


//______________________________________
// @section Expected Cases
//____________________________
pub const case = struct {
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
  }; //:: tests.base.Hello42.res
}; //:: tests.base.Hello42

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
  }; //:: tests.base.HelloIndentation.res
}; //:: tests.base.HelloIndentation

}; //:: tests.base

