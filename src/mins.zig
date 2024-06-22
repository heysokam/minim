//:____________________________________________________________________
//  mins  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
// @deps std
const std = @import("std");
const assert = std.debug.assert;
// @deps z*std
const zstd = @import("./zstd.zig");
// @deps mins
pub const Lex = @import("./mins/lex.zig").Lex;
pub const Par = @import("./mins/par.zig").Par;
pub const Ast = @import("./mins/ast.zig").Ast;
pub const Gen = @import("./mins/gen.zig").Gen;


//______________________________________
/// @section Entry Point
//____________________________
pub fn main() !void {
  try zstd.echo("Some stuff");
  // Use your favorite allocator
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = arena.allocator();

  var L = Lex.create(A);
  defer L.destroy();
}

