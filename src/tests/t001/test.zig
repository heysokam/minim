//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../minim.zig");
// @deps minim.tests
const t = @import("../base.zig");

const Title = "Procedures";

test "01 | Basic Proc" {
  const ID = "01";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.ok(!t.eq(u8, c,z));
  try t.strEq(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}

test "02 | Args: Basic" {
  const ID = "02";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.ok(!t.eq(u8, c,z));
  try t.ok(!t.eq(u8, cm,zm));

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}

test "03 | Args: Complex" {
  const ID = "03";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.ok(!t.eq(u8, c,z));
  try t.ok(!t.eq(u8, cm,zm));

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}

// #_______________________________________
// # @section Test
// #_____________________________
// test name "04 | Visibility"       : check "04"
// test name "05 | Varargs"          : check "05"
// # Pragmas
// test name "10 | Pragma: inline"   : check "10"
// test name "11 | Pragma: noreturn" : check "11"
// # Func
// test name "50 | Func: Basic"      : check "50"
// test name "51 | Func: pure"       : check "51"

