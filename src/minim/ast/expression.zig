//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const cstr = zstd.cstr;
const todo = zstd.todo;


//.......................................................
// Expressions:
// - Can contain Identifiers, Literals and Operators
// - Evaluate to values
// - C: Legal at top level. Zig: Legal at block level
// const Expr = union(enum) {
//   Id  :u8, // todo
//   Lit :u8, // todo
//   Op  :u8, // todo
// };
pub const Expr = union(enum) {
  Lit  :Expr.Literal,

  pub fn format(E :*const Expr, comptime f:[]const u8, o:std.fmt.FormatOptions, writer :anytype) !void {
    switch (E.*) {
      .Lit   => try Expr.Literal.format(&E.Lit,f,o,writer),
    }
  }

  pub const Literal = union(enum) {
    Flt    :Literal.Float,
    Intgr  :Literal.Int,
    Strng  :Literal.String,
    Ch     :Literal.Char,

    const Float = struct {
      val   :cstr,
      size  :todo= null,
      pub fn new(args :struct {
          val : cstr,
        }) Expr {
        return Expr{ .Lit= Expr.Literal{ .Flt= Expr.Literal.Float{ .val= args.val }}};
      }
    };

    pub const Int = struct {
      val    :cstr,
      signed :todo= null,
      size   :todo= null,

      pub fn new(args :struct {
          val : cstr,
        }) Expr {
        return Expr{ .Lit= Expr.Literal{ .Intgr= Expr.Literal.Int{ .val= args.val }}};
      }
    };

    pub const Char = struct {
      val  :cstr,
      const Templ = "'{s}'";
    };

    pub const String = struct {
      val       :cstr,
      multiline :todo= null,
    };
  };
};

