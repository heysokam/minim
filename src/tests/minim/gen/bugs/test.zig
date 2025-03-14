//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps minim
const M = @import("../../../../minim.zig");
const slate = @import("slate");
// @deps minim.tests
const t  = @import("../../base.zig");
const it = t.it;

var  Bugs = t.title("minim.Gen | Bug Fixes");
test Bugs { Bugs.begin(); defer Bugs.end();

try it("should generate the correct code for proc return types", struct { fn f()!void {
  // Setup
  const ret      = t.case.Hello42.res.lex[9];
  const code     = t.case.Hello42.src;
  const Expected = ret.from(code);
  // Validate
  try t.eq_str(Expected, "int");
  // Run
  var ast = try M.Ast.get2(code, .{}, t.A);
  defer ast.destroy();
  const result = ast.data.types.at(
    ast.data.nodes.items()[0].Proc.ret.type
  ).?.any.name.from(code);
  // Check
  try t.eq_str(result, Expected);
}}.f);

try it("should generate the correct code for proc return types that have pragmas attached", struct { fn f()!void {
  // Setup
  const code     = t.case.TypeWithPragma.src;
  const Expected = t.case.TypeWithPragma.res.tok[40].from(code);
  // Validate
  try t.eq_str(Expected, "u64");
  // Run
  var ast = try M.Ast.get2(code, .{}, t.A);
  defer ast.destroy();
  const result = ast.data.types.at(
    ast.data.nodes.items()[0].Proc.ret.type
  ).?.any.name.from(code);
  // Check
  try t.eq_str(result, Expected);
}}.f);

try it("should generate the correct code for proc argument types that have pragmas attached", struct { fn f()!void {
  // Setup
  const code     = t.case.TypeWithPragma.src;
  const Expected = t.case.TypeWithPragma.res.tok[23].from(code);
  // Validate
  try t.eq_str(Expected, "i32");
  // Run
  var ast = try M.Ast.get2(code, .{}, t.A);
  defer ast.destroy();
  const arg    = ast.data.get_proc_arg(0,1);
  const typ    = ast.data.get_type(arg.type.?);
  const result = typ.any.name.from(code);
  // Check
  try t.eq_str(result, Expected);
}}.f);

try it("should not leak memory in the process", struct { fn f()!void {
  // Setup
  var gpa = std.heap.GeneralPurposeAllocator(std.heap.GeneralPurposeAllocatorConfig{}){};
  // Run
  var ast = try M.Ast.get2(t.case.Hello42.src, .{}, t.A);
  ast.destroy();
  const result = gpa.deinit();
  // Check
  try t.eq(result, .ok);
}}.f);

} //:: minim.Gen | Bug Fixes

