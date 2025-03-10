//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../../../minim.zig");
// @deps minim.tests
const t  = @import("../../base.zig");
const it = t.it;

var  StandalonePragmas = t.title("minim.Gen | Standalone Pragmas");
test StandalonePragmas { StandalonePragmas.begin(); defer StandalonePragmas.end();

try t.hide.it("Error", struct { fn f()!void {
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

try t.hide.it("Warning", struct { fn f()!void {
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

try t.hide.it("Emit", struct { fn f()!void {
  const ID = "03";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Namespace", struct { fn f()!void {
  const ID = "04";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Define", struct { fn f()!void {
  const ID = "05";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Fallthrough", struct { fn f()!void {
  const ID = "06";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("C Pragma: once", struct { fn f()!void {
  const ID = "50";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

} //:: StandalonePragmas

