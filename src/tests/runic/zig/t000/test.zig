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
  const z  = @embedFile(ID++".zig");
  const zm = @embedFile(ID++".zm");
  try t.strEq( z, "");
  try t.strEq(zm, "");
}

// test "01 | Basic Code Generation" {
//   const ID = "01";
//   // Should do basic code generation
//   const zm = @embedFile(ID++".zm");
//   const z  = @embedFile(ID++".zig");
//   try t.ok(!t.eq(u8, zm, z));
//   try t.check(z, zm, runic.Lang.Zig);
// }

