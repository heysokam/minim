//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../../../minim.zig");
// @deps minim.tests
const t  = @import("../../base.zig");
const it = t.it;

var  Procedures = t.title("minim.Gen.C | Procedures");
test Procedures { Procedures.begin(); defer Procedures.end();

try it("Basic Proc", struct { fn f()!void {
  const ID = "01";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(c,cm);
  try t.check(cm, c, M.Lang.C);
}}.f);

try it("Args: Basic", struct { fn f()!void {
  const ID = "02";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(c,cm);
  try t.check(cm, c, M.Lang.C);
}}.f);

try it("Args: Complex", struct { fn f()!void {
  const ID = "03";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(c,cm);
  try t.check(cm, c, M.Lang.C);
}}.f);




try t.hide.it("Visibility", struct { fn f()!void {
  const ID = "04";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(c,cm);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Varargs", struct { fn f()!void {
  const ID = "05";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(c,cm);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Pragma: inline", struct { fn f()!void {
  const ID = "10";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(c,cm);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Pragma: noreturn", struct { fn f()!void {
  const ID = "11";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(c,cm);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Func: Basic", struct { fn f()!void {
  const ID = "50";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(c,cm);
  try t.check(cm, c, M.Lang.C);
}}.f);

try t.hide.it("Func: pure", struct { fn f()!void {
  const ID = "51";
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(c,cm);
  try t.check(cm, c, M.Lang.C);
}}.f);

} //:: Procedures

