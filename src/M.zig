//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
const assert = std.debug.assert;
// @deps z*std
const zstd = @import("./lib/zstd.zig");
// @deps minim
const M = @import("./minim.zig");


//______________________________________
/// @section Entry Point
//____________________________
pub fn main() !void {
  // zstd.sh("echo", "\"1234\"");
  // zstd.sh("diff", "\"--git ./build\"");
  // try zstd.echo("Some stuff");
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = arena.allocator();

  var L = M.Lex.create(A);
  defer L.destroy();
}

