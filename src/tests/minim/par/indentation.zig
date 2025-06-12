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

var  Indentation = t.title("minim.Par | Indentation");
test Indentation { Indentation.begin(); defer Indentation.end();

try it("must add the expected depth levels for each node in the Hello42 case", struct { fn f() !void {
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
  var result = try t.case.Hello42.res.ast();
  defer result.destroy();
  // ........ I,S
  // proc   : 0,.Root
  try t.eq(
    P.res.data.nodes.items()[0].Proc.depth.indent,
    result.data.nodes.items()[0].Proc.depth.indent);
  try t.eq(
    P.res.data.nodes.items()[0].Proc.depth.scope,
    result.data.nodes.items()[0].Proc.depth.scope);
  // main   : 0,.Root
  try t.eq(
    P.res.data.nodes.items()[0].Proc.name.depth.indent,
    result.data.nodes.items()[0].Proc.name.depth.indent);
  try t.eq(
    P.res.data.nodes.items()[0].Proc.name.depth.scope,
    result.data.nodes.items()[0].Proc.name.depth.scope);
  // int    : 0,.Root
  try t.eq(
    P.res.data.types.items()[0].any.depth.indent,
    result.data.types.items()[0].any.depth.indent);
  try t.eq(
    P.res.data.types.items()[0].any.depth.scope,
    result.data.types.items()[0].any.depth.scope);
  // ........
  // return : 0,1
  try t.eq(
    P.res.data.stmts.items()[0].items()[0].Retrn.depth.indent,
    result.data.stmts.items()[0].items()[0].Retrn.depth.indent);
  try t.eq(
    P.res.data.stmts.items()[0].items()[0].Retrn.depth.scope,
    result.data.stmts.items()[0].items()[0].Retrn.depth.scope);
  // 42     : 0,1
  try t.eq(
    P.res.data.stmts.items()[0].items()[0].Retrn.body.?.Lit.Intgr.depth.indent,
    result.data.stmts.items()[0].items()[0].Retrn.body.?.Lit.Intgr.depth.indent);
  try t.eq(
    P.res.data.stmts.items()[0].items()[0].Retrn.body.?.Lit.Intgr.depth.scope,
    result.data.stmts.items()[0].items()[0].Retrn.body.?.Lit.Intgr.depth.scope);
}}.f);

try it("must add the expected depth levels for each node in the HelloIndentation case", struct { fn f() !void {
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
  var result = try t.case.HelloIndentation.res.ast();
  defer result.destroy();
  // ........ I,S
  // proc   : 0,.Root
  try t.eq(
    P.res.data.nodes.items()[0].Proc.depth.indent,
    result.data.nodes.items()[0].Proc.depth.indent);
  try t.eq(
    P.res.data.nodes.items()[0].Proc.depth.scope,
    result.data.nodes.items()[0].Proc.depth.scope);
  // main   : 0,.Root
  try t.eq(
    P.res.data.nodes.items()[0].Proc.name.depth.indent,
    result.data.nodes.items()[0].Proc.name.depth.indent);
  try t.eq(
    P.res.data.nodes.items()[0].Proc.name.depth.scope,
    result.data.nodes.items()[0].Proc.name.depth.scope);
  // int    : 0,.Root
  try t.eq(
    P.res.data.types.items()[0].any.depth.indent,
    result.data.types.items()[0].any.depth.indent);
  try t.eq(
    P.res.data.types.items()[0].any.depth.scope,
    result.data.types.items()[0].any.depth.scope);
  // ........
  // return : 2,1
  try t.eq(
    P.res.data.stmts.items()[0].items()[0].Retrn.depth.indent,
    result.data.stmts.items()[0].items()[0].Retrn.depth.indent);
  try t.eq(
    P.res.data.stmts.items()[0].items()[0].Retrn.depth.scope,
    result.data.stmts.items()[0].items()[0].Retrn.depth.scope);
  // 42     : 2,1
  try t.eq(
    P.res.data.stmts.items()[0].items()[0].Retrn.body.?.Lit.Intgr.depth.indent,
    result.data.stmts.items()[0].items()[0].Retrn.body.?.Lit.Intgr.depth.indent);
  try t.eq(
    P.res.data.stmts.items()[0].items()[0].Retrn.body.?.Lit.Intgr.depth.scope,
    result.data.stmts.items()[0].items()[0].Retrn.body.?.Lit.Intgr.depth.scope);
}}.f);

} //:: minim.Par | Indentation

