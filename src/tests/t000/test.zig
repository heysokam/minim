const std = @import("std");
const expect = std.testing.expect;
const echo = @import("../../zstd.zig").log.echo;
const Lex = @import("../../msyn.zig").Lex;

const Title = "Basic Checks";
test "00 | dummy check" {
  // Should pass a dummy check
  const cm = @embedFile("./00.cm");
  const c = @embedFile("./00.c");
  const z = @embedFile("./00.zig");
  _=cm;_=c;_=z;
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
  try L.process();

  try expect(true);
}

