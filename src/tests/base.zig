//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std   = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps minim
const M = @import("../minim.zig");


//______________________________________
// @section std Aliases
//____________________________
pub const eq    = std.mem.eql;
pub const ok    = std.testing.expect;
pub const strEq = std.testing.expectEqualStrings;


//______________________________________
// @section Custom checks
//____________________________
pub fn check (src :cstr, trg :cstr, lang :M.Lang) !void {
  // Initialize
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = arena.allocator();
  // Parse
  var ast = try M.Ast.get(src, A);
  defer ast.destroy();
  // Codegen
  var code = switch (lang) {
    .C   => try M.Gen.C(&ast),
    .Zig => try M.Gen.Zig(&ast),
  }; defer code.destroy();
  // Check the result
  const out = try std.fmt.allocPrint(A, "{s}", .{code});
  try ok(ast.lang == lang);
  try ok(!ast.empty());
  try strEq(trg, out);
}

