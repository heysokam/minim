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
pub const todo   = ztest.todo;
pub const hide   = ztest.hide;


//______________________________________
// @section Custom checks
//____________________________
pub fn check (src :zstr, trg :zstr, lang :M.Lang) !void {
  const verbose = false;
  // Initialize
  var gpa = std.heap.GeneralPurposeAllocator(std.heap.GeneralPurposeAllocatorConfig{}){};
  var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
  defer arena.deinit();

  // const allocator = arena.allocator();
  // const allocator = gpa.allocator();
  const allocator = t.A;
  // Parse
  var ast = try M.Ast.get2(src, .{.lang=lang, .verbose=verbose}, allocator);
  defer ast.destroy();
  // Codegen
  const code = try ast.gen();
  defer code.deinit();
  // Check the result
  if (verbose) zstd.echo(code.items);
  try t.eq(ast.lang, lang);
  try t.eq(ast.empty(), false);
  try t.eq_str(code.items, trg);
  try t.eq(gpa.deinit(), .ok);
}
//____________________________
pub fn compile (src :zstr, lang :M.Lang) !zstd.cstr {_=lang;
  // Create the C code
  const dir = "./bin/.cache/minim/test";
  const base = dir++"/tmp";
  const srcFile = dir++"/tmp.cm";
  try zstd.files.write(src, srcFile, .{});
  const trg = base;
  // Create the Compilation Command
  var cmd = zstd.shell.Cmd.create(t.A);
  defer cmd.destroy();
  try cmd.addList(&.{"./bin/M", "c", srcFile }); // TODO:  , "--trg:"++trg, });
  zstd.prnt("Running Command:\n  ", .{});
  for (cmd.parts.items) |part| zstd.prnt("{s} ", .{part});
  zstd.prnt("\n", .{});
  try cmd.run();
  return trg;
}
//____________________________
pub fn run (src :zstr, lang :M.Lang) !zstd.shell.Cmd.Result {
  const trg = try t.compile(src, lang);
  var cmd = zstd.shell.Cmd.create(t.A);
  defer cmd.destroy();
  try cmd.add(trg);
  try cmd.exec();
  return try cmd.result.?.clone();
}

//______________________________________
// @section Preset Cases
//____________________________
pub const case = @import("./cases.zig");

