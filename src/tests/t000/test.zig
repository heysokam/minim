//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
const expect = std.testing.expect;
// @deps zstd
const echo = @import("../../lib/zstd.zig").log.echo;
const prnt = @import("../../lib/zstd.zig").log.prnt;
const sh   = @import("../../lib/zstd.zig").shell.sh;
// @deps minim
const Lex = @import("../../minim.zig").Lex;


const Title = "Basic Checks";
test "00 | dummy check" {
  // Should pass a dummy check
  const cm = @embedFile("./00.cm");
  const zm = @embedFile("./00.zm");
  const c  = @embedFile("./00.c");
  const z  = @embedFile("./00.zig");
  _=cm;_=c;_=zm;_=z;
  try expect(true);
}

test "01 | Basic Code Generation" {
  // Should do basic code generation
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = arena.allocator();

  const cm = @embedFile("./01.cm");
  const c = @embedFile("./01.c");
  const z = @embedFile("./01.zig");
  _=c;_=z;
  var L = try Lex.create_with(A, cm);
  defer L.destroy();
  try L.process();

  for (L.res.items(.id), L.res.items(.val)) | id, val | {
    std.debug.print("{s} : {s}\n", .{@tagName(id), val.items});
  }
  // try expect(std.mem.eql(u8, L.res.items(.val).items, c));
}

