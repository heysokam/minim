//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../../../minim.zig");
// @deps minim.tests
const t  = @import("../../base.zig");
const it = t.it;

var  Types = t.title("minim.Gen | Type Definitions");
test Types { Types.begin(); defer Types.end();


//______________________________________
// @section General
//____________________________
try t.hide.it("Basic Typedef", struct { fn f()!void {
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

try t.hide.it("Multiword types", struct { fn f()!void {
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


//______________________________________
// @section Objects
//____________________________
try t.hide.it("Object: Basic", struct { fn f()!void {
  const ID = "10";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Object: Stub", struct { fn f()!void {
  const ID = "11";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Object: With Arrays", struct { fn f()!void {
  const ID = "12";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);


//______________________________________
// @section Procs
//____________________________
try t.hide.it("Proc: Basic", struct { fn f()!void {
  const ID = "20";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Proc: Complex", struct { fn f()!void {
  const ID = "21";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);


//______________________________________
// @section Enums
//____________________________
try t.hide.it("Enum: Basic", struct { fn f()!void {
  const ID = "30";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Enum: Explicit Value", struct { fn f()!void {
  const ID = "31";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Enum: Explicit Values", struct { fn f()!void {
  const ID = "32";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Enum: {.unsafe.}", struct { fn f()!void {
  const ID = "33";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Enum: {.unsafe.} + {.pure.}", struct { fn f()!void {
  const ID = "34";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);


//______________________________________
// @section Unions
//____________________________
try t.hide.it("Union: Basic", struct { fn f()!void {
  const ID = "40";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);

try t.hide.it("Union: Array field types", struct { fn f()!void {
  const ID = "41";
  const cm = @embedFile(ID++".cm");
  const zm = @embedFile(ID++".zm");
  const c  = @embedFile(ID++".c");
  const z  = @embedFile(ID++".zig");
  try t.not.eq_str(c,z);
  try t.eq_str(cm,zm);

  try t.check(cm, c, M.Lang.C);
  // try check(zm, z, M.Lang.Zig); // TODO: Zig compilation support
}}.f);


} //:: Types

