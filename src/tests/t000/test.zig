//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../minim.zig");
// @deps minim.tests
const base  = @import("../base.zig");
const eq    = base.eq;
const ok    = base.ok;
const strEq = base.strEq;
const check = base.check;


const Title = "Basic Checks";
test "00 | dummy check" {
  const ID = "00";
  // Should pass a dummy check
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try strEq(cm, "");
  try strEq(c,  "");
  try strEq(zm, "");
  try strEq(z,  "");
}

test "01 | Basic Code Generation" {
  const ID = "01";
  // Should do basic code generation
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try ok(!eq(u8, c,z));
  try ok(!eq(u8, cm,zm));

  try check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}

