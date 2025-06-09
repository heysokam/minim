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

var  Nim = t.title("minim.Tok | Randomized Nim Cases");
test Nim { Nim.begin(); defer Nim.end();

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
  try t.ok(L.res.len >= 1);
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
  try t.ok(L.res.len >= 1);
  // Run
  try T.process();
  // Check
  try t.ok(T.res.len >= 1);
}}.f);

try it("should tokenize arbitrary Nim code without errors", struct { fn f() !void {
  // Setup
  const code = try t.case.Nim.generate(.all);
  defer t.A.free(code);
  var L = try slate.Lex.create(t.A, code);
  defer L.destroy();
  try L.process();
  var T = try M.Tok.create(&L);
  defer T.destroy();
  // Validate
  try t.ok(L.res.len >= 1);
  // Run
  try T.process();
  // Check
  try t.ok(T.res.len >= 1);
}}.f);

} //:: minim.Tok | Randomized Nim Cases

