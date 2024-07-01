//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Par = @This();
// @deps std
const std = @import("std");
// @deps minim
const M = @import("../minim.zig");

const Tk = @import("./rules.zig").Tk;
A     :std.mem.Allocator,
pos   :usize,
buf   :Tk.List,
res   :M.Ast,

//__________________________
/// @descr Creates a new C.Codegen object from the given {@arg T} Tokenizer contents.
pub fn create(T:*const M.Tok) Par {
  return Par {
    .A   = T.A,
    .pos = 0,
    .buf = T.res,
    .res = M.Ast{ .lang= .C, .list= M.Ast.Node.List{} },
  };
}
//__________________________
/// @descr Frees all resources owned by the Parser object.
pub fn destroy(P:*Par) void {
  P.buf.deinit(P.A);
  P.res.destroy();
}

//__________________________
/// @descr Parser Entry Point
pub fn process(P:*Par) !void {
  while (P.pos < P.buf.len) : (P.pos += 1) {
  }
}

pub fn report(P:*Par) void {
  std.debug.print("--- minim.Parser ---\n", .{});
  if (P.res.list.data != null) {
    for (P.res.list.data.?.items, 0..) | id, val | {
      std.debug.print("{s} : {any}\n", .{@tagName(id), val});
    }
  }
  std.debug.print("--------------------\n", .{});
}

