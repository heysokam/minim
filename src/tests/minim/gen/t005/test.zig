//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../../../minim.zig");
// @deps minim.tests
const t  = @import("../../base.zig");
const it = t.it;

var  Discard = t.title("Discard");
test Discard { Discard.begin(); defer Discard.end();

try t.hide.it("Single identifier", struct { fn f()!void {
  const ID = "01";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Multi identifier", struct { fn f()!void {
  const ID = "02";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

} //:: Discard

