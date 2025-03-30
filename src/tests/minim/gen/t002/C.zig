//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../../../minim.zig");
// @deps minim.tests
const t  = @import("../../base.zig");
const it = t.it;

var  Variables = t.title("minim.Gen.C | Variables");
test Variables { Variables.begin(); defer Variables.end();

try it("Const: Basic definition", struct { fn f()!void {
  const ID = "01";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try it("Const: Public definition", struct { fn f()!void {
  const ID = "02";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try it("Let: Definitions", struct { fn f()!void {
  const ID = "03";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try it("Var: Definitions", struct { fn f()!void {
  const ID = "04";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.todo.it("Return: Identifier", struct { fn f()!void {
  const ID = "05";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Visiblity", struct { fn f()!void {
  const ID = "06";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Assignment: Arrays", struct { fn f()!void {
  const ID = "07";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Assignment: Identifiers", struct { fn f()!void {
  const ID = "08";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Assignment: Literals", struct { fn f()!void {
  const ID = "09";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Assignment: Multi-word Types", struct { fn f()!void {
  const ID = "10";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Assignment: Object Constr", struct { fn f()!void {
  const ID = "11";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Assignment: Union Initialize", struct { fn f()!void {
  const ID = "12";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Assignment: DotExpr values", struct { fn f()!void {
  const ID = "13";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Assignment: Parenthesis", struct { fn f()!void {
  const ID = "14";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Assignment: Dereference", struct { fn f()!void {
  const ID = "15";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Pragma: Persist", struct { fn f()!void {
  const ID = "20";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Pragma: Readonly", struct { fn f()!void {
  const ID = "21";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);
  try t.check(cm, c, M.Lang.C);
}}.f);

} //:: Variables


