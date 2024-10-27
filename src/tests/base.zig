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
  var gpa = std.heap.GeneralPurposeAllocator(std.heap.GeneralPurposeAllocatorConfig{}){};
  defer _ = gpa.deinit();
  var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
  defer arena.deinit();

  // const A = arena.allocator();
  const A = gpa.allocator();
  // const A = std.testing.allocator;
  // Parse
  var ast = try M.Ast.get2(src, .{.verbose=true}, A);
  defer ast.destroy();
  // Codegen
  var code = try ast.gen(lang);
  defer code.deinit();
  // Check the result
  const out = try std.fmt.allocPrint(A, "{s}", .{code.items});
  zstd.echo(out);
  try ok(ast.lang == lang);
  try ok(!ast.empty());
  try strEq(trg, out);
}

