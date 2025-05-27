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

var  General = t.title("minim.Par | General Cases");
test General { General.begin(); defer General.end();

try it("should create the expected AST for the Hello42 case", struct { fn f() !void {
  // Setup
  const code = t.case.Hello42.src;
  var L = try slate.Lex.create(t.A, code);
  defer L.destroy();
  try L.process();
  var T = try M.Tok.create(&L);
  defer T.destroy();
  try T.process();
  var P = try M.Par.create(&T, .Zig);
  defer P.destroy();
  // Validate
  try t.eq(L.res.len, t.case.Hello42.res.lex.len);
  try t.eq(T.res.len, t.case.Hello42.res.tok.len);
  // Run
  try P.process();
  // Check
  var Expected = try t.case.Hello42.res.ast();
  defer Expected.destroy();
  try t.ok(P.res.equal(&Expected));
}}.f);

try it("should create the expected AST for the HelloIndentation case", struct { fn f() !void {
  // Setup
  const code = t.case.HelloIndentation.src;
  var L = try slate.Lex.create(t.A, code);
  defer L.destroy();
  try L.process();
  var T = try M.Tok.create(&L);
  defer T.destroy();
  try T.process();
  var P = try M.Par.create(&T, .Zig);
  defer P.destroy();
  // Validate
  try t.eq(L.res.len, t.case.HelloIndentation.res.lex.len);
  try t.eq(T.res.len, t.case.HelloIndentation.res.tok.len);
  // Run
  try P.process();
  // Check
  var Expected = try t.case.HelloIndentation.res.ast();
  defer Expected.destroy();
  try t.ok(P.res.equal(&Expected));
}}.f);

} //:: minim.Par | General Cases

