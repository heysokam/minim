//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps z*std
const zstd = @import("./lib/zstd.zig");
// @deps minim
const M   = @import("./minim.zig");
const CLI = @import("./minim/cli.zig");


//______________________________________
/// @section Entry Point
//____________________________
pub fn main() !void {
  var A = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer A.deinit();
  zstd.echo("Hello M.");

  var cli = try CLI.init(A.allocator());
  defer cli.destroy();

  const zm =
    \\proc main *() :i32= return 42
    \\
    ;
  const ast = try M.Ast.get(zm, A.allocator());

  const code = try M.Gen.C(&ast);
  if (cli.cfg.verbose) code.report();
}

