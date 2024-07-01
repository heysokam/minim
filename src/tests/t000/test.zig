//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std    = @import("std");
const expect = std.testing.expect;
const eq     = std.mem.eql;
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const echo = zstd.echo;
const prnt = zstd.prnt;
const sh   = zstd.sh;
// @deps minim
const Lex = @import("../../lib/slate.zig").Lex;
const Tok = @import("../../minim.zig").Tok;


const Title = "Basic Checks";
test "00 | dummy check" {
  // Should pass a dummy check
  const cm = @embedFile("./00.cm");
  const zm = @embedFile("./00.zm");
  const c  = @embedFile("./00.c");
  const z  = @embedFile("./00.zig");
  try expect(eq(u8, cm, ""));
  try expect(eq(u8, c,  ""));
  try expect(eq(u8, zm, ""));
  try expect(eq(u8, z,  ""));
}

test "01 | Basic Code Generation" {
  // Should do basic code generation
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = arena.allocator();

  const cm = @embedFile("./01.cm");
  const zm = @embedFile("./01.zm");
  const c = @embedFile("./01.c");
  const z = @embedFile("./01.zig");
  try expect(!eq(u8, c,z));
  try expect(!eq(u8, cm,zm));

  // Lexer
  var L = try Lex.create_with(A, cm);
  defer L.destroy();
  try L.process();
  L.report();

  // Tokenizer
  var T = Tok.create(&L);
  defer T.destroy();
  try T.process();
  T.report();
  // try expect(eq(u8, L.res.items(.val).items, c));
}

