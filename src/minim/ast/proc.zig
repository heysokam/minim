//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Proc = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps minim.ast
const Ident  = @import("./ident.zig").Ident;
const Stmt   = @import("./statement.zig").Stmt;
const Pragma = @import("./pragma.zig").Pragma;
const Expr   = @import("./expression.zig").Expr;


pure     :bool,
name     :Ident.Name,
public   :bool= false,
args     :?Proc.Arg.List= null,
retT     :?Ident.Type= null,
pragmas  :?Pragma.List,
body     :Proc.Body= undefined,


const Arg = struct {
  type  :Ident.Type,
  name  :Ident.Name,

  const List = struct {
    const Data = zstd.seq(Proc.Arg);
    data :?Data= null,
  };
};

pub const Body = struct {
  data  :Stmt.List,
  pub fn init (A :std.mem.Allocator) @This() { return Body{.data= Stmt.List{.data= Stmt.List.Data.init(A)}}; }
  pub fn add (B :*Proc.Body, val :Stmt) !void { try B.data.data.?.append(val); }
};


/// @descr Returns an empty {@link Proc} object
pub fn newEmpty () Proc {
  return Proc{
    .pure    = false,
    .name    = Ident.Name{.name= "UndefinedProc"},
    .public  = false,
    .args    = null,
    .retT    = Ident.Type.Void.new(),
    .pragmas = null,
    .body    = undefined,
  }; // << Proc{ ... }
}

pub fn new (args :struct {
  pure    :bool,
  name    :cstr,
  public  :bool= false,
  args    :?Proc.Arg.List= null,
  retT    :Ident.Type,
  pragmas :?Pragma.List= null,
  body    :?Proc.Body= null,
}) Proc {
  return Proc{
    .pure    = args.pure,
    .name    = Ident.Name{.name= args.name},
    .public  = args.public,
    .args    = args.args,
    .retT    = args.retT,
    .pragmas = args.pragmas,
    .body    = args.body,
  }; // << Proc{ ... }
}

