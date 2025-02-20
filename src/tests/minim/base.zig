//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const t = @This();
// @deps std
const std   = @import("std");
// @deps zdk
const zstd  = @import("../../lib/zstd.zig");
const zstr  = zstd.zstr;
const ztest = @import("ztest");
// @deps minim
const M = @import("../../minim.zig");

//______________________________________
// @section std Aliases
//____________________________
pub const ok     = ztest.ok;
pub const info   = ztest.log.info;
pub const A      = ztest.A;
pub const eq     = ztest.eq;
pub const eq_str = ztest.eq_str;
pub const not    = ztest.not;
pub const it     = ztest.it;
pub const title  = ztest.title;
pub const skip   = ztest.skip;


//______________________________________
// @section Custom checks
//____________________________
pub fn check (src :zstr, trg :zstr, lang :M.Lang) !void {
  const verbose = false;
  // Initialize
  var gpa = std.heap.GeneralPurposeAllocator(std.heap.GeneralPurposeAllocatorConfig{}){};
  defer _ = gpa.deinit();
  var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
  defer arena.deinit();

  // const allocator = arena.allocator();
  // const allocator = gpa.allocator();
  const allocator = t.A;
  // Parse
  var ast = try M.Ast.get2(src, .{.verbose=verbose}, allocator);
  defer ast.destroy();
  // Codegen
  const code = try ast.gen(lang);
  defer code.deinit();
  // Check the result
  if (verbose) zstd.echo(code.items);
  try t.eq(ast.lang, lang);
  try t.eq(ast.empty(), false);
  try t.eq_str(code.items, trg);
}


//______________________________________
// @section Preset Cases
//____________________________
pub const case = @import("./cases.zig");

