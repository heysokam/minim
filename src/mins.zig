//:____________________________________________________________________
//  mins  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
// @deps std
const std = @import("std");
const assert = std.debug.assert;
// @deps z*std
const zstd = @import("./zstd.zig");
// @deps msyn
pub const Lex = @import("./msyn/lex.zig").Lex;
pub const Par = @import("./msyn/par.zig").Par;
pub const Ast = @import("./msyn/ast.zig").Ast;
pub const Gen = @import("./msyn/gen.zig").Gen;


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

