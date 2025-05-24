//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps minim
const M = @import("../../../minim.zig");
const slate = @import("slate");
// @deps minim.tests
const t  = @import("../base.zig");
const it = t.it;

var  Tokenizer = t.title("minim.Tok | General Cases");
test Tokenizer { Tokenizer.begin(); defer Tokenizer.end();

try it("should create the expected list of tokens for the Hello42 case", struct { fn f() !void {
  // Setup
  const code = t.case.Hello42.src;
  var L = try slate.Lex.create(t.A, code);
  defer L.destroy();
  try L.process();
  var T = try M.Tok.create(&L);
  defer T.destroy();
  // Validate
  // Run
  try T.process();
  // Check
  try t.eq(T.res.len, t.case.Hello42.res.tok.len);
  for (T.res.items(.id), T.res.items(.loc), 0..) |tk, loc, id| {
    const Expected = t.case.Hello42.res.tok[id];
    try t.eq(tk,        Expected.id       );
    try t.eq(loc.start, Expected.loc.start);
    try t.eq(loc.end,   Expected.loc.end  );
  }
}}.f);

try it("should create the expected list of tokens for the HelloIndentation case", struct { fn f() !void {
  // Setup
  const code = t.case.HelloIndentation.src;
  var L = try slate.Lex.create(t.A, code);
  defer L.destroy();
  try L.process();
  var T = try M.Tok.create(&L);
  defer T.destroy();
  // Validate
  // Run
  try T.process();
  // Check
  try t.eq(T.res.len, t.case.HelloIndentation.res.tok.len);
  for (T.res.items(.id), T.res.items(.loc), 0..) |tk, loc, id| {
    const Expected = t.case.HelloIndentation.res.tok[id];
    try t.eq(tk,        Expected.id       );
    try t.eq(loc.start, Expected.loc.start);
    try t.eq(loc.end,   Expected.loc.end  );
  }
}}.f);

} //:: minim.Tok | General Cases

var  Tokenizer_random = t.title("minim.Tok | Randomized Cases");
test Tokenizer_random { Tokenizer_random.begin(); defer Tokenizer_random.end();
try it("should tokenize arbitrary Nim Variables without errors", struct { fn f() !void {
  // Setup
  const code = try t.case.Nim.generate(.variable);
  defer t.A.free(code);
  // defer t.A.free(code);
  var L = try slate.Lex.create(t.A, code);
  defer L.destroy();
  try L.process();
  var T = try M.Tok.create(&L);
  defer T.destroy();
  // Validate
  // Run
  try T.process();
  // Check
  try t.ok(T.res.len >= 1);
}}.f);

try it("should tokenize arbitrary Nim Procs without errors", struct { fn f() !void {
  // Setup
  const code = try t.case.Nim.generate(.proc);
  defer t.A.free(code);
  // defer t.A.free(code);
  var L = try slate.Lex.create(t.A, code);
  defer L.destroy();
  try L.process();
  var T = try M.Tok.create(&L);
  defer T.destroy();
  // Validate
  // Run
  try T.process();
  // Check
  try t.ok(T.res.len >= 1);
}}.f);

try it("should tokenize arbitrary Nim code without errors", struct { fn f() !void {
  // Setup
  const code = try t.case.Nim.generate(.all);
  defer t.A.free(code);
  // defer t.A.free(code);
  var L = try slate.Lex.create(t.A, code);
  defer L.destroy();
  try L.process();
  var T = try M.Tok.create(&L);
  defer T.destroy();
  // Validate
  // Run
  try T.process();
  // Check
  try t.ok(T.res.len >= 1);
}}.f);

} //:: minim.Tok | Randomized Cases

