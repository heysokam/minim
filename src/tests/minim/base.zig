//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const t = @This();
// @deps std
const std   = @import("std");
// @deps zdk
const zstd  = @import("../../lib/zstd.zig");
const zstr  = zstd.zstr;
const mtest = @import("minitest");
// @deps minim
const M = @import("../../minim.zig");

//______________________________________
// @section std Aliases
//____________________________
pub const ok     = mtest.ok;
pub const info   = mtest.log.info;
pub const A      = mtest.A;
pub const eq     = mtest.eq;
pub const eq_str = mtest.eq_str;
pub const not    = mtest.not;
pub const it     = mtest.it;
pub const title  = mtest.title;
pub const skip   = mtest.skip;
pub const todo   = mtest.todo;
pub const hide   = mtest.hide;


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
  var code = try ast.gen();
  defer code.destroy();
  // Check the result
  if (verbose) zstd.echo(code.items);
  try t.eq(ast.lang, lang);
  try t.eq(ast.empty(), false);
  try t.eq_str(code.data(), trg);
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
  for (cmd.parts.data()) |part| zstd.prnt("{s} ", .{part});
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

