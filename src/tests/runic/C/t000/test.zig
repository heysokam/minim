//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const runic = @import("../../../../runic.zig");
// @deps minim.tests
const t = @import("../../base.zig");


const Title = "Basic Checks";
test "00 | dummy check" {
  const ID = "00";
  // Should pass a dummy check
  const c  = @embedFile(ID++".c");
  const cm = @embedFile(ID++".cm");
  try t.strEq( c, "");
  try t.strEq(cm, "");
}

// test "01 | Basic Code Generation" {
//   const ID = "01";
//   // Should do basic code generation
//   const cm = @embedFile(ID++".cm");
//   const c  = @embedFile(ID++".c");
//   try t.ok(!t.eq(u8, cm, c));
//   try t.check(c, cm, runic.Lang.C);
// }

