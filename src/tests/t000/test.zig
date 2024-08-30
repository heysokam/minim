//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../minim.zig");
// @deps minim.tests
const t = @import("../base.zig");


const Title = "Basic Checks";
test "00 | dummy check" {
  const ID = "00";
  // Should pass a dummy check
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.strEq(cm, "");
  try t.strEq(c,  "");
  try t.strEq(zm, "");
  try t.strEq(z,  "");
}

test "01 | Basic Code Generation" {
  const ID = "01";
  // Should do basic code generation
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.ok(!t.eq(u8, c,z));
  try t.ok(!t.eq(u8, cm,zm));

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}

