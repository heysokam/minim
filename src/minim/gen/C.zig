//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const C = @This();
// @deps std
const std = @import("std");
// @deps slate
const slate = @import("../../lib/slate.zig");
// @deps minim
const Ast  = @import("../ast.zig");
const stmt = @import("./C/statement.zig");

const node = struct {
  const proc = struct {
    fn argument (arg :Ast.Proc.Arg) slate.C.Func.Arg {
      return slate.C.Func.Arg{
        .type= slate.C.Ident.Type{.name= arg.type.any.name, .type= .i32, .mut= arg.mut}, // TODO: Other non-any types
        .name= slate.C.Ident.Name{.name= arg.name.name},
        };
    }

    /// @descr Converts a Minim proc node into a C proc node
    fn get (N :Ast.Node, A :std.mem.Allocator) !slate.C.Ast.Node {
      // Create the Attributes
      var attr = slate.C.Func.Attr.List.create(A);
      if (N.Proc.pure)    try attr.add(slate.C.Func.Attr.Const);
      if (!N.Proc.public) try attr.add(slate.C.Func.Attr.static);
      // Create the Arguments
      var args = slate.C.Func.Arg.List.create(A);
      if (N.Proc.args != null) {
        for (N.Proc.args.?.data.?.items) | arg | {
          try args.add(node.proc.argument(arg));
        }
      } else args.data = null;
      // Create the Body
      var body = slate.C.Func.Body.create(A);
      for (N.Proc.body.data.data.?.items) | S | {
        try body.add(switch (S) {
          .Retrn => stmt.retrn(&S),
        });
      }
      // Create and return the result
      return slate.C.Ast.Node{.Func= slate.C.Func{
        .attr= attr,
        .retT= slate.C.Ident.Type{ .name= N.Proc.retT.?.any.name, .type= .i32, .mut= true },
        .name= slate.C.Ident.Name{ .name= N.Proc.name.name },
        .args= args,
        .body= body,
        }}; // << Func{ ... }
    }
  };
};

pub const proc = node.proc.get;

