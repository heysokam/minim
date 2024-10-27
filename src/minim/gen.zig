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
/// @descr Converts the given minim {@arg ast} into the {@arg lang} programming language.
pub fn gen (
    ast  : *const M.Ast,
    lang : rules.Lang,
  ) !str {
  var result = zstd.str.init(ast.A);
  for (ast.list.data.?.items) |N| { switch (lang) {
    .Minim => try slate.Gen.Minim.render(N, &result),
    .Zig   => try slate.Gen.Zig.render(N, &result),
    .C     => try slate.Gen.C.render(N, &result),
  } try result.appendSlice("\n");}
  return result;
}

