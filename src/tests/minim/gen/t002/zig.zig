//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../../../minim.zig");
// @deps minim.tests
const t  = @import("../../base.zig");
const it = t.it;

var  Variables = t.title("minim.Gen.Zig | Variables");
test Variables { Variables.begin(); defer Variables.end();

try it("Const: Basic definition", struct { fn f()!void {
  const ID = "01";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try it("Const: Public definition", struct { fn f()!void {
  const ID = "02";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.todo.it("Let: Private definition", struct { fn f()!void {
  const ID = "03";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.todo.it("Var: Private definition", struct { fn f()!void {
  const ID = "04";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Return: Identifier", struct { fn f()!void {
  const ID = "05";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Visiblity", struct { fn f()!void {
  const ID = "06";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Assignment: Arrays", struct { fn f()!void {
  const ID = "07";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Assignment: Identifiers", struct { fn f()!void {
  const ID = "08";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Assignment: Literals", struct { fn f()!void {
  const ID = "09";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Assignment: Multi-word Types", struct { fn f()!void {
  const ID = "10";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Assignment: Object Constr", struct { fn f()!void {
  const ID = "11";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Assignment: Union Initialize", struct { fn f()!void {
  const ID = "12";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Assignment: DotExpr values", struct { fn f()!void {
  const ID = "13";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Assignment: Parenthesis", struct { fn f()!void {
  const ID = "14";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Assignment: Dereference", struct { fn f()!void {
  const ID = "15";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Pragma: Persist", struct { fn f()!void {
  const ID = "20";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

try t.hide.it("Pragma: Readonly", struct { fn f()!void {
  const ID = "21";
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);
  try t.check(zm, z, M.Lang.Zig);
}}.f);

} //:: Variables

