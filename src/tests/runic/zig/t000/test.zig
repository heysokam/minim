//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../../minim.zig");
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

