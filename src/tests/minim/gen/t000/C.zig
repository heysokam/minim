//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../../../minim.zig");
// @deps minim.tests
const t = @import("../../base.zig");
const it = t.it;


var  BasicChecks = t.title("minim.Gen.C | Basic Checks");
test BasicChecks { BasicChecks.begin(); defer BasicChecks.end();

try it("dummy check", struct { fn f()!void {
  const ID = "00";
  // Should pass a dummy check
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.eq_str(cm, "");
  try t.eq_str(c,  "");
}}.f);

try it("Basic Code Generation", struct { fn f()!void {
  const ID = "01";
  // Should do basic code generation
  const cm = @embedFile(ID++".cm");
  const c  = @embedFile(ID++".c");
  try t.not.eq_str(cm,c);

  try t.check(cm, c, M.Lang.C);
}}.f);

} //:: BasicChecks

