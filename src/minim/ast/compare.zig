//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const std = @import("std");
const minim = struct {
  const Ast = @import("../ast.zig").Ast;
};

pub fn equal (A :*const minim.Ast, B :*const minim.Ast) bool {
  if (A.lang != B.lang) return false;
  if (!std.mem.eql(u8, A.src, B.src)) return false;
  if (!A.data.equal(&B.data)) return false;
  return true;
}

