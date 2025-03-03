//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../../../minim.zig");
// @deps minim.tests
const t = @import("../../base.zig");
const it = t.it;


var  BasicChecks = t.title("minim.Gen.Zig | Basic Checks");
test BasicChecks { BasicChecks.begin(); defer BasicChecks.end();

try it("dummy check", struct { fn f()!void {
  const ID = "00";
  // Should pass a dummy check
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.eq_str(zm, "");
  try t.eq_str(z,  "");
}}.f);

try it("Basic Code Generation", struct { fn f()!void {
  const ID = "01";
  // Should do basic code generation
  const zm = @embedFile(ID++".zm");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(zm,z);

  try t.check(zm, z, M.Lang.Zig);
}}.f);

} //:: BasicChecks

