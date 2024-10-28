//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std   = @import("std");
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps minim
const runic = @import("../../runic.zig");

//______________________________________
// @section std Aliases
//____________________________
pub const eq    = std.mem.eql;
pub const ok    = std.testing.expect;
pub const strEq = std.testing.expectEqualStrings;

//______________________________________
// @section Custom checks
//____________________________
pub fn check (src :cstr, trg :cstr, lang :runic.Lang) !void {
  const verbose = true;
  // Initialize
  var gpa = std.heap.GeneralPurposeAllocator(std.heap.GeneralPurposeAllocatorConfig{}){};
  defer _ = gpa.deinit();
  var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
  defer arena.deinit();

  // const A = arena.allocator();
  // const A = gpa.allocator();
  const A = std.testing.allocator;
  // Parse
  var ast = try runic.get2(src, lang, .{.verbose=verbose}, A);
  defer ast.destroy();
  // Codegen
  var code = try ast.gen(.Minim);
  defer code.deinit();
  // Check the result
  if (verbose) zstd.echo(code.items);
  try ok(ast.lang == lang);
  try ok(!ast.empty());
  try strEq(trg, code.items);
}

