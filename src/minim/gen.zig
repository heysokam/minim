//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Gen = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd   = @import("../lib/zstd.zig");
const string = zstd.string;
// @deps *Slate
const slate  = @import("../lib/slate.zig");
// @deps minim
const M     = @import("../minim.zig");
const rules = @import("./rules.zig");


//____________________________
/// @descr Converts the given minim {@arg ast} into its target programming language.
pub fn gen (ast :*const M.Ast) !string {
  var result = string.create_empty(ast.A);
  for (ast.data.nodes.items()) |N| { switch (ast.lang) {
    .Minim => try slate.Gen.Minim.render(N, ast.src, ast.data.types, &result),
    .Zig   => try slate.Gen  .Zig.render(N, ast.src, ast.data.types, ast.data.pragmas, ast.data.args, ast.data.stmts, &result),
    .C     => try slate.Gen    .C.render(N, ast.src, ast.data.types, ast.data.pragmas, ast.data.args, ast.data.stmts, &result),
    .none  => return error.minim_gen_FoundUnknownTargetLang,
  } try result.add("\n");}
  return result;
}

