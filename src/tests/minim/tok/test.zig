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

const Tokenizer = t.title("minim.Tok | General Cases");
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

