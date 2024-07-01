//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Func = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const cstr = zstd.cstr;
const Seq  = zstd.Seq;
// @deps minim.ast
const Ident  = @import("./ident.zig");
const Stmt   = @import("./statement.zig");
const Pragma = @import("./pragma.zig").Pragma;
const Expr   = @import("./expression.zig");


pure     :bool,
name     :Ident.Name,
pragmas  :?Pragma.List,
args     :?Func.Arg.List= null,
retT     :?Ident.Type= null,
body     :Func.Body= undefined,


const Arg = struct {
  type  :Ident.Type,
  name  :Ident.Name,

  const List = struct {
    data :?Seq(Func.Arg),
  };
};

pub const Body = struct {
  data  :Stmt.List,
  const Templ = " {{ {s} }}\n";
  pub fn init(A :std.mem.Allocator) @This() { return Body{.data= Stmt.List{.data= Seq(Stmt).init(A)}}; }
  pub fn append(B :*Func.Body, val :Stmt) !void { try B.data.data.?.append(val); }
  pub fn format(B :*const Func.Body, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
    if (B.data.data == null or B.data.data.?.items.len == 0) return;
    try writer.print(Func.Body.Templ, .{B.data});
  }
};


pub fn new(args :struct {
  name   :cstr,
  retT   :cstr,
  body   :?Func.Body= null,
}) Func {

  var A = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer A.deinit();

  const result = "42";

  var body = Func.Body.init(A.allocator());
  try body.append(Stmt.Return.new(Expr.Literal.Int.new(.{ .val= result })));
  return Func{
    .retT= Ident.Type{ .name= args.retT, .type= .i32 },
    .name= Ident.Name{ .name= args.name },
    .body= body,
    }; // << Func{ ... }
}

