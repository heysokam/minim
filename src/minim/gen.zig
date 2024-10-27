//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Gen = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const str  = zstd.str;
// @deps *Slate
const slate = @import("../lib/slate.zig");
// @deps minim
const M     = @import("../minim.zig");
const rules = @import("./rules.zig");


//____________________________
/// @descr Converts the given minim {@arg ast} into the C programming language.
pub fn C (ast :*const M.Ast) !str {
  var result = zstd.str.init(ast.A);
  try result.appendSlice("TODO: UNIMPLEMENTED | C Codegen");

  // if (ast.empty()) return slate.C.Ast.newEmpty();
  // var result = slate.C.Ast.create(ast.A);
  // for (ast.list.data.?.items) | N | {
  //   switch (N) {
  //   .Proc => try result.add(try generate.C.proc(N, ast.A)),
  //   }
  // }
  return result;
} //:: M.Gen.C


//____________________________
/// @descr Converts the given minim {@arg ast} into the Zig programming language.
pub fn Zig (ast :*const M.Ast) !str {
  std.debug.panic("TODO: UNIMPLEMENTED\n", .{});

  var result = zstd.str.init(ast.A);
  try result.appendSlice("TODO: UNIMPLEMENTED | Zig Codegen");


  // if (ast.empty()) return slate.C.Ast.newEmpty();
  // var result = slate.C.Ast.create(ast.A);
  // for (ast.list.data.?.items) | N | {
  //   switch (N) {
  //   .Proc => try result.add(try generate.C.proc(N, ast.A)),
  //   }
  // }
  return result;
} //:: M.Gen.Zig


//____________________________
/// @descr Converts the given minim {@arg ast} into the {@arg lang} programming language.
pub fn gen (
    ast  : *const M.Ast,
    lang : rules.Lang,
  ) !str {
  switch (lang) {
    .C   => return Gen.C(ast),
    .Zig => return Gen.Zig(ast),
  }
}

